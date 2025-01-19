import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/reservation_repository.dart';

class MyOffersController extends GetxController {
  final ScrollController scrollController = ScrollController();
  List<Reservation> _taskHistoryList = [];
  List<Reservation> _serviceHistoryList = [];
  Reservation? highlightedTaskReservation;
  Reservation? highlightedServiceReservation;
  RxBool isLoading = true.obs;
  bool isEndServiceList = false;
  bool isEndTaskList = false;
  int servicePage = 0;
  int taskPage = 0;
  RxBool isLoadingMore = true.obs;
  RxInt tabControllerIndex = 0.obs;

  List<Reservation> get ongoingTasks => _taskHistoryList.where((element) => element.status == RequestStatus.confirmed).toList();
  List<Reservation> get pendingTasks => _taskHistoryList.where((element) => element.status == RequestStatus.pending).toList();
  List<Reservation> get finishedTasks => _taskHistoryList.where((element) => element.status == RequestStatus.finished).toList();
  List<Reservation> get rejectedTasks => _taskHistoryList.where((element) => element.status == RequestStatus.rejected).toList();
  List<Reservation> get finishedServices => _serviceHistoryList.where((element) => element.status == RequestStatus.finished).toList();
  List<Reservation> get rejectedServices => _serviceHistoryList.where((element) => element.status == RequestStatus.rejected).toList();
  bool get hasNoTasksYet => _taskHistoryList.isEmpty;
  bool get hasNoServicesYet => _serviceHistoryList.isEmpty;

  MyOffersController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
    init();
    ever(
      tabControllerIndex,
      (callback) => tabControllerIndex.value == 1 && _serviceHistoryList.isEmpty
          ? _fetchServiceOffers(fixPage: 1)
          : tabControllerIndex.value == 0 && _taskHistoryList.isEmpty
              ? _fetchTaskOffers(fixPage: 1)
              : null,
    );
  }

  Future<void> init() async {
    await _fetchTaskOffers();
    if (Get.arguments != null) highlightedTaskReservation = _taskHistoryList.cast<Reservation?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    if (highlightedTaskReservation != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedTaskReservation = null;
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
      _fetchTaskOffers().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
    } else {
      if (isEndServiceList) return;
      _fetchServiceOffers().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
    }
  }

  Future<void> _fetchTaskOffers({int? fixPage}) async {
    if (fixPage != null) {
      taskPage = fixPage;
      isEndTaskList = false;
    }
    final taskRequests = await ReservationRepository.find.getUserTasksOffers(page: fixPage ?? taskPage);
    if ((taskRequests.isEmpty) || taskRequests.length < kLoadMoreLimit) isEndTaskList = true;
    if (taskPage == 1) {
      _taskHistoryList = taskRequests;
      isLoading.value = false;
    } else {
      _taskHistoryList.addAll(taskRequests);
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> _fetchServiceOffers({int? fixPage}) async {
    if (fixPage != null) {
      servicePage = fixPage;
      isEndServiceList = false;
    }
    final serviceRequests = await ReservationRepository.find.getUserProvidedServices(page: fixPage ?? servicePage);
    if ((serviceRequests.isEmpty) || serviceRequests.length < kLoadMoreLimit) isEndServiceList = true;
    if (servicePage == 1) {
      _serviceHistoryList = serviceRequests;
      isLoading.value = false;
    } else {
      _serviceHistoryList.addAll(serviceRequests);
      isLoadingMore.value = false;
    }
    update();
  }
}
