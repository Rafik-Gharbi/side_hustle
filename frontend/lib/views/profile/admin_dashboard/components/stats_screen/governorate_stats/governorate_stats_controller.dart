import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/contract.dart';
import '../../../../../../models/governorate.dart';
import '../../../../../../models/store.dart';
import '../../../../../../models/task.dart';
import '../../../../../../models/user.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../components/pie_chart.dart';

class GovernorateStatsController extends GetxController {
  bool isLoading = true;
  List<PieChartModel> storesPerGovernorateData = [];
  List<PieChartModel> tasksPerGovernorateData = [];
  List<PieChartModel> usersPerGovernorateData = [];
  List<PieChartModel> contractsPerGovernorateData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  GovernorateStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminGovernorateStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminGovernorateStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminGovernorateStatsData', (data) async {
        final storeList = (data?['governorateStats']?['stores'] as List?)?.map((e) => Store.fromJson(e)).toList() ?? [];
        final userList = (data?['governorateStats']?['users'] as List?)?.map((e) => User.fromJson(e)).toList() ?? [];
        final taskList = (data?['governorateStats']?['tasks'] as List?)?.map((e) => Task.fromJson(e)).toList() ?? [];
        final contractList = (data?['governorateStats']?['contracts'] as List?)?.map((e) => Contract.fromJson(e)).toList() ?? [];
        if (storeList.isNotEmpty) _initPieChartStoreData(storeList);
        if (userList.isNotEmpty) _initPieChartUserData(userList);
        if (taskList.isNotEmpty) _initPieChartTaskData(taskList);
        if (contractList.isNotEmpty) _initPieChartContractData(contractList);
        isLoading = false;
        update();
      });
    });
  }

  void _initPieChartStoreData(List<Store> favoriteList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType<Governorate>(favoriteList.where((element) => element.governorate != null).map((e) => e.governorate!).toList());
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      storesPerGovernorateData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      storesPerGovernorateData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < storesPerGovernorateData.length; i++) {
      storesPerGovernorateData[i].value = double.parse((storesPerGovernorateData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(storesPerGovernorateData);
  }

  void _initPieChartTaskData(List<Task> favoriteList) {
    // convert total expenses in result map value to percentage
    final totalTasksUseMap = getTotalByType<Governorate>(favoriteList.map((e) => e.governorate!).toList());
    double totalExpanses = 0;
    totalTasksUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalTasksUseMap.isNotEmpty) {
      tasksPerGovernorateData.clear();
    }
    totalTasksUseMap.forEach((key, value) {
      tasksPerGovernorateData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < tasksPerGovernorateData.length; i++) {
      tasksPerGovernorateData[i].value = double.parse((tasksPerGovernorateData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(tasksPerGovernorateData);
  }

  void _initPieChartUserData(List<User> favoriteList) {
    // convert total expenses in result map value to percentage
    final totalUsersUseMap = getTotalByType<Governorate>(favoriteList.map((e) => e.governorate!).toList());
    double totalExpanses = 0;
    totalUsersUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalUsersUseMap.isNotEmpty) {
      usersPerGovernorateData.clear();
    }
    totalUsersUseMap.forEach((key, value) {
      usersPerGovernorateData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < usersPerGovernorateData.length; i++) {
      usersPerGovernorateData[i].value = double.parse((usersPerGovernorateData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(usersPerGovernorateData);
  }

  void _initPieChartContractData(List<Contract> favoriteList) {
    // convert total expenses in result map value to percentage
    final totalContractsUseMap = getTotalByType<Governorate>(favoriteList.map((e) => e.provider!.governorate!).toList());
    double totalExpanses = 0;
    totalContractsUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalContractsUseMap.isNotEmpty) {
      contractsPerGovernorateData.clear();
    }
    totalContractsUseMap.forEach((key, value) {
      contractsPerGovernorateData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < contractsPerGovernorateData.length; i++) {
      contractsPerGovernorateData[i].value = double.parse((contractsPerGovernorateData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(contractsPerGovernorateData);
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
