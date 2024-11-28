import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/dto/favorite_dto.dart';
import '../../../../../../models/store.dart';
import '../../../../../../models/task.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class FavoriteStatsController extends GetxController {
  RxBool isLoading = true.obs;
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
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminFavoriteStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminFavoriteStatsData');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminFavoriteStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminFavoriteStatsData', (data) async {
        final favoriteStoresList = (data?['favoriteStats']?['stores'] as List?)?.map((e) => FavoriteDTO.fromJson(e)).toList() ?? [];
        final favoriteTasksList = (data?['favoriteStats']?['tasks'] as List?)?.map((e) => FavoriteDTO.fromJson(e)).toList() ?? [];
        if (favoriteStoresList.isNotEmpty) _initPieChartData(favoriteStoresList);
        if (favoriteTasksList.isNotEmpty) _initPieChartTasksData(favoriteTasksList);
        totalFavorites = (favoriteStoresList.length) + (favoriteTasksList.length);
        AdminDashboardController.totalStoresFavorite.value = favoriteStoresList.length;
        AdminDashboardController.totalTasksFavorite.value = favoriteTasksList.length;
        isLoading.value = false;
        update();
      });
    });
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
      favoritesPerStoreData.add(PieChartModel(name: key.name ?? 'NA', color: Helper.getRandomColor(), value: value, amount: value));
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
      favoritesPerTaskData.add(PieChartModel(name: key.title, color: Helper.getRandomColor(), value: value, amount: value));
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
