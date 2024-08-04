import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../../models/dto/image_dto.dart';
import '../../models/filter_model.dart';
import '../../models/service.dart';
import '../../models/store.dart';
import '../../models/user.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences.dart';
import '../database.dart';
import 'user_database_repository.dart';

class StoreDatabaseRepository extends GetxService {
  static StoreDatabaseRepository get find => Get.find<StoreDatabaseRepository>();
  final Database database = Database.getInstance();

  // Insert a store  in the database
  Future<Store?> insert(StoreTableCompanion store) async {
    final int storeId = await database.into(database.storeTable).insert(store);
    Store? result = await getStoreById(storeId);
    return result;
  }

  Future<ServiceGalleryTableCompanion?> insertGalleryPicture(ServiceGalleryTableCompanion gallery) async {
    final int galleryId = await database.into(database.serviceGalleryTable).insert(gallery);
    ServiceGalleryTableCompanion? result = await getGalleryById(galleryId);
    return result;
  }

  Future<ServiceTableCompanion?> insertService(ServiceTableCompanion service) async {
    final int serviceId = await database.into(database.serviceTable).insert(service);
    ServiceTableCompanion? result = await getServiceById(serviceId);
    return result;
  }

  // Select all stores in database
  Future<List<Store>> select() async {
    final List<StoreTableData> allStores = await database.select(database.storeTable).get();
    final List<Store> result = <Store>[];
    for (var storeElement in allStores) {
      final Store? store = await _convertStoreTo(storeElement.toCompanion(true));
      if (store != null) result.add(store);
    }
    return result;
  }

  Future<List<Store>> selectWithFilter(Function($StoreTableTable tbl) condition, {bool withFeedback = false}) async {
    final List<StoreTableData> allStores = await (database.select(database.storeTable)..where((tbl) => condition(tbl))).get();
    final List<Store> result = <Store>[];
    for (var storeElement in allStores) {
      final Store? store = await _convertStoreTo(storeElement.toCompanion(true), withFeedback: withFeedback);
      if (store != null) result.add(store);
    }
    return result;
  }

  // Update a store in the database and update the stores list in OverviewController
  Future<void> update(StoreTableCompanion storeCompanion) async {
    await database.update(database.storeTable).replace(storeCompanion);
  }

  Future<void> updateGalleryPicture(ServiceGalleryTableCompanion galleryCompanion) async {
    await database.update(database.serviceGalleryTable).replace(galleryCompanion);
  }

  Future<void> updateService(ServiceTableCompanion serviceCompanion) async {
    await database.update(database.serviceTable).replace(serviceCompanion);
  }

  // Delete a store from both notion and database, returns deleted store id
  Future<int> delete(Store store) async {
    return await database.delete(database.storeTable).delete(store.toStoreCompanion());
  }

  Future<int> deleteGallery(ServiceGalleryTableCompanion gallery) async {
    return await database.delete(database.serviceGalleryTable).delete(gallery);
  }

  Future<Store?> getStoreById(int storeId) async {
    final StoreTableData? store = (await (database.select(database.storeTable)..where((tbl) => tbl.id.equals(storeId))).get()).firstOrNull;
    return store != null ? await _convertStoreTo(store.toCompanion(true)) : null;
  }

  Future<ServiceTableCompanion?> getServiceById(int serviceId) async {
    final ServiceTableData? service = (await (database.select(database.serviceTable)..where((tbl) => tbl.id.equals(serviceId))).get()).firstOrNull;
    return service?.toCompanion(true);
  }

  Future<ServiceGalleryTableCompanion?> getGalleryById(int galleryId) async {
    final ServiceGalleryTableData? gallery = (await (database.select(database.serviceGalleryTable)..where((tbl) => tbl.id.equals(galleryId))).get()).firstOrNull;
    return gallery?.toCompanion(true);
  }

  Future<ServiceGalleryTableCompanion?> getGalleryByUrl(String url) async {
    final ServiceGalleryTableData? gallery = (await (database.select(database.serviceGalleryTable)..where((tbl) => tbl.url.equals(url))).get()).firstOrNull;
    return gallery?.toCompanion(true);
  }

  Future<List<ImageDTO>> getGalleryByServiceId(int serviceId) async {
    final List<ServiceGalleryTableData> gallery = (await (database.select(database.serviceGalleryTable)..where((tbl) => tbl.serviceId.equals(serviceId))).get());
    List<ImageDTO> result = [];
    for (var picture in gallery) {
      result.add(ImageDTO(file: XFile(picture.url), type: ImageType.image));
    }
    return result;
  }

