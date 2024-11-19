import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'review_stats_controller.dart';

class ReviewStatsScreen extends StatelessWidget {
  static const String routeName = '/review-stats';
  const ReviewStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Review: Total reviews, Reviews per review (with details if available), Review's messages
    return GetBuilder<ReviewStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'review'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Review: Total reviews, Reviews per review (with details if available), Review's messages
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalReviews.value,
                    leftLabel: 'total_review'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'reviews_per_rating'.tr,
                    pieChartData: controller.reviewsPerRatingData,
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
