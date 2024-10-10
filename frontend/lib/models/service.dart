import 'package:drift/drift.dart';

import '../controllers/main_app_controller.dart';
import '../database/database.dart';
import 'category.dart';
import 'dto/image_dto.dart';

class Service {
  final String? id;
  final String? name;
  final String? description;
  final List<ImageDTO>? gallery;
  final Category? category;
  final double? price;
  final double? timeEstimationFrom;
  final double? timeEstimationTo;
  final String? included;
  final String? notIncluded;
  final String? notes;
  final int requests;

  Service({
    this.id,
    this.name,
    this.description,
    this.category,
    this.gallery,
    this.price,
    this.requests = 0,
    this.timeEstimationFrom,
    this.timeEstimationTo,
    this.included,
    this.notIncluded,
    this.notes,
  });

  factory Service.fromJson(Map<String, dynamic> json, {dynamic gallery}) => Service(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        gallery: json['gallery'] != null || gallery != null ? ((gallery ?? json['gallery']) as List).map((e) => ImageDTO.fromJson(e, isStoreImage: true)).toList() : null,
        category:
            json['category_id'] != null ? MainAppController.find.getCategoryById(json['category_id'] is String ? int.tryParse(json['category_id']) : json['category_id']) : null,
        price: json['price'] is int ? (json['price'] as int).toDouble() : double.tryParse((json['price']).toString()),
        requests: json['requests'] ?? 0,
        timeEstimationFrom:
            json['timeEstimationFrom'] == null ? null : double.tryParse(json['timeEstimationFrom'] is int ? json['timeEstimationFrom'].toString() : json['timeEstimationFrom']),
        timeEstimationTo:
            json['timeEstimationTo'] == null ? null : double.tryParse(json['timeEstimationTo'] is int ? json['timeEstimationTo'].toString() : json['timeEstimationTo']),
        included: json['included'],
        notIncluded: json['notIncluded'],
        notes: json['notes'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['category_id'] = category?.id;
    data['gallery'] = gallery?.map((e) => e.toJson()).toList();
    data['price'] = price;
    data['timeEstimationFrom'] = timeEstimationFrom;
    data['timeEstimationTo'] = timeEstimationTo;
    data['included'] = included;
    data['notIncluded'] = notIncluded;
    data['notes'] = notes;
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
