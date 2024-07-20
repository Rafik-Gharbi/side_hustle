import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/helper.dart';
import '../../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../../services/authentication_service.dart';
import '../../services/logger_service.dart';

enum DocumentType { identityCard, passport }

enum VerifPicture { frontIdentity, backIdentity, passport, selfie }

class VerifyUserController extends GetxController {
  bool isOnBoarding = true;
  RxInt timerProgress = 60.obs;
  DocumentType? documentType;
  XFile? selfiePicture;
  XFile? passportPicture;
  XFile? frontIdentityPicture;
  XFile? backIdentityPicture;
  Timer? _timer;
  RxBool isLoadingDataUpload = false.obs;
  bool? uploadDocumentResult;
  bool showTimer = true;

  bool get hasProvidedDocument => documentType == DocumentType.identityCard ? frontIdentityPicture != null && backIdentityPicture != null : passportPicture != null;

  bool get verifProcessIsGood => hasProvidedDocument && selfiePicture != null;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  VerifyUserController() {
    if (AuthenticationService.find.jwtUserData!.isVerified == VerifyIdentityStatus.pending) {
      documentType = DocumentType.passport;
      selfiePicture = XFile('');
      passportPicture = XFile('');
      uploadDocumentResult = true;
      isOnBoarding = false;
      showTimer = false;
    }
  }

  void startVerification() {
    isOnBoarding = false;
    startTimer();
    update();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerProgress.value > 0 && !verifProcessIsGood) {
        timerProgress.value = timerProgress.value - 1;
      } else {
        timer.cancel();
        if (timerProgress.value == 0) {
          Get.back();
          Helper.snackBar(message: 'Time is up, please try again!');
        }
      }
    });
  }

  void setDocumentType(DocumentType document) {
    documentType = document;
    update();
  }

  Future<void> uploadVerifUserPicture({required VerifPicture type}) async {
    try {
      XFile? image;
      final pickerPlatform = ImagePickerPlatform.getPlatformPicker();
      if (kIsWeb) {
        image = await pickerPlatform.getImageFromSource(source: ImageSource.gallery);
      } else {
        image = await pickerPlatform.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        switch (type) {
          case VerifPicture.frontIdentity:
            frontIdentityPicture = image;
            break;
          case VerifPicture.backIdentity:
            backIdentityPicture = image;
            break;
          case VerifPicture.passport:
            passportPicture = image;
            break;
          case VerifPicture.selfie:
            selfiePicture = image;
            _uploadUserData();
            break;
          default:
        }
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadVerifUserPicture:\n$e');
    }
  }

  void clearData() {
    isOnBoarding = true;
    timerProgress = 60.obs;
    documentType = null;
    selfiePicture = null;
    passportPicture = null;
    frontIdentityPicture = null;
    backIdentityPicture = null;
  }

  Future<void> _uploadUserData() async {
    isLoadingDataUpload.value = true;
    final result = await UserRepository.find.uploadUserVerifData(
      identity: documentType == DocumentType.identityCard ? [frontIdentityPicture, backIdentityPicture] : [passportPicture],
      selfie: selfiePicture,
    );
    uploadDocumentResult = result;
    if (result) {
      Helper.snackBar(message: 'Document uploaded successfully');
    } else {
      Helper.snackBar(message: 'Document upload failed');
    }
    isLoadingDataUpload.value = false;
  }
}
