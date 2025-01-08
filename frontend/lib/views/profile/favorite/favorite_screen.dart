import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/store_card.dart';
import '../../../widgets/task_card.dart';
import 'favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  static const String routeName = '/my-bookmarks';
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<FavoriteController>(
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'my_bookmarks'.tr,
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.savedTaskList.isEmpty && controller.savedStoreList.isEmpty
                ? Center(child: Text('no_bookmark_yet'.tr, style: AppFonts.x14Regular))
                : Theme(
                    data: ThemeData(dividerColor: Colors.transparent),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (controller.savedStoreList.isNotEmpty)
                            ExpansionTile(
                              title: Text('saved_stores'.tr, style: AppFonts.x15Bold),
                              initiallyExpanded: true,
                              children: List.generate(
                                controller.savedStoreList.length,
                                (index) {
                                  final store = controller.savedStoreList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                    child: StoreCard(
                                        store: store,
                                        onRemoveFavorite: () {
                                          controller.removeStoreFromList(store);
                                          controller.init();
                                        }),
                                  );
                                },
                              ),
                            ),
                          if (controller.savedTaskList.isNotEmpty)
                            ExpansionTile(
                              title: Text('saved_tasks'.tr, style: AppFonts.x15Bold),
                              initiallyExpanded: true,
                              children: List.generate(
                                controller.savedTaskList.length,
                                (index) {
                                  final task = controller.savedTaskList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                    child: TaskCard(
                                        task: task,
                                        onRemoveFavorite: () {
                                          controller.removeTaskFromList(task);
                                          controller.init();
                                        }),
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
