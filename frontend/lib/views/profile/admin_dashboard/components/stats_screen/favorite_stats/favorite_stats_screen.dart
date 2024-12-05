import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/sizes.dart';
import '../../../../../../widgets/loading_request.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';
import '../../../../../../widgets/custom_standard_scaffold.dart';
import '../components/three_stats_overview.dart';
import 'favorite_stats_controller.dart';

class FavoriteStatsScreen extends StatelessWidget {
  static const String routeName = '/favorite-stats';
  const FavoriteStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Favorite: Total favorites, Stores per favorites, Users per favorites
    return GetBuilder<FavoriteStatsController>(
      builder: (controller) => CustomStandardScaffold(
        title: 'favorite'.tr,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: LoadingRequest(
              isLoading: controller.isLoading,
              child: Column(
                children: [
                  // Favorite: Total favorites, Favorites per favoriteEnum, Favorite's messages
                  ThreeStatsOverview(
                    leftNumber: controller.totalFavorites,
                    leftLabel: 'total_favorite'.tr,
                    middleNumber: AdminDashboardController.totalStoresFavorite.value,
                    middleLabel: 'total_stores_favorite'.tr,
                    rightNumber: AdminDashboardController.totalTasksFavorite.value,
                    rightLabel: 'total_tasks_favorite'.tr,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'favorites_per_store'.tr,
                    pieChartData: controller.favoritesPerStoreData,
                  ),
                  const SizedBox(height: Paddings.large),
                  PieChartWidget(
                    title: 'favorites_per_task'.tr,
                    pieChartData: controller.favoritesPerTaskData,
                  ),
                  const SizedBox(height: Paddings.large),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
