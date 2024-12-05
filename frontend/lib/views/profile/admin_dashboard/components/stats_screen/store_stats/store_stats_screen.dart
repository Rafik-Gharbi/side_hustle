import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../components/pie_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'store_stats_controller.dart';

class StoreStatsScreen extends StatelessWidget {
  static const String routeName = '/store-stats';
  const StoreStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'store'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Store: Service consumption per day, Total stores/serices, Service per category, Stores per completion
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalStores.value,
                    leftLabel: 'total_stores'.tr,
                    rightNumber: AdminDashboardController.totalServices.value,
                    rightLabel: 'total_services'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  BarChartWidget(
                    title: 'services_per_day'.tr,
                    dataPerDay: controller.servicesPerDayData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'services_per_category'.tr,
                    pieChartData: controller.servicesPerCategoryData,
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
