import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../components/pie_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'feedbacks_stats_controller.dart';

class FeedbacksStatsScreen extends StatelessWidget {
  static const String routeName = '/feedbacks-stats';
  const FeedbacksStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbacksStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'feedbacks'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Feedback: Total feedbacks, Feedbacks per feedbackEnum, Feedback's messages
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalFeedbacks.value,
                    leftLabel: 'total_feedback'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'feedbacks_per_type'.tr,
                    pieChartData: controller.feedbacksPerCategoryData,
                  ),
                  const SizedBox(height: Paddings.large),
                  BarChartWidget(
                    title: 'feedbacks_per_day'.tr,
                    dataPerDay: controller.feedbacksPerDayData,
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
