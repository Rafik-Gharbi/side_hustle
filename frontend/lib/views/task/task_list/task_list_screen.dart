import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/filter_model.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/task_card.dart';
import '../../home/home_controller.dart';
import '../task_filter/more_filters_popup.dart';
import 'task_list_controller.dart';

class TaskListScreen extends StatelessWidget {
  static const String routeName = '/tasks';
  final FilterModel? filterModel;
  final String? searchQuery;
  final String? taskId;
  final bool boosted;

  const TaskListScreen({super.key, this.filterModel, this.searchQuery, this.taskId, this.boosted = false});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<TaskListController>(
        initState: (state) => Helper.waitAndExecute(
          () => state.controller != null,
          () => state.controller?.fetchSearchedTasks(searchQuery: searchQuery, filter: filterModel, taskId: taskId, boosted: boosted),
        ),
        builder: (controller) => Obx(
          () => CustomStandardScaffold(
            backgroundColor: kNeutralColor100,
            title: 'search_tasks'.tr,
            onBack: () {
              HomeController.find.filterModel = FilterModel();
              HomeController.find.searchController.clear();
            },
            actionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButtons.icon(
                  icon: Icon(controller.openSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined),
                  onPressed: () {
                    controller.openSearchBar.value = !controller.openSearchBar.value;
                    if (!controller.openSearchBar.value && controller.searchTaskController.text.isNotEmpty) {
                      controller.page = 0;
                      controller.fetchSearchedTasks(searchQuery: '');
                    }
                  },
                ),
                CustomButtons.icon(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () => Get.dialog(
                    MoreFiltersPopup(
                      updateFilter: (filter) => controller.filterModel = filter,
                      clearFilter: () => controller.filterModel = FilterModel(),
                      filter: controller.filterModel,
                    ),
                  ),
                ),
              ],
            ),
            appBarBottom: controller.openSearchBar.value
                ? AppBar(
                    backgroundColor: kNeutralColor100,
                    leading: const SizedBox(),
                    flexibleSpace: CustomTextField(
                      fieldController: controller.searchTaskController,
                      hintText: 'search_tasks'.tr,
                      suffixIcon: CustomButtons.icon(
                        icon: const Icon(Icons.search, color: kPrimaryColor),
                        onPressed: controller.searchTaskController.text.isNotEmpty
                            ? () {
                                controller.page = 0;
                                controller.fetchSearchedTasks();
                              }
                            : () {},
                      ),
                      fillColor: Colors.white,
                      onChanged: (value) => Helper.onSearchDebounce(
                        () {
                          if (value.length >= 3 || value.isEmpty) {
                            controller.page = 0;
                            controller.fetchSearchedTasks();
                          }
                        },
                      ),
                    ),
                  )
                : null,
            body: LoadingRequest(
              isLoading: controller.isLoading,
              child: controller.filteredTaskList.isEmpty
                  ? Center(child: Text('found_nothing'.tr, style: AppFonts.x14Regular))
                  : SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Column(
                        children: [
                          if (controller.filterModel.nearby != null &&
                              controller.filterModel.nearby! > 1 &&
                              !controller.filteredTaskList.any((element) => element.distance != null))
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.large),
                              child: Text('no_nearby_tasks_check_city_tasks'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                            ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredTaskList.length,
                            itemBuilder: (context, index) {
                              final task = controller.filteredTaskList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                child: TaskCard(task: task),
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
      ),
    );
  }
}
