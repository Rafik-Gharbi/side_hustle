import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/filter_model.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class TaskListController extends GetxController {
  List<Task> taskList = [];
  List<Task> filteredTaskList = [];
  TextEditingController searchTaskController = TextEditingController();
  RxBool openSearchBar = false.obs;
  bool isLoading = true;
  FilterModel _filterModel = FilterModel();

  FilterModel get filterModel => _filterModel;

  set filterModel(FilterModel value) {
    _filterModel = value;
    fetchSearchedTasks(filter: _filterModel);
  }

  Future<void> getAllTasks() async {
    taskList = await TaskRepository.find.getAllTasks() ?? [];
    filteredTaskList = List.of(taskList);
    isLoading = false;
    update();
  }

  Future<void> fetchSearchedTasks({FilterModel? filter, String? searchQuery}) async {
    if (filter != null || searchQuery != null) {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        openSearchBar.value = true;
        searchTaskController.text = searchQuery;
      }
      if (filter != null) _filterModel = filter;
      taskList = await TaskRepository.find.filterTasks(searchQuery: searchQuery ?? '', filter: filter ?? FilterModel()) ?? [];
      filteredTaskList = List.of(taskList);
      isLoading = false;
      update();
    }
  }

  void searchTasks() {
    if (searchTaskController.text.isEmpty) {
      filteredTaskList = List.of(taskList);
    } else {
      filteredTaskList = List.of(taskList.where(
        (element) =>
            element.title.toLowerCase().contains(searchTaskController.text.toLowerCase()) || element.description.toLowerCase().contains(searchTaskController.text.toLowerCase()),
      ));
    }
    update();
  }
}
