import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../helpers/helper.dart';
import '../../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../../models/booking.dart';
import '../../models/category.dart';
import '../../models/dto/image_dto.dart';
import '../../models/governorate.dart';
import '../../models/service.dart';
import '../../models/store.dart';
import '../../repositories/booking_repository.dart';
import '../../repositories/store_repository.dart';
import '../../services/authentication_service.dart';
import '../../services/logger_service.dart';
import 'components/add_service_bottomsheet.dart';
import 'components/add_store_bottomsheet.dart';

class MyStoreController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDescriptionController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  XFile? storePicture;
  Store? userStore;
  bool isLoading = true;
  Governorate? _governorate;
  Category? _category;
  int? updateServiceId;
  LatLng? _coordinates;

  List<XFile> serviceGallery = [];

  Governorate? get governorate => _governorate;
  Category? get category => _category;

  LatLng? get coordinates => _coordinates;

  set coordinates(LatLng? value) {
    _coordinates = value;
    update();
  }

  set category(Category? value) {
    _category = value;
    update();
  }

  set governorate(Governorate? value) {
    _governorate = value;
    update();
  }

  MyStoreController({Store? store}) {
    _init(store: store);
  }

  Future<void> _init({Store? store}) async {
    userStore = store ?? await StoreRepository.find.getUserStore();
    isLoading = false;
    update();
  }

  void createStore({bool update = false}) => Get.bottomSheet(AddStoreBottomsheet(isUpdate: update), isScrollControlled: true).then((value) => _clearStoreFields());

  void addService({bool update = false}) => Get.bottomSheet(AddServiceBottomsheet(isUpdate: update), isScrollControlled: true).then((value) => _clearServiceFields());

  Future<void> upsertStore() async {
    Store? result;
    if (userStore == null) {
      result = await StoreRepository.find.addStore(
        Store(
          name: nameController.text,
          description: descriptionController.text,
          governorate: governorate!,
          picture: ImageDTO(file: storePicture!, type: ImageType.image),
          coordinates: coordinates,
        ),
        withBack: true,
      );
    } else {
      result = await StoreRepository.find.updateStore(
        Store(
          id: userStore!.id,
          name: nameController.text,
          description: descriptionController.text,
          governorate: governorate!,
          picture: ImageDTO(file: storePicture!, type: ImageType.image),
          coordinates: coordinates,
        ),
        withBack: true,
      );
    }
    if (result != null) {
      userStore = result;
      update();
    }
  }

  Future<void> upsertService({bool isUpdate = false}) async {
    Service? result;
    if (!isUpdate) {
      result = await StoreRepository.find.addService(
        Service(
          name: serviceNameController.text,
          description: serviceDescriptionController.text,
          category: category!,
          gallery: serviceGallery.map((e) => ImageDTO(file: e, type: ImageType.image)).toList(),
          price: double.tryParse(servicePriceController.text),
        ),
        userStore!,
        withBack: true,
      );
    } else {
      result = await StoreRepository.find.updateService(
        Service(
          id: updateServiceId,
          name: serviceNameController.text,
          description: serviceDescriptionController.text,
          category: category!,
          gallery: serviceGallery.map((e) => ImageDTO(file: e, type: ImageType.image)).toList(),
          price: double.tryParse(servicePriceController.text),
        ),
        userStore!,
        withBack: true,
      );
    }
    if (result != null) {
      userStore!.services = [...userStore!.services?.where((element) => element.id != result?.id).toList() ?? [], result];
      update();
    }
  }

  Future<void> addStorePicture() async {
    try {
      XFile? image;
      final pickerPlatform = ImagePickerPlatform.getPlatformPicker();
      if (foundation.kIsWeb) {
        image = await pickerPlatform.getImageFromSource(source: ImageSource.gallery);
      } else {
        image = await pickerPlatform.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        storePicture = image;
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in addStorePicture:\n$e');
    }
  }

  Future<void> addServicePictures() async {
    try {
      List<XFile>? imageList;
      final pickerPlatform = ImagePickerPlatform.getPlatformPicker();
      if (foundation.kIsWeb) {
        imageList = await pickerPlatform.getMedia();
      } else {
        imageList = await pickerPlatform.pickMultiImage();
      }
      if (imageList != null) {
        serviceGallery = imageList;
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in addServicePictures:\n$e');
    }
  }

  void editStore() {
    nameController.text = userStore?.name ?? '';
    descriptionController.text = userStore?.description ?? '';
    governorate = userStore?.governorate;
    storePicture = userStore?.picture?.file;
    createStore(update: true);
  }

  void editService(Service service) {
    serviceNameController.text = service.name ?? '';
    serviceDescriptionController.text = service.description ?? '';
    servicePriceController.text = service.price.toString();
    serviceGallery = service.gallery?.map((e) => e.file).toList() ?? [];
    category = service.category;
    updateServiceId = service.id;
    addService(update: true);
  }

  void deleteService(Service service) => Helper.openConfirmationDialog(
        title: 'Are you sure you want to delete the service "${service.name}"!',
        onConfirm: () async {
          final result = await StoreRepository.find.deleteService(service);
          if (result) userStore!.services!.removeWhere((element) => element.id == service.id);
          update();
        },
      );

  Future<void> bookService(Service service) async {
    final result = await BookingRepository.find.addBooking(
      booking: Booking(
        service: service,
        date: DateTime.now(),
        totalPrice: service.price ?? 0,
        user: AuthenticationService.find.jwtUserData!,
        note: noteController.text,
        // coupon: coupon,
      ),
    );
    if (result) {
      Get.back();
      Helper.snackBar(message: 'Service has been booked successfully');
    }
    // TODO add service booking
  }

  void _clearStoreFields() {
    nameController.clear();
    descriptionController.clear();
    governorate = null;
    storePicture = null;
    update();
  }

  void _clearServiceFields() {
    serviceNameController.clear();
    serviceDescriptionController.clear();
    servicePriceController.clear();
    serviceGallery = [];
    category = null;
    updateServiceId = null;
    update();
  }

  clearRequestFormFields() {
    noteController.clear();
  }
}
