import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/admin_repository.dart';

class AdminDashboardController extends GetxController {
  /// not permanent use with caution
  static AdminDashboardController get find => Get.find<AdminDashboardController>();
  bool _isLoading = true;
  int approveUsersActionRequired = 0;
  int manageBalanceActionRequired = 0;
  int reportsActionRequired = 0;
  int feedbacksActionRequired = 0;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
  }

  AdminDashboardController() {
    init();
  }

  Future<void> init() async {
    final (approveCount, balanceCount, reportsCount, feedbackCount) = await AdminRepository.find.fetchAdminData();
    approveUsersActionRequired = approveCount ?? 0;
    manageBalanceActionRequired = balanceCount ?? 0;
    reportsActionRequired = reportsCount ?? 0;
    feedbacksActionRequired = feedbackCount ?? 0;
    MainAppController.find.resolveProfileActionRequired();
    if (!MainAppController.find.isBackReachable.value) ApiBaseHelper.find.isLoading = false;
    isLoading = false;
  }
}
