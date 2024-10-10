import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/category_database_repository.dart';
import '../database/database_repository/governorate_database_repository.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
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
        final result = await ApiBaseHelper().request(RequestType.get, '/params/governorates');
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
        final result = await ApiBaseHelper().request(RequestType.get, '/params/categories');
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
        Get.back(); // close report dialog
        Helper.snackBar(message: 'Report submitted successfully');
      } else {
        Helper.snackBar(message: 'Failed to submit report');
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in reportUser:\n$e');
    }
  }

  Future<void> submitFeedback(FeedbackEmotion feedback, String comment) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/params/feedback', body: {'feedback': feedback.name, 'comment': comment}, sendToken: true);
      if (result['done']) {
        Get.back();
        Get.dialog(const ThankYouPopup());
      } else {
        Helper.snackBar(message: 'Failed to submit feedback');
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in submitFeedback:\n$e');
      Helper.snackBar(message: 'Failed to submit feedback');
    }
  }
}
