import 'package:flutter/material.dart';

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
}
