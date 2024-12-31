import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/filter_model.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
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
          () => CustomScaffoldBottomNavigation(
            appBarTitle: 'search_tasks'.tr,
            onBack: () {
              HomeController.find.filterModel = FilterModel();
              HomeController.find.searchController.clear();
            },
            appBarActions: [
              CustomButtons.icon(
                icon: Icon(controller.openSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined),
                onPressed: () => controller.openSearchBar.value = !controller.openSearchBar.value,
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
            appBarBottom: controller.openSearchBar.value
                ? AppBar(
                    backgroundColor: kNeutralColor100,
                    leading: const SizedBox(),
                    flexibleSpace: CustomTextField(
                      fieldController: controller.searchTaskController,
                      hintText: 'search_tasks'.tr,
                      suffixIcon: const Icon(Icons.search, color: kPrimaryColor),
                      fillColor: Colors.white,
                      onChanged: (value) => Helper.onSearchDebounce(
                        () => value.length >= 3 || value.isEmpty ? controller.fetchSearchedTasks() : null,
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
