import 'package:drift/drift.dart';

import '../controllers/main_app_controller.dart';
import '../database/database.dart';
import 'category.dart';
import 'dto/image_dto.dart';

class Service {
  final int? id;
  final String? name;
  final String? description;
  final List<ImageDTO>? gallery;
  final Category? category;
  final double? price;
  final int requests;

  Service({
    this.id,
    this.name,
    this.description,
    this.category,
    this.gallery,
    this.price,
    this.requests = 0,
  });

  factory Service.fromJson(Map<String, dynamic> json, {dynamic gallery}) => Service(
        id: json['id'] != null
            ? json['id'] is String
                ? int.tryParse(json['id'])
                : json['id']
            : null,
        name: json['name'],
        description: json['description'],
        gallery: json['gallery'] != null || gallery != null ? ((gallery ?? json['gallery']) as List).map((e) => ImageDTO.fromJson(e, isStoreImage: true)).toList() : null,
        category:
            json['category_id'] != null ? MainAppController.find.getCategoryById(json['category_id'] is String ? int.tryParse(json['category_id']) : json['category_id']) : null,
        price: json['price'] is int ? (json['price'] as int).toDouble() : double.tryParse((json['price']).toString()),
        requests: json['requests'] ?? 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['category_id'] = category?.id;
    data['gallery'] = gallery?.map((e) => e.toJson()).toList();
    data['price'] = price;
    return data;
  }

  factory Service.fromServiceData({required ServiceTableCompanion service, required List<ImageDTO> gallery}) => Service(
        id: service.id.value,
        name: service.name.value,
        description: service.description.value,
        category: MainAppController.find.getCategoryById(service.category.value),
        gallery: gallery,
      );

  ServiceTableCompanion toServiceCompanion({required int storeId}) => ServiceTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        category: category?.id == null ? const Value.absent() : Value(category!.id),
        name: Value(name ?? ''),
        description: Value(description ?? ''),
        price: Value(price ?? 0),
        store: Value(storeId),
      );
}
