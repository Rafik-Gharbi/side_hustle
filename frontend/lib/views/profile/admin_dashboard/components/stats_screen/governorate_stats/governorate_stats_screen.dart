import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../components/pie_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import 'governorate_stats_controller.dart';

class GovernorateStatsScreen extends StatelessWidget {
  static const String routeName = '/governorate-stats';
  const GovernorateStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GovernorateStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'governorate'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Governorate: Stores per city, Users per city, Tasks per city, Contracts per city
                  PieChartWidget(
                    title: 'stores_per_governorate'.tr,
                    pieChartData: controller.storesPerGovernorateData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'users_per_governorate'.tr,
                    pieChartData: controller.usersPerGovernorateData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'tasks_per_governorate'.tr,
                    pieChartData: controller.tasksPerGovernorateData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'contracts_per_governorate'.tr,
                    pieChartData: controller.contractsPerGovernorateData,
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
