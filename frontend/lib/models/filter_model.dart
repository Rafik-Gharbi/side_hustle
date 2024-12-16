import '../views/home/home_controller.dart';
import 'category.dart';
import 'governorate.dart';

class FilterModel {
  Category? category;
  double? minPrice;
  double? maxPrice;
  double? nearby;
  Governorate? governorate;
  SearchMode? searchMode;

  FilterModel({this.governorate, this.searchMode, this.category, this.minPrice, this.maxPrice, this.nearby});

  bool get isNotEmpty => category != null || minPrice != null || maxPrice != null || nearby != null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if(category != null) data['categoryId'] = category!.id;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;
    if (nearby != null) data['nearby'] = nearby;
    if (governorate != null) data['governorateId'] = governorate!.id;
    if (searchMode != null) data['searchMode'] = searchMode!.name;
    return data;
  }

  @override
  String toString() => 'FilterModel(category: ${category?.name}, minPrice: $minPrice, maxPrice: $maxPrice, nearby: $nearby)';
}
