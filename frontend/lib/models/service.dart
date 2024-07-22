import '../controllers/main_app_controller.dart';
import 'category.dart';
import 'dto/image_dto.dart';

class Service {
  final int? id;
  final String? name;
  final String? description;
  final List<ImageDTO>? gallery;
  final Category? category;
  final double? price;

  Service({
    this.id,
    this.name,
    this.description,
    this.category,
    this.gallery,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'] != null
            ? json['id'] is String
                ? int.tryParse(json['id'])
                : json['id']
            : null,
        name: json['name'],
        description: json['description'],
        gallery: json['gallery'] != null ? (json['gallery'] as List).map((e) => ImageDTO.fromJson(e, isStoreImage: true)).toList() : null,
        category:
            json['category_id'] != null ? MainAppController.find.getCategoryById(json['category_id'] is String ? int.tryParse(json['category_id']) : json['category_id']) : null,
        price: json['price'] is int ? (json['price'] as int).toDouble() : double.tryParse((json['price']).toString()),
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
}
