import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/task_request_dto.dart';
import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../repositories/task_repository.dart';
import '../add_task/add_task_bottomsheet.dart';
import '../task_proposal/task_proposal_screen.dart';

class MyRequestController extends GetxController {
  final ScrollController scrollController = ScrollController();
  List<TaskRequestDTO> _taskRequestList = [];
  List<Task> myTaskList = [];
  List<Reservation> myReservationList = [];
  bool isEndReservationList = false;
  bool isEndTaskList = false;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  int taskPage = 0;
  int servicePage = 0;
  Task? highlightedTask;
  Reservation? highlightedReservation;
  RxInt tabControllerIndex = 0.obs;

  MyRequestController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
    ever(
      tabControllerIndex,
      (callback) => tabControllerIndex.value == 1 && myReservationList.isEmpty
          ? _fetchReservationRequest(fixPage: 1)
          : tabControllerIndex.value == 0 && myTaskList.isEmpty
              ? _fetchTaskRequest(fixPage: 1)
              : null,
    );
    _init();
  }

  void removeTaskFromList(Task task) {
    _taskRequestList.removeWhere((element) => element.task.id == task.id);
    myTaskList.remove(task);
    update();
  }

  Future<void> _init() async {
    taskPage = 0;
    isEndReservationList = false;
    isEndTaskList = false;
    await _fetchTaskRequest();
    if (Get.arguments?['taskId'] != null) highlightedTask = myTaskList.cast<Task?>().singleWhere((element) => element?.id == Get.arguments['taskId'], orElse: () => null);
    if (Get.arguments?['bookingId'] != null) {
      await _fetchReservationRequest();
      highlightedReservation = myReservationList.cast<Reservation?>().singleWhere((element) => element?.id == Get.arguments['bookingId'], orElse: () => null);
    }
    if (highlightedTask != null || highlightedReservation != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedTask = null;
        highlightedReservation = null;
        update();
      });
    }

    isLoading.value = false;
    update();
  }

  Future<void> _loadMore() async {
    if (ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    if (tabControllerIndex.value == 0) {
      if (isEndTaskList) return;
      _fetchTaskRequest().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
    } else {
      if (isEndReservationList) return;
      _fetchReservationRequest().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
    }
  }

  Future<void> _fetchTaskRequest({int? fixPage}) async {
    if (fixPage != null) {
      taskPage = fixPage;
      isEndTaskList = false;
    }
    final taskRequests = await TaskRepository.find.listUserTaskRequest(page: fixPage ?? ++taskPage) ?? [];
    if ((taskRequests.isEmpty) || taskRequests.length < kLoadMoreLimit) isEndTaskList = true;
    if (taskPage == 1) {
      _taskRequestList = taskRequests;
      myTaskList = taskRequests.map((e) => e.task).toList();
      isLoading.value = false;
    } else {
      _taskRequestList.addAll(taskRequests);
      myTaskList.addAll(taskRequests.map((e) => e.task).toList());
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> _fetchReservationRequest({int? fixPage}) async {
    if (fixPage != null) {
      taskPage = fixPage;
      isEndReservationList = false;
    }
    final serviceRequests = await ReservationRepository.find.getUserRequestedReservations(page: fixPage ?? ++servicePage);
    if ((serviceRequests.isEmpty) || serviceRequests.length < kLoadMoreLimit) isEndReservationList = true;
    if (taskPage == 1) {
      myReservationList = serviceRequests;
      isLoading.value = false;
    } else {
      myReservationList.addAll(serviceRequests);
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> editTask(Task task) async => Get.bottomSheet(AddTaskBottomsheet(task: task), isScrollControlled: true).then((value) => _init());

  void deleteTask(Task task) => Helper.openConfirmationDialog(
        content: 'delete_task_msg'.trParams({'taskTitle': task.title}),
        onConfirm: () => TaskRepository.find.deleteTask(task).then((value) => Future.delayed(const Duration(milliseconds: 400), () => _init())),
      );

  void openProposals(Task task) => Get.toNamed(TaskProposalScreen.routeName, arguments: task);

  int getTaskCondidates(Task task) => _taskRequestList.singleWhere((taskRequest) => taskRequest.task.id == task.id).condidates;
}
