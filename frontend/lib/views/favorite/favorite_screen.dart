import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/task_card.dart';
import 'favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  static const String routeName = '/saved-task';
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<FavoriteController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'Saved Tasks',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.savedTaskList.isEmpty
                ? const Center(child: Text('You haven\'t saved any task yet!', style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.savedTaskList.length,
                    itemBuilder: (context, index) {
                      final task = controller.savedTaskList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                        child: TaskCard(task: task, onRemoveFavorite: () => controller.removeTaskFromList(task)),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
