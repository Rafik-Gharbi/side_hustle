import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_app_controller.dart';
import '../../helpers/helper.dart';
import '../../models/category.dart';
import '../../models/filter_model.dart';
import '../../models/task.dart';
import '../../networking/api_base_helper.dart';
import '../../repositories/task_repository.dart';
import '../task_list/task_list_screen.dart';

class HomeController extends GetxController {
  static HomeController get find => Get.find<HomeController>();
  // List<Task> tasks = [];
  List<Category> mostPopularCategories = [];
  List<Task> hotTasks = [];
  TextEditingController searchController = TextEditingController();
  // RxBool isSearchMode = false.obs;
  FilterModel _filterModel = FilterModel();

  FilterModel get filterModel => _filterModel;

  set filterModel(FilterModel value) {
    _filterModel = value;
    searchTask();
  }

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    Helper.waitAndExecute(() => MainAppController.find.isReady, () async {
      mostPopularCategories = MainAppController.find.categories.getRange(10, 14).toList();
      hotTasks = await TaskRepository.find.getHotTasks() ?? [];
      update();
    });
  }

  Future<void> searchTask({bool clear = false}) async {
    if (clear) {
      searchController.clear();
      filterModel = FilterModel();
    }
    if (searchController.text.isNotEmpty || filterModel.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(searchQuery: searchController.text, filterModel: filterModel))?.then(
          (value) {
            searchController.clear();
            filterModel = FilterModel();
          },
        ),
      );
    }
  }

  Future<void> onRefreshScreen() async {
    MainAppController.find.isBackReachable.value = await ApiBaseHelper.find.checkConnectionToBackend();
    // TODO fetch other tasks in hotTasks and nearbyTasks
  }
}
