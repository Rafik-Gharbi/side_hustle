import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'contract_stats_controller.dart';

class ContractStatsScreen extends StatelessWidget {
  static const String routeName = '/contract-stats';
  const ContractStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContractStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'contract'.tr,
        body: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: LoadingRequest(
            isLoading: controller.isLoading,
            child: Column(
              children: [
                // Contract: Contracts per day, Total contracts, Total payed contracts, Total active now
                ThreeStatsOverview(
                  leftNumber: AdminDashboardController.totalContract.value,
                  leftLabel: 'total_contract'.tr,
                  middleNumber: AdminDashboardController.totalPayedContract.value,
                  middleLabel: 'payed_contract'.tr,
                  rightNumber: AdminDashboardController.activeContract.value,
                  rightLabel: 'active_contract'.tr,
                ),
                const SizedBox(height: Paddings.large),
                BarChartWidget(title: 'contracts_per_day'.tr, dataPerDay: controller.contractsPerDayData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
