import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../networking/api_base_helper.dart';
import 'admin_dashboard_screen.dart';
import 'components/stats_screen/balance_stats/balance_stats_screen.dart';
import 'components/stats_screen/category_stats/category_stats_screen.dart';
import 'components/stats_screen/chat_stats/chat_stats_screen.dart';
import 'components/stats_screen/coins_stats/coins_stats_screen.dart';
import 'components/stats_screen/components/animated_vertical_text_switcher.dart';
import 'components/stats_screen/contract_stats/contract_stats_screen.dart';
import 'components/stats_screen/favorite_stats/favorite_stats_screen.dart';
import 'components/stats_screen/feedbacks_stats/feedbacks_stats_screen.dart';
import 'components/stats_screen/governorate_stats/governorate_stats_screen.dart';
import 'components/stats_screen/referrals_stats/referrals_stats_screen.dart';
import 'components/stats_screen/report_stats/report_stats_screen.dart';
import 'components/stats_screen/review_stats/review_stats_screen.dart';
import 'components/stats_screen/store_stats/store_stats_screen.dart';
import 'components/stats_screen/task_stats/task_stats_screen.dart';
import 'components/stats_screen/user_stats/user_stats_screen.dart';

class AdminDashboardController extends GetxController {
  
  /// not permanent use with caution
  static AdminDashboardController get find => Get.find<AdminDashboardController>();
  RxBool isLoading = true.obs;
  RxInt approveUsersActionRequired = 0.obs;
  RxInt manageBalanceActionRequired = 0.obs;
  RxInt reportsActionRequired = 0.obs;
  RxInt feedbacksActionRequired = 0.obs;
  static RxInt totalUsers = 0.obs;
  static RxInt activeUsers = 0.obs;
  static RxInt verifiedUsers = 0.obs;
  static RxInt totalDeposits = 0.obs;
  static RxInt totalWithdrawals = 0.obs;
  static RxInt maxUserBalance = 0.obs;
  static RxInt userHasBalance = 0.obs;
  static RxInt totalContract = 0.obs;
  static RxInt totalPayedContract = 0.obs;
  static RxInt activeContract = 0.obs;
  static RxInt totalTasks = 0.obs;
  static RxInt activeTasks = 0.obs;
  static RxInt expiredTasks = 0.obs;
  static RxInt totalStores = 0.obs;
  static RxInt totalServices = 0.obs;
  static RxInt totalFeedbacks = 0.obs;
  static RxInt totalReports = 0.obs;
  static RxInt totalSubscription = 0.obs;
  static RxInt totalCategories = 0.obs;
  static RxInt totalSubCategories = 0.obs;
  static RxInt totalDiscussions = 0.obs;
  static RxInt activeDiscussions = 0.obs;
  static RxInt totalCoinPacksSold = 0.obs;
  static RxInt totalActiveCoinPacks = 0.obs;
  static RxInt totalStoresFavorite = 0.obs;
  static RxInt totalTasksFavorite = 0.obs;
  static RxInt totalReferrals = 0.obs;
  static RxInt totalSuccessReferrals = 0.obs;
  static RxInt totalReviews = 0.obs;

