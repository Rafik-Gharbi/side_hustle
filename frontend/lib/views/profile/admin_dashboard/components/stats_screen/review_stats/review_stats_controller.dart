import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/review.dart';
import '../../../../../../repositories/admin_repository.dart';
import '../components/pie_chart.dart';

class ReviewStatsController extends GetxController {
  bool isLoading = true;
  int totalReviews = 0;
  List<PieChartModel> reviewsPerRatingData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ReviewStatsController() {
    _init();
  }

  Future<void> _init() async {
    final reviewsList = await AdminRepository.find.getReviewStatsData();
    if (reviewsList != null) {
      _initPieChartData(reviewsList);
    }
    totalReviews = reviewsList?.length ?? 0;
    isLoading = false;
    update();
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
      reviewsPerRatingData.add(PieChartModel(name: Helper.formatAmount(key), color: Helper.getRandomColor(baseColor: kPrimaryColor), value: value, amount: value));
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