  Future<void> backupStore(Store store, {bool isFavorite = false}) async {
    if (store.id == null) return;
    final existStore = await getStoreById(store.id!);
    if (existStore != null && isFavorite) {
      // update is Favorite
      await update(existStore.toStoreCompanion(isFavoriteUpdate: store.isFavorite));
    } else if (existStore == null) {
      await insert(store.toStoreCompanion());
    }
    // backup store's services if absent, else update
    if (store.services != null && store.services!.isNotEmpty) {
      for (var service in store.services!) {
        final existService = await getServiceById(service.id!);
        if (existService != null) {
          await updateService(existService);
        } else {
          await insertService(service.toServiceCompanion(storeId: store.id!));
        }
        if (service.gallery != null && service.gallery!.isNotEmpty) {
          for (var picture in service.gallery!) {
            final existGallery = await getGalleryByUrl(picture.file.path);
            if (existGallery != null) {
              await updateGalleryPicture(existGallery);
            } else {
              await insertGalleryPicture(picture.toGalleryCompanion(serviceId: service.id));
            }
          }
        }
      }
    }
  }

  Future<void> backupStores(List<Store> stores, {bool isFavorite = false}) async {
    LoggerService.logger?.i('Backing up stores...');
    if (isFavorite) SharedPreferencesService.find.add(favoriteStoresKey, jsonEncode(stores.map((e) => e.id).toList()));
    for (var store in stores) {
      await backupStore(store);
    }
  }

  Future<void> deleteOldStores(List<Store> stores) async {
    LoggerService.logger?.i('Deleting old stores...');
    for (var store in stores) {
      await delete(store);
      // TODO delete store services and gallery
      // store.gallerys?.forEach((element) async => await deleteGallery(element.toGalleryCompanion(storeId: store.id)));
    }
  }

  Future<List<Store>> filterStores(String searchQuery, FilterModel? filter) async {
    LoggerService.logger?.i('Filtering stores (searchQuery: $searchQuery, filter: ${filter.toString()})...');
    final allStores = await select();
    // final allGallerys = await selectGallerys();
    // Helper.snackBar(message: 'All saved gallerys length: ${allGallerys.length}');
    // final allStores = await selectWithFilter((tbl) => tbl.title.contains(searchQuery), withFeedback: true);
    if (searchQuery.isEmpty && (filter == null || !filter.isNotEmpty)) {
      return allStores;
    } else {
      final filtered = allStores
          .where(
            (store) =>
                (searchQuery.isNotEmpty ? (store.name ?? '').contains(searchQuery) : false) ||
                (searchQuery.isNotEmpty ? (store.description ?? '').contains(searchQuery) : false) ||
                (filter!.category != null && store.services != null ? store.services!.any((element) => element.category?.id == filter.category?.id) : false) ||
                (store.services != null && filter.minPrice != null && filter.maxPrice != null
                    ? store.services!.any((element) => element.price! < filter.maxPrice! && element.price! > filter.minPrice!)
                    : false),
            // TODO add nearby filtering
          )
          .toList();
      return filtered;
    }
  }

  Future<List<ServiceGalleryTableData>> _getServiceGallery(ServiceTableCompanion service, {bool withFeedback = false}) async {
    final gallerys = (await (database.select(database.serviceGalleryTable)..where((tbl) => tbl.serviceId.equals(service.id.value))).get());
    if (withFeedback) Helper.snackBar(message: 'Store ${service.name.value} has ${gallerys.length} gallerys');
    return gallerys;
  }

  Future<List<Service>> _getStoreServices(StoreTableCompanion store, {bool withFeedback = false}) async {
    List<Service> result = [];
    final services = (await (database.select(database.serviceTable)..where((tbl) => tbl.store.equals(store.id.value))).get());
    for (var service in services) {
      final gallery = (await _getServiceGallery(service.toCompanion(true))).map((e) => _convertToImageDTO(e)).toList();
      result.add(Service.fromServiceData(service: service.toCompanion(true), gallery: gallery));
    }
    return result;
  }

  Future<Store?> _convertStoreTo(StoreTableCompanion store, {bool withFeedback = false}) async {
    if (store.owner.value == null) return null;
    final User? storeUser = await UserDatabaseRepository.find.getUserById(store.owner.value as int);
    final services = await _getStoreServices(store, withFeedback: withFeedback);
    return Store.fromStoreData(store: store, owner: storeUser ?? User(id: store.owner.value), services: services);
  }

  ImageDTO _convertToImageDTO(ServiceGalleryTableData e) => ImageDTO(file: XFile(e.url), type: ImageType.values.singleWhere((element) => element.name == e.type));

  Future<void> backupService(Service service, Store store) async {
    final foundService = await getServiceById(service.id!);
    if (foundService != null) {
      updateService(service.toServiceCompanion(storeId: store.id!));
    } else {
      insertService(service.toServiceCompanion(storeId: store.id!));
    }
  }
}
