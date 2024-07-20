import 'category.dart';

class FilterModel {
  final Category? category;
  final double? minPrice;
  final double? maxPrice;
  final double? nearby;

  FilterModel({this.category, this.minPrice, this.maxPrice, this.nearby});

  bool get isNotEmpty => category != null || minPrice != null || maxPrice != null || nearby != null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['categoryId'] = category?.id;
    data['minPrice'] = minPrice;
    data['maxPrice'] = maxPrice;
    data['nearby'] = nearby;
    return data;
  }

  @override
  String toString() => 'FilterModel(category: ${category?.name}, minPrice: $minPrice, maxPrice: $maxPrice, nearby: $nearby)';
}
