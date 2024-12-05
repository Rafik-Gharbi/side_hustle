import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'category_stats_controller.dart';

class CategoryStatsScreen extends StatelessWidget {
  static const String routeName = '/category-stats';
  const CategoryStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'category'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Category: Subscription per category, Most useful categories
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalCategories.value,
                    leftLabel: 'total_categories'.tr,
                    middleNumber: AdminDashboardController.totalSubCategories.value,
                    middleLabel: 'total_sub_categories'.tr,
                    rightNumber: AdminDashboardController.totalSubscription.value,
                    rightLabel: 'total_subscription'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'subscription_per_category'.tr,
                    pieChartData: controller.subscriptionsPerCategoryData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'most_used_categories'.tr,
                    pieChartData: controller.categoriesPerUsageData,
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
