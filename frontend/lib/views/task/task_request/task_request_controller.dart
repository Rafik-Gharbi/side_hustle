import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/task_request_dto.dart';
import '../../../models/task.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/task_repository.dart';
import '../add_task/add_task_bottomsheet.dart';
import '../task_proposal/task_proposal_screen.dart';

class TaskRequestController extends GetxController {
  final ScrollController scrollController = ScrollController();
  List<TaskRequestDTO> _taskRequestList = [];
  bool isLoading = true;
  List<Task> filteredTaskList = [];
  bool isEndList = false;
  int page = 0;
  RxBool isLoadingMore = true.obs;
  Task? highlightedTask;

  TaskRequestController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
    _init();
  }

  void removeTaskFromList(Task task) {
    _taskRequestList.removeWhere((element) => element.task.id == task.id);
    filteredTaskList.remove(task);
    update();
  }

  Future<void> _init() async {
    page = 0;
    isEndList = false;
    await _fetchTaskRequest();
    if (Get.arguments != null) highlightedTask = filteredTaskList.cast<Task?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    if (highlightedTask != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedTask = null;
        update();
      });
    }

    isLoading = false;
    update();
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    _fetchTaskRequest().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }

  Future<void> _fetchTaskRequest() async {
    final taskRequests = await TaskRepository.find.listUserTaskRequest(page: ++page) ?? [];
    if ((taskRequests.isEmpty) || taskRequests.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      _taskRequestList = taskRequests;
      filteredTaskList = taskRequests.map((e) => e.task).toList();
      isLoading = false;
    } else {
      _taskRequestList.addAll(taskRequests);
      filteredTaskList.addAll(taskRequests.map((e) => e.task).toList());
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> editTask(Task task) async => Get.bottomSheet(AddTaskBottomsheet(task: task), isScrollControlled: true).then((value) => _init());

  void deleteTask(Task task) => Helper.openConfirmationDialog(
        title: 'delete_task_msg'.trParams({'taskTitle': task.title}),
        onConfirm: () => TaskRepository.find.deleteTask(task).then((value) => Future.delayed(const Duration(milliseconds: 400), () => _init())),
      );

  void openProposals(Task task) => Get.toNamed(TaskProposalScreen.routeName, arguments: task);

  int getTaskCondidates(Task task) => _taskRequestList.singleWhere((taskRequest) => taskRequest.task.id == task.id).condidates;
}
