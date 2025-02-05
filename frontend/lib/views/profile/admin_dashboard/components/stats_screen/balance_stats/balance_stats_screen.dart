import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'balance_stats_controller.dart';

class BalanceStatsScreen extends StatelessWidget {
  static const String routeName = '/balance-stats';
  const BalanceStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BalanceStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'balance'.tr,
        body: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: LoadingRequest(
            isLoading: controller.isLoading,
            child: Column(
              children: [
                // Balance: max user balance, users has balance > 0, Deposit per day, Withdrawals per day, Total deposit, Total withdrawals
                ThreeStatsOverview(
                  leftNumber: AdminDashboardController.totalDeposits.value,
                  leftLabel: 'total_deposits'.tr,
                  rightNumber: AdminDashboardController.totalWithdrawals.value,
                  rightLabel: 'total_withdrawals'.tr,
                ),
                const SizedBox(height: Paddings.large),
                ThreeStatsOverview(
                  leftNumber: AdminDashboardController.maxUserBalance.value,
                  leftLabel: 'max_user_balance'.tr,
                  rightNumber: controller.totalUsersHasBalance,
                  rightLabel: 'users_has_balance'.tr,
                ),
                const SizedBox(height: Paddings.large),
                BarChartWidget(
                  title: 'deposit_vs_withdrawal_per_day'.tr,
                  dataPerDay: controller.depositsPerDayData,
                  dataPerDaySecond: controller.withdrawalsPerDayData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
