import 'package:drift/drift.dart';

import '../database/database.dart';
import '../networking/api_base_helper.dart';

class Category {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int parentId;
  final int subscribed;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.parentId = 0,
    this.subscribed = 0,
  });
  Category.empty({
    this.id = -1,
    this.name = '',
    this.description = '',
    this.icon = '',
    this.parentId = 0,
    this.subscribed = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        parentId: json['parentId'],
        icon: json['icon'] != null ? ApiBaseHelper.find.getCategoryImage(json['icon']) : 'NA',
        name: json['name'],
        description: json['description'],
        subscribed: json['subscribed'] ?? 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['icon'] = icon;
    data['parentId'] = parentId;
    return data;
  }

  factory Category.fromCategoryData({required CategoryTableData category}) => Category(
        id: category.id,
        name: category.name,
        description: category.description,
        icon: category.icon.toString(),
        parentId: category.parent,
        subscribed: category.subscribed,
      );

  bool get empty => id == -1 && name.isEmpty && description.isEmpty && icon.isEmpty;

  CategoryTableCompanion toCategoryCompanion() => CategoryTableCompanion(
        id: Value(id),
        name: Value(name),
        description: Value(description),
        icon: Value(icon),
        parent: Value(parentId),
        subscribed: Value(subscribed),
      );
}
