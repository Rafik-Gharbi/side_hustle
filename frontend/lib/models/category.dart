import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';
import '../helpers/extensions/icondata_convert_extension.dart';

class Category {
  final int id;
  final String name;
  final IconData icon;
  final int parentId;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.parentId = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        parentId: json['parentId'],
        icon: (json['icon'] as String).getIconData(),
        name: json['name'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon.codePoint;
    data['parentId'] = parentId;
    return data;
  }

  factory Category.fromCategoryData({required CategoryTableData category}) => Category(
        id: category.id,
        name: category.name,
        icon: category.icon.toString().getIconData(),
      );

  CategoryTableCompanion toCategoryCompanion() => CategoryTableCompanion(
        id: Value(id),
        name: Value(name),
        icon: Value(icon.codePoint),
  );
}
