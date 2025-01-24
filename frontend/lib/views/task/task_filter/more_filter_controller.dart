import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helper.dart';
import '../../../models/category.dart';
import '../../../models/filter_model.dart';
import '../../../repositories/params_repository.dart';
import '../../../services/authentication_service.dart';
import '../../profile/account/login_dialog.dart';

class MoreFilterController extends GetxController {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  Category _category = anyCategory;
  RxDouble nearbyRange = 10.0.obs;
  FilterModel? filter;
  double maxPrice = kMaxPriceRange;
  RxBool isLoading = false.obs;

  Category get category => _category;

  set category(Category value) {
    _category = value;
    update();
  }

  static final MoreFilterController _singleton = MoreFilterController._internal();


  factory MoreFilterController() => _singleton;

  MoreFilterController._internal() {
    filter = FilterModel();
  }

  Future<void> init(FilterModel filter, bool isTasks) async {
    maxPrice = (isTasks ? await ParamsRepository.find.getMaxTaskPrice() : await ParamsRepository.find.getMaxServicePrice()) ?? kMaxPriceRange;
    minPriceController.text = filter.minPrice?.toStringAsFixed(0) ?? '';
    maxPriceController.text = filter.maxPrice?.toStringAsFixed(0) ?? '';
    _category = filter.category ?? anyCategory;
    nearbyRange.value = filter.nearby ?? 1.0;
    update();
  }

  void managePriceFilter({RangeValues? range, String? min, String? max}) {
    if (range != null) {
      minPriceController.text = range.start.toStringAsFixed(0);
      maxPriceController.text = range.end.toStringAsFixed(0);
    }
    if (min != null) {
      final minDouble = double.tryParse(min);
      if (minDouble != null && minDouble < (double.tryParse(maxPriceController.text) ?? 99999)) minPriceController.text = minDouble.toStringAsFixed(0);
    }
    if (max != null) {
      final maxDouble = double.tryParse(max);
      if (maxDouble != null && maxDouble > (double.tryParse(minPriceController.text) ?? 0)) maxPriceController.text = maxDouble.toStringAsFixed(0);
    }
    if (double.tryParse(minPriceController.text) != null &&
        double.tryParse(maxPriceController.text) != null &&
        double.tryParse(minPriceController.text)! > double.tryParse(maxPriceController.text)!) {
      final min = minPriceController.text;
      minPriceController.text = double.tryParse(maxPriceController.text)?.toStringAsFixed(0) ?? '';
      maxPriceController.text = double.tryParse(min)?.toStringAsFixed(0) ?? '';
    }
    update();
  }

  void clearFilter() {
    category = anyCategory;
    minPriceController.clear();
    maxPriceController.clear();
    nearbyRange.value = 1.0;
  }

  FilterModel getFilterModel() => FilterModel(
        category: category,
        minPrice: double.tryParse(minPriceController.text),
        maxPrice: double.tryParse(maxPriceController.text),
        nearby: nearbyRange.value,
      );

  Future<void> shareLocation() async {
    if (AuthenticationService.find.isLoggedIn) {
      await AuthenticationService.find.getUserCoordinates(withSave: true);
      update();
    } else {
      Helper.snackBar(
        message: 'login_express_interest_msg'.tr,
        overrideButton: TextButton(
          onPressed: () => Get.bottomSheet(const LoginDialog(), isScrollControlled: true).then((value) {
            AuthenticationService.find.currentState = LoginWidgetState.login;
            AuthenticationService.find.clearFormFields();
          }),
          child: Text('login'.tr),
        ),
      );
    }
  }
}
