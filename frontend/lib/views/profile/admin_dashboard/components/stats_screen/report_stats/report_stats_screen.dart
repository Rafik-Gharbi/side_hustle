import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'report_stats_controller.dart';

class ReportStatsScreen extends StatelessWidget {
  static const String routeName = '/report-stats';
  const ReportStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'report'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Report: Total reports, Reports per type
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalReports.value,
                    leftLabel: 'total_report'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'reports_per_type'.tr,
                    pieChartData: controller.reportsPerCategoryData,
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
