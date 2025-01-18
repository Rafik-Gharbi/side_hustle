import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/service_dto.dart';
import '../../../models/filter_model.dart';
import '../../../models/service.dart';
import '../../../models/store.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/store_repository.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/tutorials/market_tutorial.dart';

class MarketController extends GetxController {
  /// not permanent, use with caution
  static MarketController get find => Get.find<MarketController>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchStoreController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  List<Store> storeList = [];
  List<Store> filteredStoreList = [];
  RxBool openSearchBar = false.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = true.obs;
  FilterModel _filterModel = FilterModel();
  bool isEndList = false;
  int page = 0;
  List<Service> hotServices = [];
  List<ServiceDTO> _hotServicesDTO = [];
  List<TargetFocus> targets = [];
  GlobalKey searchIconKey = GlobalKey();
  GlobalKey advancedFilterKey = GlobalKey();
  GlobalKey firstStoreKey = GlobalKey();

  FilterModel get filterModel => _filterModel;

  set filterModel(FilterModel value) {
    _filterModel = value;
    page = 0;
    isEndList = false;
    fetchSearchedStores(filter: _filterModel);
  }

  MarketController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedMarketTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => MainAppController.find.isMarketScreen, () {
          MarketTutorial.showTutorial();
          update();
        });
      }
    });
    init();
  }

  Store getServiceStore(Service service) => _hotServicesDTO.singleWhere((element) => element.service?.id == service.id).store!;

  Future<void> fetchSearchedStores({FilterModel? filter, String? searchQuery, int? fixPage}) async {
    if (fixPage != null) page = fixPage;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      openSearchBar.value = true;
      searchStoreController.text = searchQuery;
    }
    if (filter != null) _filterModel = filter;
    if (page > 1) isLoadingMore.value = true;
    storeList = await StoreRepository.find.filterStores(page: fixPage ?? ++page, searchQuery: searchStoreController.text, filter: _filterModel) ?? [];
    if ((storeList.isEmpty) || storeList.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      filteredStoreList = storeList;
      isLoading.value = false;
    } else {
      filteredStoreList.addAll(storeList);
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    fetchSearchedStores().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }

  Future<void> init() async {
    searchStoreController.text = '';
    final result = await StoreRepository.find.getHotServices();
    _hotServicesDTO = result;
    hotServices = result.where((element) => element.service != null).map((e) => e.service!).toList();
    fetchSearchedStores(fixPage: 1);
    openSearchBar.value = false;
    update();
  }

  void clearRequestFormFields() {
    noteController.clear();
  }
}
