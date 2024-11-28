import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/referral.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class ReferralsStatsController extends GetxController {
  RxBool isLoading = true.obs;
  List<PieChartModel> referralsPerStatusData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ReferralsStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminReferralStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminReferralStatsData');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminReferralStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminReferralStatsData', (data) async {
        final referralsList = (data?['referralStats']?['depositList'] as List?)?.map((e) => Referral.fromJson(e)).toList() ?? [];
        if (referralsList.isNotEmpty) _initPieChartData(referralsList);
        AdminDashboardController.totalReferrals.value = referralsList.length;
        AdminDashboardController.totalSuccessReferrals.value = data?['referralStats']?['successCount'] ?? 0;
        isLoading.value = false;
        update();
      });
    });
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
      referralsPerStatusData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
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
