import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/main_app_controller.dart';
import '../database/database.dart';
import '../helpers/extensions/date_time_extension.dart';
import '../helpers/extensions/lat_lon_extension.dart';
import '../helpers/helper.dart';
import 'category.dart';
import 'dto/image_dto.dart';
import 'governorate.dart';
import 'user.dart';

class Task {
  final int? id;
  final String title;
  final String description;
  final Category? category;
  final Governorate? governorate;
  final double? price;
  final String? delivrables;
  final User owner;
  final DateTime? dueDate;
  final LatLng? coordinates;
  final String? distance;
  List<ImageDTO>? attachments;
  bool isFavorite;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.governorate,
    required this.owner,
    this.id,
    this.price,
    this.delivrables,
    this.dueDate,
    this.attachments,
    this.coordinates,
    this.distance,
    this.isFavorite = false,
  });

  factory Task.fromJson(Map<String, dynamic> json, {dynamic attachments}) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        category: MainAppController.find.getCategoryById(json['category_id']),
        governorate: MainAppController.find.getGovernorateById(json['governorate_id']),
        owner: User.fromJson(json['owner']),
        price: json['price'] is int
            ? (json['price'] as int).toDouble()
            : json['price'] is String
                ? double.parse(json['price'])
                : json['price'],
        delivrables: json['delivrables'],
        coordinates: json['coordinates'] != null ? (json['coordinates'] as String).fromString() : null,
        distance: json['distance'] != null ? Helper.degreesToMeters(json['distance']).toStringAsFixed(1) : null,
        attachments: json['attachments'] != null && (json['attachments'] as List).isNotEmpty
            ? (json['attachments'] as List).map((e) => ImageDTO.fromJson(e)).toList()
            : attachments != null
                ? (attachments as List).map((e) => ImageDTO.fromJson(e)).toList()
                : null,
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now().toOneMinuteBeforeMidnight(),
        isFavorite: json['isFavorite'] ?? false,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['category_id'] = category?.id;
    data['governorate_id'] = governorate?.id;
    data['delivrables'] = delivrables;
    data['coordinates'] = coordinates?.toCoordinatesString();
    data['dueDate'] = dueDate?.toOneMinuteBeforeMidnight().toIso8601String();
    data['owner_id'] = owner.id;
    // data['attachments'] = attachments;
    return data;
  }

  TaskTableCompanion toTaskCompanion({bool? isFavoriteUpdate}) => TaskTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        price: price == null ? const Value.absent() : Value(price!),
        category: category?.id == null ? const Value.absent() : Value(category!.id),
        governorate: governorate?.id == null ? const Value.absent() : Value(governorate!.id),
        dueDate: dueDate == null ? const Value.absent() : Value(dueDate!),
        owner: Value(owner.id!),
        title: Value(title),
        description: Value(description),
        delivrables: Value(delivrables ?? ''),
        isfavorite: Value(isFavoriteUpdate ?? isFavorite),
      );

  factory Task.fromTaskData({required TaskTableCompanion task, required User owner, List<ImageDTO>? attachments}) => Task(
        id: task.id.value,
        title: task.title.value,
        description: task.description.value,
        delivrables: task.delivrables.value,
        dueDate: task.dueDate.value,
        price: task.price.value,
        isFavorite: task.isfavorite.value,
        category: MainAppController.find.getCategoryById(task.category.value),
        governorate: MainAppController.find.getGovernorateById(task.governorate.value),
        attachments: attachments,
        owner: owner,
      );
}
