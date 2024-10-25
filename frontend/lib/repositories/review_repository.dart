import 'package:get/get.dart';

import '../helpers/helper.dart';
import '../models/review.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class ReviewRepository extends GetxService {
  static ReviewRepository get find => Get.find<ReviewRepository>();

  Future<List<Review>?> getReviewByUserId(int userId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/review/$userId', sendToken: true);
      final review = (result['formattedList'] as List).map((e) => Review.fromJson(e)).toList();
      return review;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReview:\n$e');
    }
    return null;
  }

  Future<Review?> addReview(Review newReview, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        sendToken: true,
        '/review/',
        body: newReview.toJson(),
        files: newReview.picture?.file != null ? [newReview.picture?.file] : [],
      );
      if (withBack) Helper.goBack();
      final review = Review.fromJson(result['review']);
      Helper.snackBar(message: 'review_added_successfully'.tr);
      return review;
    } catch (e) {
      Helper.snackBar(message: 'review_add_failed'.tr);
      LoggerService.logger?.e('Error occured in addReview:\n$e');
    }
    return null;
  }

  Future<Review?> updateReview(Review updateReview, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.put,
        sendToken: true,
        '/review/${updateReview.id}',
        body: updateReview.toJson(),
        files: updateReview.picture?.file != null ? [updateReview.picture?.file] : [],
      );
      if (withBack) Helper.goBack();
      final review = Review.fromJson(result['review']);
      Helper.snackBar(message: 'review_updated_successfully'.tr);
      return review;
    } catch (e) {
      Helper.snackBar(message: 'review_update_failed'.tr);
      LoggerService.logger?.e('Error occured in updateReview:\n$e');
    }
    return null;
  }

  Future<bool> deleteReview(Review review, {bool withBack = false}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.delete, sendToken: true, '/review/${review.id}');
      final status = result?['done'] ?? false;
      if (withBack) Helper.goBack();
      if (status) Helper.snackBar(message: 'review_deleted_successfully'.tr);
      return status;
    } catch (e) {
      LoggerService.logger?.e('Error occured in deleteUser:\n$e');
    }
    return false;
  }
}
