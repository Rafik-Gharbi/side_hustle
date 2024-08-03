import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../../../models/category.dart';
import '../../../models/user.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logger_service.dart';
import '../../../widgets/categories_bottomsheet.dart';

class ProfileController extends GetxController {
  /// not permanent use with caution
  static ProfileController get find => Get.find<ProfileController>();
  User? loggedInUser;
  bool _isLoading = true;
  XFile? profilePicture;
  bool _isUpdatingProfile = false;
  List<Category> subscribedCategories = [];
  DateTime? nextUpdateGategory;
  int myRequestActionRequired = 0;
  int taskHistoryActionRequired = 0;
  int myStoreActionRequired = 0;
  int approveUsersActionRequired = 0;
  int serviceHistoryActionRequired = 0;

  bool get isLoading => _isLoading;
  bool get isUpdatingProfile => _isUpdatingProfile;

  set isUpdatingProfile(bool value) {
    _isUpdatingProfile = value;
    update();
  }

  set isLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
  }

  ProfileController() {
    init();
  }

  Future<void> init() async {
    final result = await AuthenticationService.find.fetchUserData();
    loggedInUser = result?.user;
    subscribedCategories = result?.subscribedCategories ?? [];
    nextUpdateGategory = result?.nextUpdateGategory;
    myRequestActionRequired = result?.myRequestActionRequired ?? 0;
    taskHistoryActionRequired = result?.taskHistoryActionRequired ?? 0;
    myStoreActionRequired = result?.myStoreActionRequired ?? 0;
    approveUsersActionRequired = result?.approveUsersActionRequired ?? 0;
    serviceHistoryActionRequired = result?.servieHistoryActionRequired ?? 0;
    MainAppController.find.resolveProfileActionRequired();
    if (!MainAppController.find.isBackReachable.value) ApiBaseHelper.find.isLoading = false;
    isLoading = false;
  }

  Future<void> uploadFilePicture({GlobalKey<FormState>? formKey}) async {
    try {
      XFile? image;
      final pickerPlatform = ImagePickerPlatform.getPlatformPicker();
      if (foundation.kIsWeb) {
        image = await pickerPlatform.getImageFromSource(source: ImageSource.gallery);
      } else {
        image = await pickerPlatform.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        profilePicture = image;
        saveProfileInfo(isPictureUpload: true, formKey: formKey);
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadFilePicture:\n$e');
    }
  }

  Future<void> saveProfileInfo({required GlobalKey<FormState>? formKey, bool isPictureUpload = false, User? updatedUserData}) async {
    if (formKey?.currentState?.validate() ?? false || isPictureUpload) {
      // String? phone = loggedInUser!.phone;
      // bool phoneHasBeenChanged = Helper.isNullOrEmpty(loggedInUser?.phone) && phoneController.text.isNotEmpty ||
      //     prefix != null && loggedInUser!.phone != prefix! + phoneController.text.replaceAll(' ', '');
      // if (phoneHasBeenChanged) phone = prefix! + phoneController.text.replaceAll(' ', '');
      isUpdatingProfile = true;
      final updatedUser = await UserRepository.find.updateUser(
        isPictureUpload ? loggedInUser! : updatedUserData!,
        picture: profilePicture,
      );
      if (updatedUser != null) {
        // if (phoneHasBeenChanged) Helper.otpProcess(phone, loggedInUser!.email);
        loggedInUser = updatedUser;
        profilePicture = null;
      }
      isUpdatingProfile = false;
    }
  }

  Future<void> subscribeToCategories(List<Category> category) async {
    subscribedCategories = category;
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await AuthenticationService.find.subscribeToCategories(subscribedCategories, fcmToken);
    update();
  }

  void manageCategoriesSubscription() => subscribedCategories.isEmpty
      ? Helper.openConfirmationDialog(
          title:
              'Here you can subscribe up to 3 categories so that you get a notification if a new task has been created in those categories.\nFirst, you need to allow notifications in your device.',
          onConfirm: () async {
            NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(criticalAlert: true);
            debugPrint('User granted permission: ${settings.authorizationStatus}');
            if (settings.authorizationStatus == AuthorizationStatus.authorized) {
              Get.bottomSheet(
                SizedBox(
                  height: Get.height * 0.8,
                  child: CategoriesBottomsheet(
                    maxSelect: 3,
                    nextUpdate: nextUpdateGategory,
                    selected: subscribedCategories,
                    onSelectCategory: (category) => subscribeToCategories(category),
                  ),
                ),
                isScrollControlled: true,
              );
            }
          },
        )
      : Get.bottomSheet(
          SizedBox(
            height: Get.height * 0.8,
            child: CategoriesBottomsheet(
              maxSelect: 3,
              nextUpdate: nextUpdateGategory,
              selected: subscribedCategories,
              onSelectCategory: (category) => subscribeToCategories(category),
            ),
          ),
          isScrollControlled: true,
        );
}
