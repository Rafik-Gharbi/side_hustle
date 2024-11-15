import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/coin_pack.dart';
import '../../../../../../repositories/admin_repository.dart';
import '../components/pie_chart.dart';

class CoinsStatsController extends GetxController {
    bool isLoading = true;
  int totalCoinPacksSold = 0;
  int totalActiveCoinPacks = 0;
  Map<DateTime, double> coinPacksPerDayData = {};
  List<PieChartModel> coinPacksPerCategoryData = [];
  int _pieChartTouchedIndex = -1;


  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  CoinsStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (coinPacksList, activeCount) = await AdminRepository.find.getCoinPackStatsData();
    if (coinPacksList != null) {
      _initChartPerDayData(coinPacksList);
      _initPieChartData(coinPacksList);
    }
    totalCoinPacksSold = coinPacksList?.length ?? 0;
    totalActiveCoinPacks = activeCount ?? 0;
    isLoading = false;
    update();
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
      coinPacksPerCategoryData.add(PieChartModel(name: key.title, color: Helper.getRandomColor(baseColor: kPrimaryColor), value: value, amount: value));
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
