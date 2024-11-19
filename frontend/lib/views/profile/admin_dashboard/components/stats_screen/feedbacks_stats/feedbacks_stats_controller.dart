import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/dto/feedback_dto.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../../../../widgets/feedback_bottomsheet.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class FeedbacksStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> feedbacksPerDayData = {};
  List<PieChartModel> feedbacksPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  FeedbacksStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminFeedbackStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminFeedbackStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminFeedbackStatsData', (data) async {
        final feedbacksList = (data?['feedbackStats'] as List?)?.map((e) => FeedbackDTO.fromJson(e)).toList() ?? [];
        if (feedbacksList.isNotEmpty) {
          _initChartPerDayData(feedbacksList);
          _initPieChartData(feedbacksList);
        }
        AdminDashboardController.totalFeedbacks.value = feedbacksList.length;
        isLoading = false;
        update();
      });
    });
  }

  void _initChartPerDayData(List<FeedbackDTO> feedbackList) {
    feedbacksPerDayData.clear();
    for (final feedback in feedbackList) {
      DateTime date = feedback.createdAt!.normalize();
      if (feedbacksPerDayData.containsKey(date)) {
        feedbacksPerDayData[date] = feedbacksPerDayData[date]! + 1;
      } else {
        feedbacksPerDayData.putIfAbsent(date, () => 1);
      }
    }
    feedbacksPerDayData = Helper.sortByDateDesc(feedbacksPerDayData);
  }

  void _initPieChartData(List<FeedbackDTO> feedbackList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType(feedbackList);
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      feedbacksPerCategoryData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      feedbacksPerCategoryData.add(PieChartModel(name: key.name, color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < feedbacksPerCategoryData.length; i++) {
      feedbacksPerCategoryData[i].value = double.parse((feedbacksPerCategoryData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(feedbacksPerCategoryData);
  }

  Map<FeedbackEmotion, double> getTotalByType(List<FeedbackDTO> feedbackList) {
    Map<FeedbackEmotion, double> result = {};
    for (final feedbackDto in feedbackList) {
      final categoryItem = feedbackDto.feedback;
      if (result.containsKey(categoryItem)) {
        result[categoryItem] = result[categoryItem]! + 1;
      } else {
        result.putIfAbsent(categoryItem, () => 1);
      }
    }
    return Helper.sortByValueDesc<FeedbackEmotion>(result);
  }
}
