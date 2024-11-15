import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../components/bar_chart.dart';
import '../components/pie_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'coins_stats_controller.dart';

class CoinsStatsScreen extends StatelessWidget {
  static const String routeName = '/coins-stats';
  const CoinsStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Coins: Coin packs selling per day, Active coin packs, Coin packs sold per pack
    return GetBuilder<CoinsStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'coins'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Coins: Total sold coins, Coin packs selling per day, Active coin packs, Coin packs sold per pack
                  ThreeStatsOverview(
                    leftNumber: controller.totalCoinPacksSold,
                    leftLabel: 'total_coin_packs_sold'.tr,
                    rightNumber: controller.totalActiveCoinPacks,
                    rightLabel: 'total_active_coin_packs'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'coin_packs_per_pack'.tr,
                    pieChartData: controller.coinPacksPerCategoryData,
                  ),
                  const SizedBox(height: Paddings.large),
                  BarChartWidget(
                    title: 'coin_packs_sold_per_day'.tr,
                    dataPerDay: controller.coinPacksPerDayData,
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
