import 'package:get/get.dart';

import '../../../../../../helpers/helper.dart';
import '../../../../../../repositories/admin_repository.dart';

class ContractStatsController extends GetxController {
  bool isLoading = true;
  int totalContracts = 0;
  int payedContracts = 0;
  int activeContracts = 0;
  Map<DateTime, double> contractsPerDayData = {};

  ContractStatsController() {
    _init();
  }

  Future<void> _init() async {
    final contractList = await AdminRepository.find.getContractStatsData();
    if (contractList != null) _initContractsPerDayData(contractList);
    totalContracts = contractList?.length ?? 0;
    payedContracts = contractList?.where((element) => element.isPayed).length ?? 0;
    activeContracts = contractList?.where((element) => element.dueDate!.isAfter(DateTime.now())).length ?? 0;
    isLoading = false;
    update();
  }

  void _initContractsPerDayData(contractList) {
    contractsPerDayData.clear();
    for (final user in contractList) {
      DateTime date = user.createdAt!.normalize();
      if (contractsPerDayData.containsKey(date)) {
        contractsPerDayData[date] = contractsPerDayData[date]! + 1;
      } else {
        contractsPerDayData.putIfAbsent(date, () => 1);
      }
    }
    contractsPerDayData = Helper.sortByDateDesc(contractsPerDayData);
  }
}
