import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/dto/favorite_dto.dart';
import '../../../../../../models/store.dart';
import '../../../../../../models/task.dart';
import '../../../../../../repositories/admin_repository.dart';
import '../components/pie_chart.dart';

class FavoriteStatsController extends GetxController {
  bool isLoading = true;
  int totalFavorites = 0;
  List<PieChartModel> favoritesPerStoreData = [];
  List<PieChartModel> favoritesPerTaskData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  FavoriteStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (favoriteStoresList, favoriteTasksList) = await AdminRepository.find.getFavoriteStatsData();
    if (favoriteStoresList != null) _initPieChartData(favoriteStoresList);
    if (favoriteTasksList != null) _initPieChartTasksData(favoriteTasksList);
    totalFavorites = (favoriteStoresList?.length ?? 0) + (favoriteTasksList?.length ?? 0);
    isLoading = false;
    update();
  }

  void _initPieChartData(List<FavoriteDTO> favoriteList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap =
        favoriteList.map((e) => e.savedStores).isEmpty ? {} : getTotalByType<Store>(favoriteList.map((e) => e.savedStores).reduce((value, element) => value + element).toList());
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      favoritesPerStoreData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      favoritesPerStoreData.add(PieChartModel(name: key.name ?? 'NA', color: Helper.getRandomColor(baseColor: kPrimaryColor), value: value, amount: value));
    });

    for (int i = 0; i < favoritesPerStoreData.length; i++) {
      favoritesPerStoreData[i].value = double.parse((favoritesPerStoreData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(favoritesPerStoreData);
  }

  void _initPieChartTasksData(List<FavoriteDTO> favoriteList) {
    // convert total expenses in result map value to percentage
    final totalTasksUseMap =
        favoriteList.map((e) => e.savedTasks).isEmpty ? {} : getTotalByType<Task>(favoriteList.map((e) => e.savedTasks).reduce((value, element) => value + element).toList());
    double totalExpanses = 0;
    totalTasksUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalTasksUseMap.isNotEmpty) {
      favoritesPerTaskData.clear();
    }
    totalTasksUseMap.forEach((key, value) {
      favoritesPerTaskData.add(PieChartModel(name: key.title, color: Helper.getRandomColor(baseColor: kPrimaryColor), value: value, amount: value));
    });

    for (int i = 0; i < favoritesPerTaskData.length; i++) {
      favoritesPerTaskData[i].value = double.parse((favoritesPerTaskData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(favoritesPerTaskData);
  }

  Map<T, double> getTotalByType<T>(List<T> favoriteList) {
    Map<T, double> result = {};
    for (final favoriteDto in favoriteList) {
      if (result.containsKey(favoriteDto)) {
        result[favoriteDto] = result[favoriteDto]! + 1;
      } else {
        result.putIfAbsent(favoriteDto, () => 1);
      }
    }
    return Helper.sortByValueDesc<T>(result);
  }
}
