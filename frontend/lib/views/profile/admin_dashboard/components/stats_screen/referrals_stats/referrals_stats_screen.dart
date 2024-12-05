import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'referrals_stats_controller.dart';

class ReferralsStatsScreen extends StatelessWidget {
  static const String routeName = '/referrals-stats';
  const ReferralsStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Referral: Total referrals, Referrals per status, Total successful referrals
    return GetBuilder<ReferralsStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'referrals'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Referral: Total referrals, Referrals per status, Total successful referrals
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalReferrals.value,
                    leftLabel: 'total_referral'.tr,
                    rightNumber: AdminDashboardController.totalSuccessReferrals.value,
                    rightLabel: 'total_successful_referral'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'referrals_per_status'.tr,
                    pieChartData: controller.referralsPerStatusData,
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
