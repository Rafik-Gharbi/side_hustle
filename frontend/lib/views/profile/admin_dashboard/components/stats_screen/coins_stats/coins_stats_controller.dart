import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/coin_pack.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class CoinsStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> coinPacksPerDayData = {};
  List<PieChartModel> coinPacksPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  CoinsStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminCoinStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminCoinStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminCoinStatsData', (data) async {
        final coinPacksList = (data?['coinStats']?['coinPacksList'] as List?)?.map((e) => CoinPack.fromJson(e)).toList() ?? [];
        if (coinPacksList.isNotEmpty) {
          _initChartPerDayData(coinPacksList);
          _initPieChartData(coinPacksList);
        }
        AdminDashboardController.totalCoinPacksSold.value = coinPacksList.length;
        AdminDashboardController.totalActiveCoinPacks.value = data?['coinStats']?['activeCount'] ?? 0;
        isLoading = false;
        update();
      });
    });
  }

  void _initChartPerDayData(List<CoinPack> coinPackList) {
    coinPacksPerDayData.clear();
    for (final coinPack in coinPackList) {
      DateTime date = coinPack.createdAt.normalize();
      if (coinPacksPerDayData.containsKey(date)) {
        coinPacksPerDayData[date] = coinPacksPerDayData[date]! + 1;
      } else {
        coinPacksPerDayData.putIfAbsent(date, () => 1);
      }
    }
    coinPacksPerDayData = Helper.sortByDateDesc(coinPacksPerDayData);
  }

  void _initPieChartData(List<CoinPack> coinPackList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType(coinPackList);
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      coinPacksPerCategoryData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      coinPacksPerCategoryData.add(PieChartModel(name: key.title, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < coinPacksPerCategoryData.length; i++) {
      coinPacksPerCategoryData[i].value = double.parse((coinPacksPerCategoryData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(coinPacksPerCategoryData);
  }

  Map<CoinPack, double> getTotalByType(List<CoinPack> coinPackList) {
    Map<CoinPack, double> result = {};
    for (final coinPack in coinPackList) {
      final categoryItem = coinPack;
      if (result.containsKey(categoryItem)) {
        result[categoryItem] = result[categoryItem]! + 1;
      } else {
        result.putIfAbsent(categoryItem, () => 1);
      }
    }
    return Helper.sortByValueDesc<CoinPack>(result);
  }
}
