import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../models/filter_model.dart';
import '../../../models/task.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/task_repository.dart';

class TaskListController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchTaskController = TextEditingController();
  List<Task> taskList = [];
  List<Task> filteredTaskList = [];
  RxBool openSearchBar = false.obs;
  bool isLoading = true;
  RxBool isLoadingMore = true.obs;
  FilterModel _filterModel = FilterModel();
  bool isEndList = false;
  int page = 0;

  FilterModel get filterModel => _filterModel;

  set filterModel(FilterModel value) {
    _filterModel = value;
    page = 0;
    isEndList = false;
    fetchSearchedTasks(filter: _filterModel);
  }

  TaskListController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
  }

  Future<void> getAllTasks() async {
    taskList = await TaskRepository.find.filterTasks(page: ++page) ?? [];
    filteredTaskList = List.of(taskList);
    isLoading = false;
    update();
  }

  Future<void> fetchSearchedTasks({FilterModel? filter, String? searchQuery, int? taskId}) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      openSearchBar.value = true;
      searchTaskController.text = searchQuery;
    }
    if (filter != null) _filterModel = filter;
    if (page > 1) isLoadingMore.value = true;
    taskList = await TaskRepository.find.filterTasks(page: ++page, searchQuery: searchTaskController.text, filter: _filterModel, taskId: taskId) ?? [];
    if ((taskList.isEmpty) || taskList.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      filteredTaskList = taskList;
      isLoading = false;
    } else {
      filteredTaskList.addAll(taskList);
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    fetchSearchedTasks().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }
}
