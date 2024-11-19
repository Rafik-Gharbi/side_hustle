import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../components/three_stats_overview.dart';
import '../components/stats_scaffold.dart';
import 'user_stats_controller.dart';

class UserStatsScreen extends StatelessWidget {
  static const String routeName = '/user-stats';
  const UserStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'user'.tr,
        body: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: LoadingRequest(
            isLoading: controller.isLoading,
            child: Column(
              children: [
                // User: total, active, signup per day, verified, users per profile completion
                ThreeStatsOverview(
                  leftNumber: AdminDashboardController.totalUsers.value,
                  leftLabel: 'total_users'.tr,
                  rightNumber: AdminDashboardController.activeUsers.value,
                  rightLabel: 'active_users'.tr,
                  middleNumber: AdminDashboardController.verifiedUsers.value,
                  middleLabel: 'verified_users'.tr,
                ),
                const SizedBox(height: Paddings.large),
                BarChartWidget(title: 'users_per_day'.tr, dataPerDay: controller.usersPerDayData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
