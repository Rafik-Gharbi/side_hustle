import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/main_app_controller.dart';
import '../database/database_repository/store_database_repository.dart';
import '../helpers/helper.dart';
import '../models/dto/service_dto.dart';
import '../models/dto/store_review_dto.dart';
import '../models/filter_model.dart';
import '../models/service.dart';
import '../models/store.dart';
import '../networking/api_base_helper.dart';
import '../services/logging/logger_service.dart';

class StoreRepository extends GetxService {
  static StoreRepository get find => Get.find<StoreRepository>();

  Future<List<Store>?> filterStores({int page = 0, int limit = kLoadMoreLimit, String searchQuery = '', FilterModel? filter, bool withCoordinates = false}) async {
    try {
      List<Store>? stores;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(
          RequestType.get,
          sendToken: true,
          withCoordinates
              ? '/store/filter?withCoordinates=$withCoordinates${filter?.category != null ? '&categoryId=${filter?.category!.id}' : ''}${filter?.minPrice != null ? '&priceMin=${filter?.minPrice}' : ''}${filter?.maxPrice != null ? '&priceMax=${filter?.maxPrice}' : ''}${filter?.nearby != null ? '&nearby=${filter?.nearby}' : ''}'
              : '/store/filter?page=$page&limit=$limit&searchQuery=$searchQuery${filter?.category != null ? '&categoryId=${filter?.category!.id}' : ''}${filter?.minPrice != null ? '&priceMin=${filter?.minPrice}' : ''}${filter?.maxPrice != null ? '&priceMax=${filter?.maxPrice}' : ''}${filter?.nearby != null ? '&nearby=${filter?.nearby}' : ''}',
        );
        stores = (result['formattedList'] as List).map((e) => Store.fromJson(e)).toList();
      } else {
        stores = await StoreDatabaseRepository.find.filterStores(searchQuery, filter);
      }
      if (stores.isNotEmpty && MainAppController.find.isConnected) StoreDatabaseRepository.find.backupStores(stores);
      return stores;
    } catch (e) {
      LoggerService.logger?.e('Error occured in filterStores:\n$e');
    }
    return null;
  }

  Future<Store?> addStore(Store newstore, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        sendToken: true,
        '/store/',
        body: newstore.toJson(),
        files: newstore.picture?.file != null ? [newstore.picture?.file] : null,
      );
      if (withBack) Helper.goBack();
      final store = Store.fromJson(result['store']);
      if (MainAppController.find.isConnected) StoreDatabaseRepository.find.backupStore(store);
      Helper.snackBar(message: 'store_added_successfully'.tr);
      return store;
    } catch (e) {
      Helper.snackBar(message: 'store_add_failed'.tr);
      LoggerService.logger?.e('Error occured in addStore:\n$e');
    }
    return null;
  }

  Future<Service?> addService(Service newService, Store store, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        sendToken: true,
        '/store/service',
        body: newService.toJson(),
        files: newService.gallery?.map((e) => e.file).toList(),
      );
      if (withBack) Helper.goBack();
      final service = Service.fromJson(result['service']);
      if (MainAppController.find.isConnected) StoreDatabaseRepository.find.backupService(service, store);
      Helper.snackBar(message: 'service_added_successfully'.tr);
      return service;
    } catch (e) {
      if (e.toString().contains('service_limit_reached')) {
        Helper.snackBar(title: 'success'.tr, message: 'service_limit_reached'.tr);
        if (withBack) Helper.goBack();
      } else {
        Helper.snackBar(message: 'service_add_failed'.tr);
      }
      LoggerService.logger?.e('Error occured in addService:\n$e');
    }
    return null;
  }

  Future<StoreReviewDTO?> getUserStore() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/store/user');
      return result != null ? StoreReviewDTO.fromJson(result) : null;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserStore:\n$e');
    }
    return null;
  }

  Future<Store?> updateStore(Store updateStore, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, sendToken: true, '/store/update', body: updateStore.toJson(), files: [updateStore.picture?.file]);
      if (withBack) Helper.goBack();
      final store = Store.fromJson(result['store']);
      if (MainAppController.find.isConnected) StoreDatabaseRepository.find.backupStore(store);
      Helper.snackBar(message: 'store_updated_successfully'.tr);
      return store;
    } catch (e) {
      Helper.snackBar(message: 'store_update_failed'.tr);
      LoggerService.logger?.e('Error occured in updateStore:\n$e');
    }
    return null;
  }

  Future<Service?> updateService(Service updateService, Store store, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.put,
        sendToken: true,
        '/store/service',
        body: updateService.toJson(),
        files: updateService.gallery?.map((e) => e.file).toList(),
      );
      if (withBack) Helper.goBack();
      final service = Service.fromJson(result['service']);
      if (MainAppController.find.isConnected) StoreDatabaseRepository.find.backupService(service, store);
      Helper.snackBar(message: 'service_updated_successfully'.tr);
      return service;
    } catch (e) {
      Helper.snackBar(message: 'service_update_failed'.tr);
      LoggerService.logger?.e('Error occured in updateService:\n$e');
    }
    return null;
  }

  Future<bool> deleteService(Service service) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.delete, sendToken: true, '/store/service?serviceId=${service.id}');
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in deleteService:\n$e');
    }
    return false;
  }

  Future<StoreReviewDTO?> getStoreById(int? id) async {
    if (id == null) return null;
    try {
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/store/id/$id');
        return result != null ? StoreReviewDTO.fromJson(result) : null;
      } else {
        final store = await StoreDatabaseRepository().getStoreById(id);
        return StoreReviewDTO(store: store, reviews: []);
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in getStoreById:\n$e');
    }
    return null;
  }

  Future<List<ServiceDTO>> getHotServices() async {
    try {
      List<ServiceDTO>? services;
      final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/store/hot-services');
      services = (result?['hotServices'] as List?)?.map((e) => ServiceDTO.fromJson(e)).toList();
      return services ?? [];
    } catch (e) {
      LoggerService.logger?.e('Error occured in getHotServices:\n$e');
    }
    return [];
  }

  Future<bool> deleteStore() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.delete, sendToken: true, '/store/');
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in deleteStore:\n$e');
    }
    return false;
  }
}
