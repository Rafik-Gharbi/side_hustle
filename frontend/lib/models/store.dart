import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/extensions/lat_lon_extension.dart';
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

  Store({
    this.id,
    this.name,
    this.description,
    this.picture,
    this.governorate,
    this.coordinates,
    this.services,
    this.owner,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        coordinates: json['coordinates'] != null ? (json['coordinates'] as String).fromString() : null,
        picture: json['picture'] != null ? ImageDTO(file: XFile(ApiBaseHelper.find.getImageStore(json['picture'])), type: ImageType.image) : null,
        governorate: json['governorate_id'] != null ? MainAppController.find.getGovernorateById(json['governorate_id']) : null,
        services: json['services'] != null ? (json['services'] as List).map((e) => Service.fromJson(e)).toList() : [],
        owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['picture'] = picture;
    data['coordinates'] = coordinates;
    data['governorate_id'] = governorate?.id;
    data['owner_id'] = owner?.id;
    data['services'] = services?.map((e) => e.toJson()).toList();
    return data;
  }
}
