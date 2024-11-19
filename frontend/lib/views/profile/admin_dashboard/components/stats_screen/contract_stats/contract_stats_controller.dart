import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/contract.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';

class ContractStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> contractsPerDayData = {};

  ContractStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminContractStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminContractStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminContractStatsData', (data) async {
        final contractList = (data?['contractStats'] as List?)?.map((e) => Contract.fromJson(e)).toList() ?? [];
        if (contractList.isNotEmpty) _initContractsPerDayData(contractList);
        AdminDashboardController.totalContract.value = contractList.length;
        AdminDashboardController.totalPayedContract.value = contractList.where((element) => element.isPayed).length;
        AdminDashboardController.activeContract.value = contractList.where((element) => element.dueDate!.isAfter(DateTime.now())).length;
        isLoading = false;
        update();
      });
    });
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
