import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/task_card.dart';
import '../../profile/profile_screen/profile_controller.dart';
import 'task_request_controller.dart';

class TaskRequestScreen extends StatelessWidget {
  static const String routeName = '/task-request';
  const TaskRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<TaskRequestController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          onBack: () => ProfileController.find.init(),
          appBarTitle: 'Tasks Request',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.filteredTaskList.isEmpty
                ? const Center(child: Text('We found nothing!', style: AppFonts.x14Regular))
                : SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredTaskList.length,
                          itemBuilder: (context, index) {
                            final task = controller.filteredTaskList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                              child: TaskCard(
                                task: task,
                                onEditTask: () => controller.editTask(task),
                                onDeleteTask: () => controller.deleteTask(task),
                                onOpenProposals: () => controller.openProposals(task),
                                condidates: controller.getTaskCondidates(task),
                              ),
                            );
                          },
                        ),
                        Obx(
                          () => controller.isLoadingMore.value && !controller.isEndList
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: Paddings.extraLarge),
                                  child: SizedBox(height: 60, width: Get.width, child: Center(child: Buildables.buildLoadingWidget(height: 80))),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
