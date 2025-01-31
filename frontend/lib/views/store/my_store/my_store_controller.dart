import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/shared_preferences_keys.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/dto/store_review_dto.dart';
import '../../../models/governorate.dart';
import '../../../models/review.dart';
import '../../../models/service.dart';
import '../../../models/store.dart';
import '../../../repositories/store_repository.dart';
import '../../../services/logger_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/tutorials/create_store_tutorial.dart';
import '../../../viewmodel/store_viewmodel.dart';
import 'components/add_store_bottomsheet.dart';
import 'my_store_screen.dart';

class MyStoreController extends GetxController {
  /// not permanent, use with caution
  static MyStoreController get find => Get.find<MyStoreController>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? storePicture;
  RxBool isLoading = true.obs;
  Governorate? _governorate;
  LatLng? _coordinates;
  Service? highlightedService;
  bool _showAllReviews = false;
  List<Review> storeOwnerReviews = [];
  List<TargetFocus> targets = [];
  GlobalKey createStoreBtnKey = GlobalKey();

  bool get showAllReviews => _showAllReviews;

  set showAllReviews(bool value) {
    _showAllReviews = value;
    update();
  }

  Governorate? get governorate => _governorate;

  LatLng? get coordinates => _coordinates;

  set coordinates(LatLng? value) {
    _coordinates = value;
    update();
  }

  set governorate(Governorate? value) {
    _governorate = value;
    update();
  }

  MyStoreController({Store? store}) {
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedCreateStoreTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => Get.currentRoute == MyStoreScreen.routeName && Get.isRegistered<MyStoreController>(), () {
          CreateStoreTutorial.showTutorial();
          update();
        });
      }
    });
    init(store: store);
  }

  Future<void> init({Store? store}) async {
    StoreReviewDTO? result;
    if (store != null) {
      result = await StoreRepository.find.getStoreById(store.id);
    } else {
      result = await StoreRepository.find.getUserStore();
    }
    StoreViewmodel.currentStore = result?.store;
    storeOwnerReviews = result?.reviews ?? [];
    if (Get.arguments != null) {
      highlightedService = StoreViewmodel.currentStore?.services?.cast<Service?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    }
    if (highlightedService != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedService = null;
        update();
      });
    }

    isLoading.value = false;
    update();
  }

  void createStore({bool update = false}) => Helper.verifyUser(
        isVerified: true,
        () => Get.bottomSheet(AddStoreBottomsheet(isUpdate: update), isScrollControlled: true).then((value) => _clearStoreFields()),
      );

  Future<void> upsertStore() async {
    Store? result;
    final store = Store(
      id: StoreViewmodel.currentStore?.id,
      name: nameController.text,
      description: descriptionController.text,
      governorate: governorate!,
      picture: storePicture != null ? ImageDTO(file: storePicture!, type: ImageType.image) : null,
      coordinates: coordinates,
    );
    if (StoreViewmodel.currentStore == null) {
      result = await StoreRepository.find.addStore(store, withBack: true);
      FirebaseAnalytics.instance.logEvent(
        name: 'create_store',
        parameters: {
          'store_title': store.name ?? 'undefined',
          'governorate': store.governorate?.name ?? 'undefined',
        },
      );
    } else {
      result = await StoreRepository.find.updateStore(store, withBack: true);
    }
    if (result != null) {
      StoreViewmodel.currentStore = result;
      update();
    }
  }

  Future<void> addStorePicture() async {
    try {
      XFile? image = await Helper.pickImage();
      if (image != null) {
        storePicture = image;
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in addStorePicture:\n$e');
    }
  }

  void editStore() {
    nameController.text = StoreViewmodel.currentStore?.name ?? '';
    descriptionController.text = StoreViewmodel.currentStore?.description ?? '';
    governorate = StoreViewmodel.currentStore?.governorate;
    storePicture = StoreViewmodel.currentStore?.picture?.file;
    createStore(update: true);
  }

  void _clearStoreFields() {
    nameController.clear();
    descriptionController.clear();
    governorate = null;
    storePicture = null;
    update();
  }

  void openStoreItinerary() {
    if (StoreViewmodel.currentStore?.coordinates == null) return;
    final String googleMapslocationUrl =
        'https://www.google.com/maps/search/?api=1&query=${StoreViewmodel.currentStore!.coordinates!.latitude},${StoreViewmodel.currentStore!.coordinates!.longitude}';
    Helper.launchUrlHelper(Uri.encodeFull(googleMapslocationUrl));
  }

  void deleteStore() {
    Get.back();
    Helper.openConfirmationDialog(
      content: 'delete_store_msg'.tr,
      onConfirm: () async {
        final result = await StoreRepository.find.deleteStore();
        if (result) {
          StoreViewmodel.currentStore = null;
        } else {
          Helper.snackBar(message: 'error_occurred'.tr);
        }
        update();
      },
    );
  }

  void upsertService({required bool isUpdate}) => StoreViewmodel.upsertService(isUpdate: isUpdate, onFinish: update);

  void deleteService(Service service) => StoreViewmodel.deleteService(service, onFinish: update);

  void addServicePictures() => StoreViewmodel.addServicePictures(onFinish: update);

  void editService(Service service) => StoreViewmodel.editService(service, onFinish: update);
}
