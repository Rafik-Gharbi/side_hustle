import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/balance_transaction.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';

class BalanceStatsController extends GetxController {
  RxBool isLoading = true.obs;
  int totalUsersHasBalance = 0;
  Map<DateTime, double> depositsPerDayData = {};
  Map<DateTime, double> withdrawalsPerDayData = {};

  BalanceStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminBalanceStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminBalanceStatsData');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminBalanceStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminBalanceStatsData', (data) async {
        final depositList = (data?['balanceStats']?['depositList'] as List?)?.map((e) => BalanceTransaction.fromJson(e)).toList() ?? [];
        final withdrawalList = (data?['balanceStats']?['withdrawalList'] as List?)?.map((e) => BalanceTransaction.fromJson(e)).toList() ?? [];
        if (depositList.isNotEmpty && withdrawalList.isNotEmpty) _initChartPerDayData(depositList, withdrawalList);
        AdminDashboardController.totalDeposits.value = depositList.length;
        AdminDashboardController.totalWithdrawals.value = withdrawalList.length;
        AdminDashboardController.maxUserBalance.value = data?['balanceStats']?['maxBalance'] ?? 0;
        totalUsersHasBalance = data?['balanceStats']?['totalUsers'] ?? 0;
        isLoading.value = false;
        update();
      });
    });
  }

  void _initChartPerDayData(List<BalanceTransaction> depositList, List<BalanceTransaction> withdrawalList) {
    depositsPerDayData.clear();
    withdrawalsPerDayData.clear();
    for (final transaction in depositList) {
      DateTime date = transaction.createdAt!.normalize();
      if (depositsPerDayData.containsKey(date)) {
        depositsPerDayData[date] = depositsPerDayData[date]! + 1;
      } else {
        depositsPerDayData.putIfAbsent(date, () => 1);
      }
    }
    depositsPerDayData = Helper.sortByDateDesc(depositsPerDayData);
    for (final transaction in withdrawalList) {
      DateTime date = transaction.createdAt!.normalize();
      if (withdrawalsPerDayData.containsKey(date)) {
        withdrawalsPerDayData[date] = withdrawalsPerDayData[date]! + 1;
      } else {
        withdrawalsPerDayData.putIfAbsent(date, () => 1);
      }
    }
    withdrawalsPerDayData = Helper.sortByDateDesc(withdrawalsPerDayData);
  }
}
