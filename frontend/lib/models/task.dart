import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/main_app_controller.dart';
import '../database/database.dart';
import '../helpers/extensions/date_time_extension.dart';
import '../helpers/extensions/lat_lon_extension.dart';
import '../helpers/helper.dart';
import '../networking/api_base_helper.dart';
import 'category.dart';
import 'dto/image_dto.dart';
import 'governorate.dart';
import 'user.dart';

class Task {
  String? id;
  String title;
  String description;
  Category? category;
  Governorate? governorate;
  double? price;
  double? priceMax;
  String? delivrables;
  User owner;
  DateTime? dueDate;
  DateTime? createdAt;
  LatLng? coordinates;
  String? distance;
  int coins;
  int deductedCoins;
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
    this.priceMax,
    this.delivrables,
    this.dueDate,
    this.attachments,
    this.coordinates,
    this.distance,
    this.createdAt,
    this.isFavorite = false,
    this.coins = 0,
    this.deductedCoins = 0,
  });

  factory Task.fromJson(Map<String, dynamic> json, {dynamic attachments}) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        category: MainAppController.find.getCategoryById(json['category_id']),
        governorate: MainAppController.find.getGovernorateById(json['governorate_id']),
        owner: User.fromJson(json['owner'] ?? json['user']),
        price: Helper.resolveDouble(json['price']),
        priceMax: json['priceMax'] != null ? Helper.resolveDouble(json['priceMax']) : null,
        delivrables: json['delivrables'],
        coordinates: json['coordinates'] != null ? (json['coordinates'] as String).fromString() : null,
        distance: json['distance'] != null ? Helper.metersToKilometers(json['distance']).toStringAsFixed(1) : null,
        attachments: json['attachments'] != null && (json['attachments'] as List).isNotEmpty
            ? (json['attachments'] as List).map((e) => ImageDTO.fromJson(e, path: ApiBaseHelper.find.getImageTask(e['url']))).toList()
            : attachments != null
                ? (attachments as List).map((e) => ImageDTO.fromJson(e, path: ApiBaseHelper.find.getImageTask(e['url']))).toList()
                : null,
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now().toOneMinuteBeforeMidnight(),
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        isFavorite: json['isFavorite'] ?? false,
        coins: json['coins'] ?? 0,
        deductedCoins: json['deducted_coins'] ?? 0,
      );

  Map<String, dynamic> toJson({bool includeOwner = false}) {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['priceMax'] = priceMax;
    data['category_id'] = category?.id;
    data['governorate_id'] = governorate?.id;
    data['delivrables'] = delivrables;
    data['coordinates'] = coordinates?.toCoordinatesString();
    data['dueDate'] = dueDate?.toOneMinuteBeforeMidnight().toIso8601String();
    data['owner_id'] = owner.id;
    if (includeOwner) data['owner'] = owner.toJson();
    // data['attachments'] = attachments;
    return data;
  }

  TaskTableCompanion toTaskCompanion({bool? isFavoriteUpdate}) => TaskTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        price: price == null ? const Value.absent() : Value(price!),
        priceMax: priceMax == null ? const Value.absent() : Value(priceMax!),
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
        priceMax: task.priceMax.value,
        isFavorite: task.isfavorite.value,
        category: MainAppController.find.getCategoryById(task.category.value),
        governorate: MainAppController.find.getGovernorateById(task.governorate.value),
        attachments: attachments,
        owner: owner,
      );

  void updateFields(Task task) {
    title = task.title;
    description = task.description;
    category = task.category;
    governorate = task.governorate;
    price = task.price;
    delivrables = task.delivrables;
    owner = task.owner;
    dueDate = task.dueDate;
    coordinates = task.coordinates;
    distance = task.distance;
    coins = task.coins;
    deductedCoins = task.deductedCoins;
    attachments = task.attachments;
    isFavorite = task.isFavorite;
  }
}
