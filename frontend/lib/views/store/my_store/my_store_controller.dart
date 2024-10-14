import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../../helpers/helper.dart';
import '../../../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../../../models/category.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/dto/store_review_dto.dart';
import '../../../models/governorate.dart';
import '../../../models/reservation.dart';
import '../../../models/review.dart';
import '../../../models/service.dart';
import '../../../models/store.dart';
import '../../../models/user.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../repositories/store_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logger_service.dart';
import 'components/add_service_bottomsheet.dart';
import 'components/add_store_bottomsheet.dart';

class MyStoreController extends GetxController {
  /// not permanent, use with caution
  static MyStoreController get find => Get.find<MyStoreController>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDescriptionController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController serviceIncludedController = TextEditingController();
  final TextEditingController serviceNotIncludedController = TextEditingController();
  final TextEditingController serviceNoteController = TextEditingController();
  final TextEditingController serviceTimeFromController = TextEditingController();
  final TextEditingController serviceTimeToController = TextEditingController();
  XFile? storePicture;
  Store? currentStore;
  bool isLoading = true;
  Governorate? _governorate;
  Category? _category;
  String? updateServiceId;
  LatLng? _coordinates;
  Service? highlightedService;
  bool _showAllReviews = false;
  List<Review> storeOwnerReviews = [];

  bool get showAllReviews => _showAllReviews;

  set showAllReviews(bool value) {
    _showAllReviews = value;
    update();
  }

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
    init(store: store);
  }

  Future<void> init({Store? store}) async {
    StoreReviewDTO? result;
    if (store != null) {
      result = await StoreRepository.find.getStoreById(store.id);
    } else {
      result = await StoreRepository.find.getUserStore();
    }
    currentStore = result?.store;
    storeOwnerReviews = result?.reviews ?? [];
    if (Get.arguments != null) highlightedService = currentStore?.services?.cast<Service?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    if (highlightedService != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedService = null;
        update();
      });
    }

    isLoading = false;
    update();
  }

  void createStore({bool update = false}) => AuthenticationService.find.jwtUserData?.isVerified == VerifyIdentityStatus.verified
      ? Get.bottomSheet(AddStoreBottomsheet(isUpdate: update), isScrollControlled: true).then((value) => _clearStoreFields())
      : Helper.snackBar(message: 'verify_profile_msg'.tr);

  void addService({bool update = false}) => Get.bottomSheet(AddServiceBottomsheet(isUpdate: update), isScrollControlled: true).then((value) => _clearServiceFields());

  Future<void> upsertStore() async {
    Store? result;
    final store = Store(
      id: currentStore?.id,
      name: nameController.text,
      description: descriptionController.text,
      governorate: governorate!,
      picture: ImageDTO(file: storePicture!, type: ImageType.image),
      coordinates: coordinates,
    );
    if (currentStore == null) {
      result = await StoreRepository.find.addStore(store, withBack: true);
    } else {
      result = await StoreRepository.find.updateStore(store, withBack: true);
    }
    if (result != null) {
      currentStore = result;
      update();
    }
  }

  Future<void> upsertService({bool isUpdate = false}) async {
    Service? result;
    final service = Service(
      id: updateServiceId,
      name: serviceNameController.text,
      description: serviceDescriptionController.text,
      category: category!,
      gallery: serviceGallery.map((e) => ImageDTO(file: e, type: ImageType.image)).toList(),
      price: double.tryParse(servicePriceController.text),
      included: serviceIncludedController.text,
      notIncluded: serviceNotIncludedController.text,
      notes: serviceNoteController.text,
      timeEstimationFrom: serviceTimeFromController.text.isNotEmpty ? double.tryParse(serviceTimeFromController.text) : null,
      timeEstimationTo: serviceTimeToController.text.isNotEmpty ? double.tryParse(serviceTimeToController.text) : null,
    );
    if (!isUpdate) {
      result = await StoreRepository.find.addService(service, currentStore!, withBack: true);
    } else {
      result = await StoreRepository.find.updateService(service, currentStore!, withBack: true);
    }
    if (result != null) {
      currentStore!.services = [...currentStore!.services?.where((element) => element.id != result?.id).toList() ?? [], result];
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
    nameController.text = currentStore?.name ?? '';
    descriptionController.text = currentStore?.description ?? '';
    governorate = currentStore?.governorate;
    storePicture = currentStore?.picture?.file;
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
        title: 'delete_service_msg'.trParams({'serviceName': service.name!}),
        onConfirm: () async {
          final result = await StoreRepository.find.deleteService(service);
          if (result) currentStore!.services!.removeWhere((element) => element.id == service.id);
          update();
        },
      );

  Future<void> bookService(Service service) async {
    final result = await ReservationRepository.find.addServiceReservation(
      reservation: Reservation(
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
      Helper.snackBar(message: 'service_booked_successfully'.tr);
    }
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

  void openStoreItinerary() {
    if (currentStore?.coordinates == null) return;
    final String googleMapslocationUrl = 'https://www.google.com/maps/search/?api=1&query=${currentStore!.coordinates!.latitude},${currentStore!.coordinates!.longitude}';
    Helper.launchUrlHelper(Uri.encodeFull(googleMapslocationUrl));
  }
}
