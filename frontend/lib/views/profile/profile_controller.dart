import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/main_app_controller.dart';
import '../../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../../networking/api_base_helper.dart';
import '../../repositories/user_repository.dart';
import '../../services/authentication_service.dart';
import '../../services/logger_service.dart';

class ProfileController extends GetxController {
  User? loggedInUser;
  bool _isLoading = true;
  XFile? profilePicture;
  bool _isUpdatingProfile = false;
  List<Category> subscribedCategories = [];
  DateTime? nextUpdateGategory;

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
    await AuthenticationService.find.subscribeToCategories(subscribedCategories);
    update();
  }
}
