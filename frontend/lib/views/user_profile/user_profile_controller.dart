import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';
import '../../repositories/user_repository.dart';

class UserProfileController extends GetxController {
  final User? providedUser;
  User? user;
  bool _isLoading = true;
  XFile? profilePicture;
  bool _initialized = false;

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
      user = await UserRepository.find.getUserById(providedUser!.id!);
      isLoading = false;
      update();
    }
  }
}
