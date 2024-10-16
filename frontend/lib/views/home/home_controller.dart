import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_app_controller.dart';
import '../../helpers/helper.dart';
import '../../models/category.dart';
import '../../models/enum/request_status.dart';
import '../../models/filter_model.dart';
import '../../models/reservation.dart';
import '../../models/task.dart';
import '../../networking/api_base_helper.dart';
import '../../repositories/reservation_repository.dart';
import '../../repositories/task_repository.dart';
import '../task/task_list/task_list_screen.dart';

class HomeController extends GetxController {
  static HomeController get find => Get.find<HomeController>();
  // List<Task> tasks = [];
  List<Category> mostPopularCategories = [];
  List<Task> hotTasks = [];
  List<Task> nearbyTasks = [];
  List<Reservation> taskReservations = [];
  List<Reservation> ongoingTaskReservations = [];
  List<Reservation> serviceReservations = [];
  List<Reservation> ongoingServiceReservations = [];
  TextEditingController searchController = TextEditingController();
  // RxBool isSearchMode = false.obs;
  FilterModel _filterModel = FilterModel();
  RxBool isLoading = true.obs;

  FilterModel get filterModel => _filterModel;

  set filterModel(FilterModel value) {
    _filterModel = value;
    searchTask();
  }

  HomeController() {
    init();
  }

  Future<void> init() async {
    Helper.waitAndExecute(() => MainAppController.find.isReady, () async {
      // TODO adapt user preferences if selected most searched categories and fix this below by getting true popular categories from BE
      mostPopularCategories = MainAppController.find.categories.getRange(10, 14).toList();
      final result = await TaskRepository.find.getHomeTasks();
      hotTasks = result?['hotTasks'] != null ? (result?['hotTasks'] as List).map((e) => e as Task).toList() : [];
      nearbyTasks = result?['nearbyTasks'] != null ? (result?['nearbyTasks'] as List).map((e) => e as Task).toList() : [];
      taskReservations = result?['reservation'] != null ? (result?['reservation'] as List).map((e) => e as Reservation).toList() : [];
      ongoingTaskReservations = result?['ongoingReservation'] != null ? (result?['ongoingReservation'] as List).map((e) => e as Reservation).toList() : [];
      serviceReservations = result?['booking'] != null ? (result?['booking'] as List).map((e) => e as Reservation).toList() : [];
      ongoingServiceReservations = result?['ongoingBooking'] != null ? (result?['ongoingBooking'] as List).map((e) => e as Reservation).toList() : [];
      isLoading.value = false;
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
    init();
  }

  void markServiceReservationAsDone(Reservation serviceReservation) => Helper.openConfirmationDialog(
        title: 'mark_service_done_msg'.tr,
        onConfirm: () async {
          await ReservationRepository.find.updateServiceReservationStatus(serviceReservation, RequestStatus.finished);
          Get.back();
          init();
          MainAppController.find.resolveProfileActionRequired();
        },
      );
}
