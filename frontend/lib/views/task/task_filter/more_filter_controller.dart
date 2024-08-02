import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../models/category.dart';
import '../../../models/filter_model.dart';

class MoreFilterController extends GetxController {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  Category _category = Category(id: -1, name: 'any'.tr, icon: Icons.all_inclusive_outlined);
  RxDouble nearbyRange = 10.0.obs;
  FilterModel filter;

  Category get category => _category;

  set category(Category value) {
    _category = value;
    update();
  }

  MoreFilterController({required this.filter}) {
    init(filter);
  }

  void init(FilterModel filter) {
    // TODO get max task price from backend
    minPriceController.text = filter.minPrice?.toStringAsFixed(0) ?? '';
    maxPriceController.text = filter.maxPrice?.toStringAsFixed(0) ?? '';
    _category = filter.category ?? Category(id: -1, name: 'any'.tr, icon: Icons.all_inclusive_outlined);
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
    update();
  }

  void clearFiler() {
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
}
