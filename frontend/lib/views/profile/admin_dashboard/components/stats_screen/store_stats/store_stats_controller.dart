import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/category.dart';
import '../../../../../../models/reservation.dart';
import '../../../../../../models/store.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class StoreStatsController extends GetxController {
  RxBool isLoading = true.obs;
  Map<DateTime, double> servicesPerDayData = {};
  List<PieChartModel> servicesPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  StoreStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminStoreStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminStoreStatsData');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminStoreStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminStoreStatsData', (data) async {
        final storesList = (data?['storeStats']?['stores'] as List?)?.map((e) => Store.fromJson(e)).toList() ?? [];
        final serviceUsage = (data?['storeStats']?['usages'] as List?)?.map((e) => Reservation.fromJson(e)).toList() ?? [];
        if (serviceUsage.isNotEmpty) _initChartPerDayData(serviceUsage);
        if (storesList.isNotEmpty) _initPieChartData(storesList);
        AdminDashboardController.totalStores.value = storesList.length;
        AdminDashboardController.totalServices.value = storesList.isNotEmpty ? storesList.map((e) => e.services).reduce((value, element) => value! + element!)?.length ?? 0 : 0;
        isLoading.value = false;
        update();
      });
    });
  }

  void _initChartPerDayData(List<Reservation> reservationList) {
    servicesPerDayData.clear();
    for (final reservation in reservationList) {
      DateTime date = reservation.date.normalize();
      if (servicesPerDayData.containsKey(date)) {
        servicesPerDayData[date] = servicesPerDayData[date]! + 1;
      } else {
        servicesPerDayData.putIfAbsent(date, () => 1);
      }
    }
    servicesPerDayData = Helper.sortByDateDesc(servicesPerDayData);
  }

  void _initPieChartData(List<Store> taskList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByCategory(taskList);
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      servicesPerCategoryData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      servicesPerCategoryData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < servicesPerCategoryData.length; i++) {
      servicesPerCategoryData[i].value = double.parse((servicesPerCategoryData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(servicesPerCategoryData);
  }

  Map<Category, double> getTotalByCategory(List<Store> storeList) {
    Map<Category, double> result = {};
    for (final store in storeList) {
      for (final service in store.services ?? []) {
        final categoryItem = service.category!;
        if (result.containsKey(categoryItem)) {
          result[categoryItem] = result[categoryItem]! + 1;
        } else {
          result.putIfAbsent(categoryItem, () => 1);
        }
      }
    }
    return Helper.sortByValueDesc<Category>(result);
  }
}
