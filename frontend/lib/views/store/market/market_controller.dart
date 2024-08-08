import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helper.dart';
import '../../../models/booking.dart';
import '../../../models/dto/service_dto.dart';
import '../../../models/filter_model.dart';
import '../../../models/service.dart';
import '../../../models/store.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/store_repository.dart';
import '../../../services/authentication_service.dart';

class MarketController extends GetxController {
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
    _init();
  }

  Store getServiceStore(Service service) => _hotServicesDTO.singleWhere((element) => element.service?.id == service.id).store!;

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

  Future<void> _init() async {
    final result = await StoreRepository.find.getHotServices();
    _hotServicesDTO = result;
    hotServices = result.where((element) => element.service != null).map((e) => e.service!).toList();
    update();
  }

  Future<void> bookService(Service service) async {
    final result = await BookingRepository.find.addBooking(
      booking: Booking(
        service: service,
        date: DateTime.now(),
        totalPrice: service.price ?? 0,
        user: AuthenticationService.find.jwtUserData!,
        note: noteController.text,
        // coupon: coupon,
      ),
    );
    if (result) {
      Get.back();
      Helper.snackBar(message: 'Service has been booked successfully');
    }
  }

  void clearRequestFormFields() {
    noteController.clear();
  }
}
