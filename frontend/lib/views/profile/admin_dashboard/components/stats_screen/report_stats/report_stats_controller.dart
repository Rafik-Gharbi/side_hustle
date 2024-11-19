import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/dto/report_dto.dart';
import '../../../../../../models/enum/report_reasons.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class ReportStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> reportsPerDayData = {};
  List<PieChartModel> reportsPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ReportStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminReportStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminReportStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminReportStatsData', (data) async {
        final reportsList = (data?['reportStats'] as List?)?.map((e) => ReportDTO.fromJson(e)).toList() ?? [];
        if (reportsList.isNotEmpty) _initPieChartData(reportsList);
        AdminDashboardController.totalReports.value = reportsList.length;
        isLoading = false;
        update();
      });
    });
  }

  void _initPieChartData(List<ReportDTO> reportList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType(reportList);
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      reportsPerCategoryData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      reportsPerCategoryData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < reportsPerCategoryData.length; i++) {
      reportsPerCategoryData[i].value = double.parse((reportsPerCategoryData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(reportsPerCategoryData);
  }

  Map<ReportReasons, double> getTotalByType(List<ReportDTO> reportList) {
    Map<ReportReasons, double> result = {};
    for (final reportDto in reportList) {
      final reasonItem = reportDto.reasons;
      if (result.containsKey(reasonItem)) {
        result[reasonItem] = result[reasonItem]! + 1;
      } else {
        result.putIfAbsent(reasonItem, () => 1);
      }
    }
    return Helper.sortByValueDesc<ReportReasons>(result);
  }
}
