import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/category.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class CategoryStatsController extends GetxController {
  bool isLoading = true;
  // int totalCategories = 0;
  // int totalSubCategories = 0;
  List<PieChartModel> subscriptionsPerCategoryData = [];
  List<PieChartModel> categoriesPerUsageData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  CategoryStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminCategoryStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminCategoryStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminCategoryStatsData', (data) async {
        final subscriptionList = data?['categoryStats']?['subscription'] as List?;
        final usageList = data?['categoryStats']?['usage'] as List?;
        final categories = (data?['categoryStats']?['categories'] as List?)?.map((e) => Category.fromJson(e)).toList() ?? [];
        if (subscriptionList != null) _initPieChartSubscriptiobData(subscriptionList);
        if (usageList != null) _initPieChartPerUsageData(usageList);
        AdminDashboardController.totalCategories.value = categories.where((element) => element.parentId == -1).length;
        AdminDashboardController.totalSubCategories.value = categories.where((element) => element.parentId != -1).length;
        AdminDashboardController.totalSubscription.value = subscriptionList?.length ?? 0;
        isLoading = false;
        update();
      });
    });
  }

  void _initPieChartSubscriptiobData(List<dynamic> categoryList) {
    // convert total expenses in result map value to percentage
    double totalExpanses = 0;
    for (var element in categoryList) {
      final used = Helper.resolveDouble(element['total_use']);
      totalExpanses += used;
      subscriptionsPerCategoryData.add(PieChartModel(name: element['category.name'], color: Helper.getRandomColor(), value: used, amount: used));
    }

    for (int i = 0; i < subscriptionsPerCategoryData.length; i++) {
      subscriptionsPerCategoryData[i].value = double.parse((subscriptionsPerCategoryData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(subscriptionsPerCategoryData);
  }

  void _initPieChartPerUsageData(List<dynamic> usageList) {
    // convert total expenses in result map value to percentage
    double totalExpanses = 0;
    for (var element in usageList) {
      final used = Helper.resolveDouble(element['total_tasks']);
      totalExpanses += used;
      categoriesPerUsageData.add(PieChartModel(name: element['category.name'], color: Helper.getRandomColor(), value: used, amount: used));
    }

    for (int i = 0; i < categoriesPerUsageData.length; i++) {
      categoriesPerUsageData[i].value = double.parse((categoriesPerUsageData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(categoriesPerUsageData);
  }

  Map<Category, double> getTotalByType(List<Category> categoryList) {
    Map<Category, double> result = {};
    for (final category in categoryList) {
      final categoryItem = category;
      if (result.containsKey(categoryItem)) {
        result[categoryItem] = result[categoryItem]! + 1;
      } else {
        result.putIfAbsent(categoryItem, () => 1);
      }
    }
    return Helper.sortByValueDesc<Category>(result);
  }
}
