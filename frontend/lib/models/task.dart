import '../controllers/main_app_controller.dart';
import '../helpers/extensions/date_time_extension.dart';
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
    this.isFavorite = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
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
        attachments: json['attachments'] != null && (json['attachments'] as List).isNotEmpty ? (json['attachments'] as List).map((e) => ImageDTO.fromJson(e)).toList() : null,
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
    data['dueDate'] = dueDate?.toIso8601String();
    data['owner_id'] = owner.id;
    // data['attachments'] = attachments;
    return data;
  }
}
