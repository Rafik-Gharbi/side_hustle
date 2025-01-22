import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../controllers/main_app_controller.dart';
import '../database/database_repository/category_database_repository.dart';
import '../database/database_repository/governorate_database_repository.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/coin_pack.dart';
import '../models/dto/report_dto.dart';
import '../models/governorate.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';
import '../widgets/feedback_bottomsheet.dart';
import '../widgets/thank_you_popup.dart';

class ParamsRepository extends GetxService {
  static ParamsRepository get find => Get.find<ParamsRepository>();

  Future<List<Governorate>?> getAllGovernorates() async {
    try {
      List<Governorate>? governorates;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/params/governorates/${Get.locale?.languageCode ?? 'en'}');
        governorates = (result['governorates'] as List).map((e) => Governorate.fromJson(e)).toList();
      } else {
        governorates = await GovernorateDatabaseRepository.find.select();
      }
      if (MainAppController.find.isConnected) GovernorateDatabaseRepository.find.backupGovernorates(governorates);
      return governorates;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getAllGovernorates:\n$e');
    }
    return null;
  }

  Future<List<Category>?> getAllCategories() async {
    try {
      List<Category>? categories;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/params/categories/${Get.locale?.languageCode ?? 'en'}');
        categories = (result['categories'] as List).map((e) => Category.fromJson(e)).toList();
      } else {
        categories = await CategoryDatabaseRepository.find.select();
      }
      if (MainAppController.find.isConnected) CategoryDatabaseRepository.find.backupCategories(categories);
      return categories;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getAllCategories:\n$e');
    }
    return null;
  }

  int getMaxActiveUsers() {
    // TODO
    return 1000;
  }

  Future<void> reportUser(ReportDTO reportDTO) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/params/report', body: reportDTO.toJson(), sendToken: true);
      if (result['done']) {
        Helper.goBack(); // close report dialog
        Helper.snackBar(message: 'report_submitted_successfully'.tr);
      } else {
        Helper.snackBar(message: 'report_failed_submit'.tr);
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in reportUser:\n$e');
    }
  }

  Future<void> submitFeedback(FeedbackEmotion feedback, String comment) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/params/feedback', body: {'feedback': feedback.name, 'comment': comment}, sendToken: true);
      if (result['done']) {
        Helper.goBack();
        Get.dialog(const ThankYouPopup());
      } else {
        Helper.snackBar(message: 'feedback_failed_submit'.tr);
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in submitFeedback:\n$e');
      Helper.snackBar(message: 'feedback_failed_submit'.tr);
    }
  }

  Future<List<CoinPack>?> getCoinsPack() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/params/coin-packs/${Get.locale?.languageCode ?? 'en'}');
      final coins = (result['coins'] as List).map((e) => CoinPack.fromJson(e)).toList();
      return coins;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getCoinsPack:\n$e');
    }
    return null;
  }

  Future<File?> getTermsCondition() async {
    try {
      final response = await ApiBaseHelper().request(RequestType.get, '/terms-condition/${Get.locale?.languageCode ?? 'en'}');
      if (response != null) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File(path.join(dir.path, 'terms & condition.pdf'));
        await file.writeAsBytes(bytes);
        return file;
      }
      return null;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getTermsCondition:\n$e');
    }
    return null;
  }

  Future<File?> getPrivacyPolicy() async {
    try {
      final response = await ApiBaseHelper().request(RequestType.get, '/privacy-policy/${Get.locale?.languageCode ?? 'en'}');
      if (response != null) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File(path.join(dir.path, 'privacy policy.pdf'));
        await file.writeAsBytes(bytes);
        return file;
      }
      return null;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getPrivacyPolicy:\n$e');
    }
    return null;
  }

  Future<double?> getMaxTaskPrice() async {
    try {
      final response = await ApiBaseHelper().request(RequestType.get, '/params/max-task-price');
      return Helper.resolveDouble(response?['max']);
    } catch (e) {
      LoggerService.logger?.e('Error occured in getMaxTaskPrice:\n$e');
    }
    return null;
  }

  Future<double?> getMaxServicePrice() async {
    try {
      final response = await ApiBaseHelper().request(RequestType.get, '/params/max-service-price');
      return Helper.resolveDouble(response?['max']);
    } catch (e) {
      LoggerService.logger?.e('Error occured in getMaxServicePrice:\n$e');
    }
    return null;
  }
}
