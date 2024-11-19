import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/bar_chart.dart';
import '../components/pie_chart.dart';
import '../components/stats_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'task_stats_controller.dart';

class TaskStatsScreen extends StatelessWidget {
  static const String routeName = '/task-stats';
  const TaskStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskStatsController>(
      builder: (controller) => StatsScaffold(
        title: 'task'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Task: Tasks per day, Total active tasks, Total expired tasks (useful to list tasks), Tasks per category
                  ThreeStatsOverview(
                    leftNumber: AdminDashboardController.totalTasks.value,
                    leftLabel: 'total_tasks'.tr,
                    middleNumber: AdminDashboardController.activeTasks.value,
                    middleLabel: 'active_tasks'.tr,
                    rightNumber: AdminDashboardController.expiredTasks.value,
                    rightLabel: 'expired_tasks'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  BarChartWidget(
                    title: 'tasks_per_day'.tr,
                    dataPerDay: controller.tasksPerDayData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'tasks_per_category'.tr,
                    pieChartData: controller.taskPerCategoryData,
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
