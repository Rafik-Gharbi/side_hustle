import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/user_database_repository.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/dto/login_dto.dart';
import '../models/dto/profile_dto.dart';
import '../models/dto/user_approve_dto.dart';
import '../models/user.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_exceptions.dart';
import '../services/authentication_service.dart';
import '../services/logger_service.dart';

class UserRepository extends GetxService {
  static UserRepository get find => Get.find<UserRepository>();

  Future<LoginDTO?> login({required User user}) async {
    try {
      final data = user.toLoginJson();
      data.putIfAbsent('isMobile', () => GetPlatform.isMobile);
      final result = await ApiBaseHelper().request(RequestType.post, '/user/signin', body: data);
      return LoginDTO.fromJson(result);
    } on UnauthorisedException {
      Helper.snackBar(title: 'error'.tr, message: 'missing_credentials'.tr);
    } on NotFoundException {
      Helper.snackBar(title: 'error'.tr, message: 'user_not_found'.tr);
    } catch (e) {
      LoggerService.logger?.e('Error occured in login:\n$e');
    }
    return null;
  }

  Future<LoginDTO?> renewJWT({required Map<String, dynamic> token}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/user/renew', body: token);
      return LoginDTO.fromJson(result);
    } on UnauthorisedException {
      await AuthenticationService.find.logout();
      Helper.snackBar(title: 'error'.tr, message: 'session_expired'.tr);
    } catch (e) {
      LoggerService.logger?.e('Error occured in renewJWT:\n$e');
    }
    return null;
  }

  Future<String?> signup({required User user}) async {
    try {
      final data = user.toJson();
      data.putIfAbsent('isMobile', () => GetPlatform.isMobile);
      final result = await ApiBaseHelper().request(RequestType.post, '/user/signup', body: data);
      return result['token'];
    } catch (e) {
      final expectedErrors = ['missing_password', 'User_already_found', 'wrong_number', 'missing_credentials'];
      if (expectedErrors.any((element) => e.toString().contains(element))) {
        Helper.snackBar(title: 'error'.tr, message: expectedErrors.singleWhere((element) => e.toString().contains(element)).tr);
      }
      LoggerService.logger?.e('Error occured in signup:\n$e');
    }
    return null;
  }

  Future<dynamic> verifyOTP(String? phoneNumber, String? email, String? otpCode) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/user/verify-phone', body: {'phoneNumber': phoneNumber, 'code': otpCode, 'email': email});
      return result['message'];
    } on BadRequestException {
      return 'otp_verif_failed';
    } catch (e) {
      LoggerService.logger?.e('Error occurred in verifyOTP:\n$e');
      return null;
    }
  }

  Future<dynamic> verifyEmail(String token, {String? email}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        '/user/verify-mail',
        body: GetPlatform.isMobile ? {'email': email, 'code': token, 'isMobile': true} : {'token': token, 'isMobile': false},
      );
      return result;
    } catch (e) {
      if (e is AppException && e.message == 'already_verified') return e.message;
      LoggerService.logger?.e('Error occurred in verifyEmail:\n$e');
      return null;
    }
  }

  // Future<dynamic> sendMail(MailModel mail) async {
  //   try {
  //     final result = await ApiBaseHelper().request(RequestType.post, '/user/contact-us', body: mail.toJson());
  //     return result;
  //   } catch (e) {
  //     LoggerService.logger?.e('Error occurred in sendMail:\n$e');
  //     return null;
  //   }
  // }

  // Routes requires JWT token

  Future<bool> checkVerifiedUser() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/user/check-verification-user', sendToken: true);
      return result['verified'];
    } catch (e) {
      LoggerService.logger?.e('Error occurred in checkVerifiedUser:\n$e');
      return false;
    }
  }

  Future<bool> resendVerification() async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.get,
        '/user/resend-verification',
        sendToken: true,
        body: {'isMobile': GetPlatform.isMobile},
      );
      return result['message'] != null;
    } on AppException catch (e, _) {
      Helper.snackBar(title: 'error'.tr, message: e.message.toString().tr);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in resendVerification:\n$e');
      return false;
    }
    return false;
  }

  Future<ProfileDTO?> getLoggedInUser() async {
    try {
      ProfileDTO? profileDTO;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/user/profile', sendToken: true);
        profileDTO = ProfileDTO.fromJson(result);
      } else {
        final user = AuthenticationService.find.jwtUserData?.id != null ? await UserDatabaseRepository.find.getUserById(AuthenticationService.find.jwtUserData!.id!) : null;
        if (user != null) {
          profileDTO = ProfileDTO(user: user, subscribedCategories: [], nextUpdateGategory: DateTime.now().add(const Duration(days: 30)));
        }
      }
      if (profileDTO != null) {
        if (MainAppController.find.isConnected) UserDatabaseRepository.find.backupUser(profileDTO.user.toUserCompanion());
        return profileDTO;
      } else {
        return null;
      }
    } catch (e) {
      if (e.toString().contains('user_not_found')) AuthenticationService.find.logout();
      LoggerService.logger?.e('Error occurred in getLoggedInUser:\n$e');
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/user/user-id?id=$id', sendToken: true);
      return User.fromJson(result['user']);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getUserById:\n$e');
      return null;
    }
  }

  Future<User?> linkWithSocial(User user) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/user/social-media', body: user.toSocialJson(), sendToken: true);
      return User.fromJson(result['updatedUser']);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in linkWithSocial:\n$e');
      return null;
    }
  }

  Future<User?> updateUser(User user, {XFile? picture, bool withBack = false}) async {
    try {
      // TODO fix the gov files upload
      List<XFile?>? uploadFiles;
      if (picture != null) uploadFiles = [picture];
      final result = await ApiBaseHelper().request(RequestType.put, '/user/update-profile', body: user.toUpdateJson(), files: uploadFiles, sendToken: true);
      if (withBack) Get.back();
      Helper.snackBar(title: 'success'.tr, message: 'update_profile_success'.tr);
      final currentUser = User.fromJson(result['updatedUser']);
      if (result['jwt'] != null) AuthenticationService.find.initiateCurrentUser(result['jwt'], user: currentUser, refresh: false);
      return currentUser;
    } catch (e) {
      LoggerService.logger?.e('Error occured in updateUser:\n$e');
    }
    return null;
  }

  Future<bool> forgotPassword(String newPassword, String code) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.put, '/user/forgot-password', body: {'newPassword': newPassword, 'code': code}, sendToken: true);
      if (result['message'] == 'done') {
        Get.back(); // Close change password dialog
        Helper.snackBar(title: 'success'.tr, message: 'password_change_success'.tr);
        return true;
      }
    } on AppException catch (e, _) {
      if (e.toString().contains('same_password')) {
        Helper.snackBar(title: 'error'.tr, message: 'same_password'.tr);
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in changePassword:\n$e');
    }
    return false;
  }

  Future<bool> changePassword(String newPassword, String currentPassword) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.put,
        '/user/update-password',
        body: {'newPassword': newPassword, 'currentPassword': currentPassword},
        sendToken: true,
      );
      if (result['message'] == 'done') {
        Get.back(); // Close change password bottomsheet
        Helper.snackBar(title: 'success'.tr, message: 'password_change_success'.tr);
        return true;
      }
    } catch (e) {
      if (e.toString().contains('same_password')) {
        Helper.snackBar(title: 'success'.tr, message: 'provide_different_password'.tr);
      }
      if (e.toString().contains('wrong_password')) {
        Helper.snackBar(title: 'success'.tr, message: 'wrong_provided_password'.tr);
      }
      LoggerService.logger?.e('Error occured in changePassword:\n$e');
    }
    return false;
  }

  Future<bool> sendChangePasswordCode(String email) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/user/email-forgot-password', body: {'email': email});
      if (result['message'] == 'done') return true;
    } catch (e) {
      LoggerService.logger?.e('Error occured in sendChangePasswordCode:\n$e');
    }
    return false;
  }

  Future<bool> subscribeToCategories(List<Category> categories) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, sendToken: true, '/user/subscribe-category', body: {'categories': categories.map((e) => e.toJson()).toList()});
      if (result['message'] == 'done') return true;
    } catch (e) {
      LoggerService.logger?.e('Error occured in subscribeToCategories:\n$e');
    }
    return false;
  }

  Future<bool> uploadUserVerifData({required List<XFile?> identity, XFile? selfie}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, sendToken: true, '/user/verification-data', files: [...identity, selfie]);
      if (result['message'] == 'done') {
        AuthenticationService.find.initiateCurrentUser(result['jwt']);
        return true;
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadUserVerifData:\n$e');
    }
    return false;
  }

  Future<List<UserApproveDTO>?> listUsersApprove() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/user/approve', sendToken: true);
      return (result['users'] as List).map((e) => UserApproveDTO.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occurred in listUsersApprove:\n$e');
      return null;
    }
  }

  Future<bool> approveUser(User user) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.put, sendToken: true, '/user/approve?userId=${user.id}');
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in approveUser:\n$e');
    }
    return false;
  }

  Future<bool> notApprovableUser(User user) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.put, sendToken: true, '/user/not-approvable?userId=${user.id}');
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in notApprovableUser:\n$e');
    }
    return false;
  }
}
