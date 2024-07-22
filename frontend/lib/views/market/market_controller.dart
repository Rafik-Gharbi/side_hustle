import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../models/filter_model.dart';
import '../../models/store.dart';
import '../../networking/api_base_helper.dart';
import '../../repositories/store_repository.dart';

class MarketController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchStoreController = TextEditingController();
  List<Store> storeList = [];
  List<Store> filteredStoreList = [];
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
    fetchSearchedStores(filter: _filterModel);
  }

  MarketController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
  }

  Future<void> getAllStores() async {
    storeList = await StoreRepository.find.filterStores(page: ++page) ?? [];
    filteredStoreList = List.of(storeList);
    isLoading = false;
    update();
  }

  Future<void> fetchSearchedStores({FilterModel? filter, String? searchQuery}) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      openSearchBar.value = true;
      searchStoreController.text = searchQuery;
    }
    if (filter != null) _filterModel = filter;
    if (page > 1) isLoadingMore.value = true;
    storeList = await StoreRepository.find.filterStores(page: ++page, searchQuery: searchStoreController.text, filter: _filterModel) ?? [];
    if ((storeList.isEmpty) || storeList.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      filteredStoreList = storeList;
      isLoading = false;
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

  double getStoreCheapestService(Store store) {
    double cheapestService = 9999;
    for (var element in store.services!) {
      if ((element.price ?? 0) < cheapestService) cheapestService = element.price ?? 0;
    }
    return cheapestService;
  }
}
