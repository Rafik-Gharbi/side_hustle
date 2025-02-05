import 'package:drift/drift.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/main_app_controller.dart';
import '../database/database.dart';
import '../helpers/extensions/lat_lon_extension.dart';
import '../helpers/helper.dart';
import '../networking/api_base_helper.dart';
import 'dto/image_dto.dart';
import 'governorate.dart';
import 'service.dart';
import 'user.dart';

class Store {
  final int? id;
  final String? name;
  final String? description;
  final ImageDTO? picture;
  final Governorate? governorate;
  final LatLng? coordinates;
  final User? owner;
  List<Service>? services;
  bool isFavorite;
  double rating;

  Store({
    this.id,
    this.name,
    this.description,
    this.picture,
    this.governorate,
    this.coordinates,
    this.services,
    this.owner,
    this.isFavorite = false,
    this.rating = 0,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        coordinates: json['coordinates'] != null ? (json['coordinates'] as String).fromString() : null,
        picture: json['picture'] != null ? ImageDTO(file: XFile(ApiBaseHelper.find.getImageStore(json['picture'])), type: ImageType.image) : null,
        governorate: json['governorate_id'] != null
            ? MainAppController.find.getGovernorateById(json['governorate_id'] is String ? int.parse(json['governorate_id']) : json['governorate_id'])
            : null,
        services: json['services'] != null ? (json['services'] as List).map((e) => Service.fromJson(e)).toList() : [],
        owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
        isFavorite: json['isFavorite'] ?? false,
        rating: Helper.resolveDouble(json['rating']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['picture'] = picture;
    data['coordinates'] = coordinates?.toCoordinatesString();
    data['governorate_id'] = governorate?.id;
    data['owner_id'] = owner?.id;
    data['services'] = services?.map((e) => e.toJson()).toList();
    return data;
  }

  StoreTableCompanion toStoreCompanion({bool? isFavoriteUpdate}) => StoreTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        governorate: governorate?.id == null ? const Value.absent() : Value(governorate!.id),
        owner: owner?.id == null ? const Value.absent() : Value(owner!.id),
        name: Value(name ?? ''),
        description: Value(description ?? ''),
        picture: picture == null ? const Value.absent() : Value(picture!.file.path),
        coordinates: coordinates == null ? const Value.absent() : Value(coordinates!.toCoordinatesString()),
      );

  factory Store.fromStoreData({required StoreTableCompanion store, required User owner, List<Service>? services}) => Store(
        id: store.id.value,
        name: store.name.value,
        description: store.description.value,
        governorate: MainAppController.find.getGovernorateById(store.governorate.value),
        owner: owner,
        picture: ImageDTO(file: XFile(store.picture.value), type: ImageType.image),
        coordinates: store.coordinates.value.isNotEmpty ? store.coordinates.value.fromString() : null,
        services: services,
      );
}
