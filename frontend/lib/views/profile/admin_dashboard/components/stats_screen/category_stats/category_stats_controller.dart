import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/category.dart';
import '../../../../../../repositories/admin_repository.dart';
import '../components/pie_chart.dart';

class CategoryStatsController extends GetxController {
  bool isLoading = true;
  int totalCategories = 0;
  int totalSubCategories = 0;
  List<PieChartModel> subscriptionsPerCategoryData = [];
  List<PieChartModel> categoriesPerUsageData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  CategoryStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (subscriptionList, usageList) = await AdminRepository.find.getCategoriesStatsData();
    if (subscriptionList != null) _initPieChartSubscriptiobData(subscriptionList);
    if (usageList != null) _initPieChartPerUsageData(usageList);
    totalCategories = MainAppController.find.categories.where((element) => element.parentId == -1).length;
    totalSubCategories = MainAppController.find.categories.where((element) => element.parentId != -1).length;
    isLoading = false;
    update();
  }

  void _initPieChartSubscriptiobData(List<Category> categoryList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType(categoryList);
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      subscriptionsPerCategoryData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      subscriptionsPerCategoryData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(baseColor: kPrimaryColor), value: value, amount: value));
    });

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
      categoriesPerUsageData.add(PieChartModel(name: element['category.name'], color: Helper.getRandomColor(baseColor: kPrimaryColor), value: used, amount: used));
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
