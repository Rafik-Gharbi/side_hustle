import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/helper.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logging/logger_service.dart';

enum DocumentType { identityCard, passport }

enum VerifPicture { frontIdentity, backIdentity, passport, selfie }

class VerifyUserController extends GetxController {
  bool isOnBoarding = true;
  DocumentType? documentType;
  XFile? selfiePicture;
  XFile? passportPicture;
  XFile? frontIdentityPicture;
  XFile? backIdentityPicture;
  RxBool isLoadingDataUpload = false.obs;
  bool? uploadDocumentResult;
  RxBool isLoading = false.obs;
  bool hasEnabledNotification = false;

  bool get hasProvidedDocument => documentType == DocumentType.identityCard ? frontIdentityPicture != null && backIdentityPicture != null : passportPicture != null;

  bool get verifProcessIsGood => hasProvidedDocument && selfiePicture != null;

  VerifyUserController() {
    if (AuthenticationService.find.jwtUserData!.isVerified == VerifyIdentityStatus.pending) {
      documentType = DocumentType.passport;
      selfiePicture = XFile('');
      passportPicture = XFile('');
      uploadDocumentResult = true;
      isOnBoarding = false;
    }
    _checkUserNotificationEnabled();
  }

  void startVerification() {
    isOnBoarding = false;
    update();
  }

  void setDocumentType(DocumentType document) {
    documentType = document;
    update();
  }

  Future<void> uploadVerifUserPicture({required VerifPicture type}) async {
    try {
      isLoading.value = true;
      XFile? image = await Helper.pickImage();
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
      isLoading.value = false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadVerifUserPicture:\n$e');
      isLoading.value = false;
    }
  }

  void clearData() {
    isOnBoarding = true;
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
      Helper.snackBar(message: 'document_uploaded_successfully'.tr);
    } else {
      Helper.snackBar(message: 'document_upload_failed'.tr);
    }
    isLoadingDataUpload.value = false;
  }

  Future<void> enableNotifications() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(criticalAlert: true);
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _updateUserNotificationToken();
    }
  }

  Future<void> _updateUserNotificationToken({bool silent = false}) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        final result = await UserRepository.find.updateUserFcmToken(fcmToken);
        if (result && !silent) {
          Helper.snackBar(message: 'notifications_enabled_successfully'.tr);
          hasEnabledNotification = true;
          update();
        }
      }
    } catch (e, s) {
      LoggerService.logger?.e('Error in subscribeToCategories!\nError: $e\nStacktrace: $s');
    }
  }

  void _checkUserNotificationEnabled() {
    hasEnabledNotification = AuthenticationService.find.jwtUserData!.fcmToken == null;
  }
}
