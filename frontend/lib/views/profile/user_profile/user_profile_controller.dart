import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/helper.dart';
import '../../../models/review.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';

class UserProfileController extends GetxController {
  final User? providedUser;
  User? user;
  bool _isLoading = true;
  XFile? profilePicture;
  bool _initialized = false;
  bool _showAllReviews = false;
  int userReviewers = 0;
  List<Review> userReviews = [];

  bool get showAllReviews => _showAllReviews;

  set showAllReviews(bool value) {
    _showAllReviews = value;
    update();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
  }

  UserProfileController(this.providedUser) {
    _init();
  }

  Future<void> _init() async {
    if (providedUser?.id != null && !_initialized) {
      _initialized = true;
      final result = await UserRepository.find.getUserById(providedUser!.id!);
      user = result?.user;
      userReviews = result?.reviews ?? [];
      userReviewers = userReviews.length;
      user?.rating = Helper.calculateRating(userReviews);
      isLoading = false;
      update();
    }
  }
}
