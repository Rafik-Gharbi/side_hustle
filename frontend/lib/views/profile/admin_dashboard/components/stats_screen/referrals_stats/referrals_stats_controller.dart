import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/referral.dart';
import '../../../../../../repositories/admin_repository.dart';
import '../components/pie_chart.dart';

class ReferralsStatsController extends GetxController {
  bool isLoading = true;
  int totalReferrals = 0;
  int totalSuccessfulReferrals = 0;
  List<PieChartModel> referralsPerStatusData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ReferralsStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (referralsList, referralSuccessCount) = await AdminRepository.find.getReferralsStatsData();
    if (referralsList != null) {
      _initPieChartData(referralsList);
    }
    totalReferrals = referralsList?.length ?? 0;
    totalSuccessfulReferrals = referralSuccessCount ?? 0;
    isLoading = false;
    update();
  }

  void _initPieChartData(List<Referral> referralList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType<ReferralStatus>(referralList.map((e) => e.status).toList());
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      referralsPerStatusData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      referralsPerStatusData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(baseColor: kPrimaryColor), value: value, amount: value));
    });

    for (int i = 0; i < referralsPerStatusData.length; i++) {
      referralsPerStatusData[i].value = double.parse((referralsPerStatusData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(referralsPerStatusData);
  }

  Map<T, double> getTotalByType<T>(List<T> referralList) {
    Map<T, double> result = {};
    for (final referralDto in referralList) {
      if (result.containsKey(referralDto)) {
        result[referralDto] = result[referralDto]! + 1;
      } else {
        result.putIfAbsent(referralDto, () => 1);
      }
    }
    return Helper.sortByValueDesc<T>(result);
  }
}
