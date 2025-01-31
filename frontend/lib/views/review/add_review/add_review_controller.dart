import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/helper.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/review.dart';
import '../../../models/user.dart';
import '../../../repositories/review_repository.dart';
import '../../../services/logger_service.dart';

class AddReviewController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  User user;
  Review? review;
  RxDouble rating = 3.0.obs;
  RxDouble quality = 0.0.obs;
  RxDouble fees = 0.0.obs;
  RxDouble punctuality = 0.0.obs;
  RxDouble politeness = 0.0.obs;
  RxBool isDetailedReviewing = false.obs;
  RxBool isLoading = false.obs;
  XFile? picture;

  AddReviewController({required this.user, this.review}) {
    if (review != null) _loadReviewFields();
  }

  Future<void> upsertReview() async {
    isLoading.value = true;
    final upsertedReview = Review(
      id: review?.id,
      message: messageController.text,
      rating: rating.value,
      quality: quality.value == 0 ? null : quality.value,
      fees: fees.value == 0 ? null : fees.value,
      punctuality: punctuality.value == 0 ? null : punctuality.value,
      politeness: politeness.value == 0 ? null : politeness.value,
      picture: picture != null ? ImageDTO(file: picture!, type: ImageType.image) : null,
      user: user,
    );
    if (review == null) {
      await ReviewRepository.find.addReview(upsertedReview, withBack: true);
    } else {
      await ReviewRepository.find.updateReview(upsertedReview, withBack: true);
    }
    isLoading.value = false;
    clearFormFields();
  }

  void clearFormFields() {
    messageController.clear();
    rating.value = 3;
    quality.value = 0;
    fees.value = 0;
    punctuality.value = 0;
    politeness.value = 0;
    isDetailedReviewing.value = false;
  }

  void _loadReviewFields() {
    messageController.text = review!.message ?? '';
    rating.value = review!.rating;
    quality.value = review!.quality ?? 0;
    fees.value = review!.fees ?? 0;
    punctuality.value = review!.punctuality ?? 0;
    politeness.value = review!.politeness ?? 0;
    update();
  }

  void detailedRating() => isDetailedReviewing.value = true;

  Future<void> uploadReviewPicture() async {
    try {
      XFile? image = await Helper.pickImage();
      if (image != null) {
        picture = image;
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadReviewPicture:\n$e');
    }
  }
}
