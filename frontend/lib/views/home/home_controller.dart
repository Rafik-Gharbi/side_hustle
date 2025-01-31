import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/helper.dart';
import '../../models/category.dart';
import '../../models/filter_model.dart';
import '../../models/governorate.dart';
import '../../models/reservation.dart';
import '../../models/task.dart';
import '../../networking/api_base_helper.dart';
import '../../repositories/task_repository.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';
import '../../services/tutorials/home_tutorial.dart';
import '../../widgets/main_screen_with_bottom_navigation.dart';
import '../task/task_list/task_list_screen.dart';

enum SearchMode { nearby, regional, national, worldwide }

class HomeController extends GetxController {
  static HomeController get find => Get.find<HomeController>();
  List<Category> mostPopularCategories = [];
  List<Task> hotTasks = [];
  List<Task> nearbyTasks = [];
  List<Task> governorateTasks = [];
  List<Reservation> taskReservations = [];
  List<Reservation> ongoingTaskReservations = [];
  List<Reservation> serviceReservations = [];
  List<Reservation> ongoingServiceReservations = [];
  TextEditingController searchController = TextEditingController();
  FilterModel _filterModel = FilterModel();
  RxBool isLoading = true.obs;
  List<TargetFocus> targets = [];
  GlobalKey categoryRowKey = GlobalKey();
  GlobalKey searchFieldKey = GlobalKey();
  GlobalKey advancedFilterKey = GlobalKey();
  GlobalKey firstTaskKey = GlobalKey();
  GlobalKey mapViewKey = GlobalKey();
  GlobalKey searchModeDropdownKey = GlobalKey();

  FilterModel get filterModel => _filterModel;

  Governorate? get selectedGovernorate => _filterModel.governorate;

  SearchMode? get searchMode => _filterModel.searchMode;

  set searchMode(SearchMode? value) {
    _filterModel.searchMode = value;
    switch (_filterModel.searchMode) {
      case SearchMode.national:
        _filterModel.governorate = MainAppController.find.getGovernorateById(1);
        SharedPreferencesService.find.add(governorateKey, _filterModel.governorate!.id.toString());
        break;
      case SearchMode.regional:
        Governorate? savedGovernorate = MainAppController.find.getGovernorateById(int.tryParse(SharedPreferencesService.find.get(governorateKey) ?? ''));
        if (savedGovernorate?.id == 1) savedGovernorate = null;
        _filterModel.governorate = savedGovernorate ?? AuthenticationService.find.jwtUserData?.governorate;
        if (_filterModel.governorate != null) {
          SharedPreferencesService.find.add(governorateKey, _filterModel.governorate!.id.toString());
        }
        break;
      default:
    }
    SharedPreferencesService.find.add(searchModeKey, value!.name);
    fetchHomeTasks();
  }

  set selectedGovernorate(Governorate? value) {
    _filterModel.governorate = value;
    if (_filterModel.governorate?.id == 1) {
      _filterModel.searchMode = SearchMode.national;
      SharedPreferencesService.find.add(searchModeKey, _filterModel.searchMode!.name);
    } else if (_filterModel.searchMode != SearchMode.regional) {
      _filterModel.searchMode = SearchMode.regional;
      SharedPreferencesService.find.add(searchModeKey, _filterModel.searchMode!.name);
    }
    SharedPreferencesService.find.add(governorateKey, value!.id.toString());
    fetchHomeTasks();
  }

  set filterModel(FilterModel value) {
    _filterModel = value;
    if (_filterModel.isNotEmpty) searchTask();
  }

  static final HomeController _singleton = HomeController._internal();

  factory HomeController() => _singleton;

  HomeController._internal() {
    init();
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedHomeTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => MainAppController.find.isHomeScreen && Get.currentRoute == MainScreenWithBottomNavigation.routeName, () {
          HomeTutorial.showTutorial();
          update();
        });
      }
    });
  }

  Future<void> init() async {
    Helper.waitAndExecute(() => MainAppController.find.isReady, () async {
      // TODO adapt user preferences if selected most searched categories and fix this below by getting true popular categories from BE
      mostPopularCategories = MainAppController.find.categories.where((element) => element.parentId == -1).toList().getRange(10, 14).toList();
      final savedGovernorate = MainAppController.find.getGovernorateById(int.tryParse(SharedPreferencesService.find.get(governorateKey) ?? ''));
      final savedSearchMode = SearchMode.values.cast<SearchMode?>().singleWhere((element) => element?.name == SharedPreferencesService.find.get(searchModeKey), orElse: () => null);
      _filterModel.governorate = savedGovernorate ?? AuthenticationService.find.jwtUserData?.governorate;
      _filterModel.searchMode = savedSearchMode ??
          (AuthenticationService.find.jwtUserData?.coordinates != null
              ? SearchMode.nearby
              : AuthenticationService.find.jwtUserData?.governorate != null
                  ? SearchMode.regional
                  : SearchMode.national);
      await fetchHomeTasks();
      MainAppController.find.getNotSeenNotifications();
      isLoading.value = false;
      update();
    });
  }

  Future<void> fetchHomeTasks() async {
    final (result, categories) = await TaskRepository.find.getHomeTasks(governorateId: _filterModel.governorate?.id, searchMode: _filterModel.searchMode!.name);
    hotTasks = result?['hotTasks'] != null ? (result?['hotTasks'] as List).map((e) => e as Task).toList() : [];
    nearbyTasks = result?['nearbyTasks'] != null ? (result?['nearbyTasks'] as List).map((e) => e as Task).toList() : [];
    governorateTasks = result?['governorateTasks'] != null ? (result?['governorateTasks'] as List).map((e) => e as Task).toList() : [];
    taskReservations = result?['reservation'] != null ? (result?['reservation'] as List).map((e) => e as Reservation).toList() : [];
    ongoingTaskReservations = result?['ongoingReservation'] != null ? (result?['ongoingReservation'] as List).map((e) => e as Reservation).toList() : [];
    serviceReservations = result?['booking'] != null ? (result?['booking'] as List).map((e) => e as Reservation).toList() : [];
    ongoingServiceReservations = result?['ongoingBooking'] != null ? (result?['ongoingBooking'] as List).map((e) => e as Reservation).toList() : [];
    if (categories != null && categories.isNotEmpty) {
      final categoryLength = categories.length;
      mostPopularCategories = categoryLength == 4
          ? categories
          : [
              ...categories,
              ...MainAppController.find.categories
                  .where((element) => element.parentId == -1 && !categories.any((exist) => exist.id == element.id))
                  .toList()
                  .take(4 - categoryLength)
            ];
    } else {
      mostPopularCategories = MainAppController.find.categories.where((element) => element.parentId == -1).toList().getRange(10, 14).toList();
    }
    update();
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
    final (isBEConnected, version) = await ApiBaseHelper.find.checkConnectionToBackend();
    MainAppController.find.isBackReachable.value = isBEConnected;
    if (version != null) {
      final currentVersion = await Helper.getCurrentVersion();
      MainAppController.find.hasVersionUpdate.value = version != currentVersion;
    } else {
      Helper.snackBar(message: 'Couldn\'t check version update');
    }
    init();
  }
}
