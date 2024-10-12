import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helper.dart';
import '../../../models/boost.dart';
import '../../../models/dto/boost_dto.dart';
import '../../../models/service.dart';
import '../../../models/task.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/boost_repository.dart';

class ListBoostController extends GetxController {
  final ScrollController scrollController = ScrollController();
  bool _isLoading = true;
  RxBool isLoadingMore = true.obs;
  bool isEndList = false;
  int page = 0;
  List<Boost> boostList = [];
  List<BoostDTO> _boostDTOList = [];
  List<bool> _expandedTiles = [];

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  ListBoostController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
    fetchUserBoosts();
  }

  Task getTask(Boost boost) => _boostDTOList.singleWhere((element) => element.boost.id == boost.id).task!;

  Service getService(Boost boost) => _boostDTOList.singleWhere((element) => element.boost.id == boost.id).service!;

  bool isExpanded(Boost boost) => _expandedTiles.elementAt(boostList.indexOf(boost));

  void expandTile(Boost boost) {
    int elementIndex = boostList.indexOf(boost);
    _expandedTiles[elementIndex] = !_expandedTiles[elementIndex];
    update();
  }

  Future<void> toggleBoostActive(Boost boost) async {
    final selected = boostList.singleWhere((element) => element.id == boost.id);
    selected.isActive = !selected.isActive;
    final result = await BoostRepository.find.updateBoost(boost: boost);
    if (result) {
      Helper.snackBar(message: 'boost_status_successfully'.trParams({'status': selected.isActive ? 'activated' : 'disabled'}));
    } else {
      Helper.snackBar(message: 'error_occurred'.tr);
      page = 0;
      fetchUserBoosts();
    }
    update();
  }

  Future<void> fetchUserBoosts() async {
    if (page > 1) {
      isLoadingMore.value = true;
    } else {
      isLoading = true;
    }
    final result = await BoostRepository.find.getUserBoosts(page: ++page);
    if ((boostList.isEmpty) || boostList.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      _boostDTOList = result;
      boostList = result.map((e) => e.boost).toList();
      isLoading = false;
    } else {
      _boostDTOList.addAll(result);
      boostList.addAll(result.map((e) => e.boost).toList());
      isLoadingMore.value = false;
    }
    _expandedTiles = [for (int i = 0; i < boostList.length; i++) false];
    update();
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    fetchUserBoosts().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }
}
