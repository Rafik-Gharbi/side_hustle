import 'package:drift/drift.dart';

import '../database/database.dart';

class Category {
  final int id;
  final String name;
  final String icon;
  final int parentId;
  final int subscribed;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.parentId = 0,
    this.subscribed = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        parentId: json['parentId'],
        icon: json['icon'],
        name: json['name'],
        subscribed: json['subscribed'] ?? 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['parentId'] = parentId;
    return data;
  }

  factory Category.fromCategoryData({required CategoryTableData category}) => Category(
        id: category.id,
        name: category.name,
        icon: category.icon.toString(),
        parentId: category.parent,
        subscribed: category.subscribed,
      );

  CategoryTableCompanion toCategoryCompanion() => CategoryTableCompanion(
        id: Value(id),
        name: Value(name),
        icon: Value(icon),
        parent: Value(parentId),
        subscribed: Value(subscribed),
      );
}