  List<StatsMenuButton> statsMenuButtons = [
    StatsMenuButton(
      label: 'user',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + UserStatsScreen.routeName),
      icon: Icons.person_2_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_users'.tr}: ${_getValue(title)['totalUsers']}',
          '${'active_users'.tr}: ${_getValue(title)['activeUsers']}',
          '${'verified_users'.tr}: ${_getValue(title)['verifiedUsers']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'balance',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + BalanceStatsScreen.routeName),
      icon: Icons.attach_money_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_deposits'.tr}: ${_getValue(title)['totalDeposits']}',
          '${'total_withdrawals'.tr}: ${_getValue(title)['totalWithdrawals']}',
          '${'max_user_balance'.tr}: ${_getValue(title)['maxUserBalance']}',
          '${'users_has_balance'.tr}: ${_getValue(title)['userHasBalance']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'contract',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + ContractStatsScreen.routeName),
      icon: Icons.article_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_contract'.tr}: ${_getValue(title)['totalContract']}',
          '${'payed_contract'.tr}: ${_getValue(title)['totalPayedContract']}',
          '${'active_contract'.tr}: ${_getValue(title)['activeContract']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'task',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + TaskStatsScreen.routeName),
      icon: Icons.task_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_tasks'.tr}: ${_getValue(title)['totalTasks']}',
          '${'active_tasks'.tr}: ${_getValue(title)['activeTasks']}',
          '${'expired_tasks'.tr}: ${_getValue(title)['expiredTasks']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'store',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + StoreStatsScreen.routeName),
      icon: Icons.store_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_stores'.tr}: ${_getValue(title)['totalStores']}',
          '${'total_services'.tr}: ${_getValue(title)['totalServices']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'feedbacks',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + FeedbacksStatsScreen.routeName),
      icon: Icons.feedback_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_feedback'.tr}: ${_getValue(title)['totalFeedbacks']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'report',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + ReportStatsScreen.routeName),
      icon: Icons.report_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_report'.tr}: ${_getValue(title)['totalReports']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'category',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + CategoryStatsScreen.routeName),
      icon: Icons.category_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_subscription'.tr}: ${_getValue(title)['totalSubscription']}',
          '${'total_categories'.tr}: ${_getValue(title)['totalCategories']}',
          '${'total_sub_categories'.tr}: ${_getValue(title)['totalSubCategories']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'chat',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + ChatStatsScreen.routeName),
      icon: Icons.question_answer_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_discussion'.tr}: ${_getValue(title)['totalDiscussions']}',
          '${'active_discussion'.tr}: ${_getValue(title)['activeDiscussions']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'coins',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + CoinsStatsScreen.routeName),
      icon: Icons.paid_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_coin_packs_sold'.tr}: ${_getValue(title)['totalCoinPacksSold']}',
          '${'total_active_coin_packs'.tr}: ${_getValue(title)['totalActiveCoinPacks']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'favorite',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + FavoriteStatsScreen.routeName),
      icon: Icons.bookmark_border_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_favorite'.tr}: ${_getValue(title)['totalFavorite']}',
          '${'total_stores_favorite'.tr}: ${_getValue(title)['totalStoresFavorite']}',
          '${'total_tasks_favorite'.tr}: ${_getValue(title)['totalTasksFavorite']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'governorate',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + GovernorateStatsScreen.routeName),
      icon: Icons.location_city_outlined,
    ),
    StatsMenuButton(
      label: 'referrals',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + ReferralsStatsScreen.routeName),
      icon: Icons.group_add_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_referral'.tr}: ${_getValue(title)['totalReferrals']}',
          '${'total_successful_referral'.tr}: ${_getValue(title)['totalSuccessReferrals']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
    StatsMenuButton(
      label: 'review',
      onTap: () => Get.toNamed(AdminDashboardScreen.routeName + ReviewStatsScreen.routeName),
      icon: Icons.rate_review_outlined,
      carousel: (title) => AnimatedVerticalTextSwitcher(
        texts: [
          '${'total_review'.tr}: ${_getValue(title)['totalReviews']}',
        ],
        duration: const Duration(seconds: 4),
      ),
    ),
  ];

  static final AdminDashboardController _singleton = AdminDashboardController._internal();

  factory AdminDashboardController() => _singleton;

  AdminDashboardController._internal() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getDashboardData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('updateAdminDashboard');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('updateAdminDashboard', (data) {
        approveUsersActionRequired.value = data?['adminDashboard']?['approveCount'] as int? ?? 0;
        manageBalanceActionRequired.value = data?['adminDashboard']?['balanceCount'] as int? ?? 0;
        reportsActionRequired.value = data?['adminDashboard']?['reportsCount'] as int? ?? 0;
        feedbacksActionRequired.value = data?['adminDashboard']?['feedbackCount'] as int? ?? 0;
        totalUsers.value = data?['adminDashboard']?['totalUsers'] as int? ?? 0;
        activeUsers.value = data?['adminDashboard']?['activeUsers'] as int? ?? 0;
        verifiedUsers.value = data?['adminDashboard']?['verifiedUsers'] as int? ?? 0;
        totalDeposits.value = data?['adminDashboard']?['totalDeposits'] as int? ?? 0;
        totalWithdrawals.value = data?['adminDashboard']?['totalWithdrawals'] as int? ?? 0;
        maxUserBalance.value = data?['adminDashboard']?['maxUserBalance'] as int? ?? 0;
        userHasBalance.value = data?['adminDashboard']?['userHasBalance'] as int? ?? 0;
        totalContract.value = data?['adminDashboard']?['totalContract'] as int? ?? 0;
        totalPayedContract.value = data?['adminDashboard']?['totalPayedContract'] as int? ?? 0;
        activeContract.value = data?['adminDashboard']?['activeContract'] as int? ?? 0;
        activeTasks.value = data?['adminDashboard']?['activeTasks'] as int? ?? 0;
        expiredTasks.value = data?['adminDashboard']?['expiredTasks'] as int? ?? 0;
        totalStores.value = data?['adminDashboard']?['totalStores'] as int? ?? 0;
        totalServices.value = data?['adminDashboard']?['totalServices'] as int? ?? 0;
        totalFeedbacks.value = data?['adminDashboard']?['totalFeedbacks'] as int? ?? 0;
        totalReports.value = data?['adminDashboard']?['totalReports'] as int? ?? 0;
        totalSubscription.value = data?['adminDashboard']?['totalSubscription'] as int? ?? 0;
        totalCategories.value = data?['adminDashboard']?['totalCategories'] as int? ?? 0;
        totalSubCategories.value = data?['adminDashboard']?['totalSubCategories'] as int? ?? 0;
        totalDiscussions.value = data?['adminDashboard']?['totalDiscussions'] as int? ?? 0;
        activeDiscussions.value = data?['adminDashboard']?['activeDiscussions'] as int? ?? 0;
        totalCoinPacksSold.value = data?['adminDashboard']?['totalCoinPacksSold'] as int? ?? 0;
        totalActiveCoinPacks.value = data?['adminDashboard']?['totalActiveCoinPacks'] as int? ?? 0;
        totalStoresFavorite.value = data?['adminDashboard']?['totalStoresFavorite'] as int? ?? 0;
        totalTasksFavorite.value = data?['adminDashboard']?['totalTasksFavorite'] as int? ?? 0;
        totalTasks.value = data?['adminDashboard']?['totalTasks'] as int? ?? 0;
        totalReferrals.value = data?['adminDashboard']?['totalReferrals'] as int? ?? 0;
        totalSuccessReferrals.value = data?['adminDashboard']?['totalSuccessReferrals'] as int? ?? 0;
        totalReviews.value = data?['adminDashboard']?['totalReviews'] as int? ?? 0;
        isLoading.value = false;
        update();
      });
    });
  }

  static Map<String, int?> _getValue(String s) {
    switch (s) {
      case 'user':
        return {
          'totalUsers': totalUsers.value,
          'activeUsers': activeUsers.value,
          'verifiedUsers': verifiedUsers.value,
        };
      case 'balance':
        return {
          'totalDeposits': totalDeposits.value,
          'totalWithdrawals': totalWithdrawals.value,
          'maxUserBalance': maxUserBalance.value,
          'userHasBalance': userHasBalance.value,
        };
      case 'contract':
        return {
          'totalContract': totalContract.value,
          'totalPayedContract': totalPayedContract.value,
          'activeContract': activeContract.value,
        };
      case 'task':
        return {
          'totalTasks': totalTasks.value,
          'activeTasks': activeTasks.value,
          'expiredTasks': expiredTasks.value,
        };
      case 'store':
        return {
          'totalStores': totalStores.value,
          'totalServices': totalServices.value,
        };
      case 'feedbacks':
        return {
          'totalFeedbacks': totalFeedbacks.value,
        };
      case 'report':
        return {
          'totalReports': totalReports.value,
        };
      case 'category':
        return {
          'totalSubscription': totalSubscription.value,
          'totalCategories': totalCategories.value,
          'totalSubCategories': totalSubCategories.value,
        };
      case 'chat':
        return {
          'totalDiscussions': totalDiscussions.value,
          'activeDiscussions': activeDiscussions.value,
        };
      case 'coins':
        return {
          'totalCoinPacksSold': totalCoinPacksSold.value,
          'totalActiveCoinPacks': totalActiveCoinPacks.value,
        };
      case 'favorite':
        return {
          'totalFavorite': totalStoresFavorite.value + totalTasksFavorite.value,
          'totalStoresFavorite': totalStoresFavorite.value,
          'totalTasksFavorite': totalTasksFavorite.value,
        };
      case 'referrals':
        return {
          'totalReferrals': totalReferrals.value,
          'totalSuccessReferrals': totalSuccessReferrals.value,
        };
      case 'review':
        return {
          'totalReviews': totalReviews.value,
        };
      default:
        return {s: 0};
    }
  }
}

class StatsMenuButton {
  final String label;
  final void Function() onTap;
  final IconData? icon;
  final Widget Function(String)? carousel;

  StatsMenuButton({required this.label, required this.onTap, required this.icon, this.carousel});
}
