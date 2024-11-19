import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'chat_stats_controller.dart';

class ChatStatsScreen extends StatelessWidget {
  static const String routeName = '/chat-stats';
  const ChatStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Chat: Total discussions, Active discussions per day
    return GetBuilder<ChatStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'chat'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Chat: Total discussions, Active discussions per day
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalDiscussions.value,
                    leftLabel: 'total_discussion'.tr,
                    rightNumber: AdminDashboardController.activeDiscussions.value,
                    rightLabel: 'active_discussion'.tr,
                  ),                  const SizedBox(height: Paddings.large),
                  BarChartWidget(
                    title: 'discussions_per_day'.tr,
                    dataPerDay: controller.discussionsPerDayData,
                  ),
                  const SizedBox(height: Paddings.large),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
