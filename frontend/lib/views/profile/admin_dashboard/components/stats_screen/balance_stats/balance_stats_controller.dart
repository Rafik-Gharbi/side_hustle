import 'package:get/get.dart';

import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/balance_transaction.dart';
import '../../../../../../repositories/admin_repository.dart';

class BalanceStatsController extends GetxController {
  bool isLoading = true;
  int totalDeposits = 0;
  int totalWithdrawals = 0;
  int maxUserBalance = 0;
  int totalUsersHasBalance = 0;
  Map<DateTime, double> depositsPerDayData = {};
  Map<DateTime, double> withdrawalsPerDayData = {};

  BalanceStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (depositList, withdrawalList, maxBalance, totalUsers) = await AdminRepository.find.getBalanceStatsData();
    if (depositList != null && withdrawalList != null) _initChartPerDayData(depositList, withdrawalList);
    totalDeposits = depositList?.length ?? 0;
    totalWithdrawals = withdrawalList?.length ?? 0;
    maxUserBalance = maxBalance ?? 0;
    totalUsersHasBalance = totalUsers ?? 0;
    isLoading = false;
    update();
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
