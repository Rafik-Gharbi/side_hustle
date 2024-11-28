import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/review.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class ReviewStatsController extends GetxController {
  RxBool isLoading = true.obs;
  List<PieChartModel> reviewsPerRatingData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ReviewStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminReviewStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminReviewStatsData');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminReviewStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminReviewStatsData', (data) async {
        final reviewsList = (data?['reviewStats'] as List?)?.map((e) => Review.fromJson(e)).toList() ?? [];
        if (reviewsList.isNotEmpty) _initPieChartData(reviewsList);
        AdminDashboardController.totalReviews.value = reviewsList.length;
        isLoading.value = false;
        update();
      });
    });
  }

  void _initPieChartData(List<Review> reviewList) {
    // convert total expenses in result map value to percentage
    final totalCategoriesUseMap = getTotalByType<double>(reviewList.map((e) => e.rating).toList());
    double totalExpanses = 0;
    totalCategoriesUseMap.forEach((key, value) => totalExpanses += value);
    // convert data to chart data
    if (totalCategoriesUseMap.isNotEmpty) {
      reviewsPerRatingData.clear();
    }
    totalCategoriesUseMap.forEach((key, value) {
      reviewsPerRatingData.add(PieChartModel(name: Helper.formatAmount(key), color: Helper.getRandomColor(), value: value, amount: value));
    });

    for (int i = 0; i < reviewsPerRatingData.length; i++) {
      reviewsPerRatingData[i].value = double.parse((reviewsPerRatingData[i].value * 100 / totalExpanses).toStringAsFixed(1));
    }
    pieChartTouchedIndex = Helper.resolveBiggestIndex(reviewsPerRatingData);
  }

  Map<T, double> getTotalByType<T>(List<T> reviewList) {
    Map<T, double> result = {};
    for (final reviewDto in reviewList) {
      if (result.containsKey(reviewDto)) {
        result[reviewDto] = result[reviewDto]! + 1;
      } else {
        result.putIfAbsent(reviewDto, () => 1);
      }
    }
    return Helper.sortByValueDesc<T>(result);
  }
}
