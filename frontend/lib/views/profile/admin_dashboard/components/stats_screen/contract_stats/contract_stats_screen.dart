import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../components/bar_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'contract_stats_controller.dart';

class ContractStatsScreen extends StatelessWidget {
  static const String routeName = '/contract-stats';
  const ContractStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContractStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'contract'.tr,
        body: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: LoadingRequest(
            isLoading: controller.isLoading,
            child: Column(
              children: [
                // Contract: Contracts per day, Total contracts, Total payed contracts, Total active now
                ThreeStatsOverview(
                  leftNumber: controller.totalContracts,
                  leftLabel: 'total_contract'.tr,
                  middleNumber: controller.payedContracts,
                  middleLabel: 'payed_contract'.tr,
                  rightNumber: controller.activeContracts,
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
