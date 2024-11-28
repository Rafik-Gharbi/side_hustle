import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/category.dart';
import '../../../../../../models/task.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class TaskStatsController extends GetxController {
  RxBool isLoading = true.obs;
  Map<DateTime, double> tasksPerDayData = {};
  List<PieChartModel> taskPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  TaskStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminTaskStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminTaskStatsData');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminTaskStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminTaskStatsData', (data) async {
        final taskList = (data?['taskStats']?['tasks'] as List?)?.map((e) => Task.fromJson(e)).toList() ?? [];
        if (taskList.isNotEmpty) {
          _initChartPerDayData(taskList);
          _initPieChartData(taskList);
        }
        AdminDashboardController.totalTasks.value = taskList.length;
        AdminDashboardController.activeTasks.value = data?['taskStats']?['activeCount'] ?? 0;
        AdminDashboardController.expiredTasks.value = data?['taskStats']?['expiredCount'] ?? 0;
        isLoading.value = false;
        update();
      });
    });
  }

  void _initChartPerDayData(List<Task> depositList) {
    tasksPerDayData.clear();
    for (final transaction in depositList) {
      DateTime date = transaction.createdAt!.normalize();
      if (tasksPerDayData.containsKey(date)) {
        tasksPerDayData[date] = tasksPerDayData[date]! + 1;
      } else {
        tasksPerDayData.putIfAbsent(date, () => 1);
      }
    }
    tasksPerDayData = Helper.sortByDateDesc(tasksPerDayData);
  }

  void _initPieChartData(List<Task> taskList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByCategory(taskList);
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      taskPerCategoryData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      taskPerCategoryData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < taskPerCategoryData.length; i++) {
      taskPerCategoryData[i].value = double.parse((taskPerCategoryData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(taskPerCategoryData);
  }

  Map<Category, double> getTotalByCategory(List<Task> taskList) {
    Map<Category, double> result = {};
    for (final element in taskList) {
      final categoryItem = element.category!;
      if (result.containsKey(categoryItem)) {
        result[categoryItem] = result[categoryItem]! + 1;
      } else {
        result.putIfAbsent(categoryItem, () => 1);
      }
    }
    return Helper.sortByValueDesc<Category>(result);
  }
}
