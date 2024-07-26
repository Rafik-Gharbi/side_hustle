import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/store_card.dart';
import '../../widgets/task_card.dart';
import 'favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  static const String routeName = '/my-bookmarks';
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<FavoriteController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'My bookmarks',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.savedTaskList.isEmpty && controller.savedStoreList.isEmpty
                ? const Center(child: Text('You haven\'t bookmarked anything yet!', style: AppFonts.x14Regular))
                : Theme(
                    data: ThemeData(dividerColor: Colors.transparent),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (controller.savedStoreList.isNotEmpty)
                            ExpansionTile(
                              title: const Text('Saved stores', style: AppFonts.x15Bold),
                              initiallyExpanded: true,
                              children: List.generate(
                                controller.savedStoreList.length,
                                (index) {
                                  final store = controller.savedStoreList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                    child: StoreCard(store: store, onRemoveFavorite: () => controller.removeStoreFromList(store)),
                                  );
                                },
                              ),
                            ),
                          if (controller.savedTaskList.isNotEmpty)
                            ExpansionTile(
                              title: const Text('Saved tasks', style: AppFonts.x15Bold),
                              initiallyExpanded: true,
                              children: List.generate(
                                controller.savedTaskList.length,
                                (index) {
                                  final task = controller.savedTaskList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                    child: TaskCard(task: task, onRemoveFavorite: () => controller.removeTaskFromList(task)),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
