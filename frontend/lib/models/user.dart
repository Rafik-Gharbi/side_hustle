import 'package:latlong2/latlong.dart';

import '../controllers/main_app_controller.dart';
import '../helpers/extensions/role_extension.dart';
import '../networking/api_base_helper.dart';
import 'governorate.dart';

enum Role { admin, seeker, provider }

enum VerifyIdentityStatus {
  none,
  pending,
  verified;

  factory VerifyIdentityStatus.fromString(String value) => VerifyIdentityStatus.values.singleWhere((element) => element.name == value);
}

enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  final String value;

  const Gender(this.value);

  factory Gender.fromString(String value) => Gender.values.singleWhere((element) => element.value.toLowerCase() == value.toLowerCase());
}

class User {
  int? id;
  String? email;
  String? name;
  String? password;
  DateTime? birthdate;
  String? phone;
  String? facebookId;
  String? googleId;
  List<Role>? roles;
  String? picture;
  Governorate? governorate;
  String? bio;
  LatLng? coordinates;
  Gender? gender;
  VerifyIdentityStatus isVerified;
  bool? isMailVerified;

  User({
    this.id,
    this.email,
    this.name,
    this.birthdate,
    this.gender,
    this.phone,
    this.governorate,
    this.password,
    this.facebookId,
    this.googleId,
    this.bio,
    this.coordinates,
    this.roles,
    this.picture,
    this.isMailVerified,
    this.isVerified = VerifyIdentityStatus.none,
  });

  factory User.fromToken(Map<String, dynamic> payload) => User(
        id: payload['id'],
        name: payload['name'],
        isMailVerified: payload['isMailVerified'],
        isVerified: VerifyIdentityStatus.fromString(payload['isVerified']),
        roles: User.parseRoles(payload['role']), // Parse roles from string
        picture: payload['picture'] != null ? ApiBaseHelper().getUserImage(payload['picture']) : null,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        phone: json['phone_number'],
        password: json['password'],
        coordinates: json['coordinates'],
        birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
        gender: json['gender'] != null ? Gender.fromString(json['gender']) : null,
        roles: json['role'] != null ? User.parseRoles(json['role']) : null,
        picture: json['picture'] != null ? ApiBaseHelper().getUserImage(json['picture']) : null,
        facebookId: json['facebookId'],
        googleId: json['googleId'],
        governorate: json['governorate_id'] != null ? MainAppController.find.getGovernorateById(json['governorate_id']) : null,
        bio: json['bio'],
        isMailVerified: json['isMailVerified'],
        isVerified: json['isVerified'] != null ? VerifyIdentityStatus.fromString(json['isVerified']) : VerifyIdentityStatus.none,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email?.toLowerCase();
    data['name'] = name;
    data['phoneNumber'] = phone;
    data['password'] = password;
    data['coordinates'] = coordinates;
    data['birthdate'] = birthdate?.toIso8601String();
    data['gender'] = gender?.value.toLowerCase();
    data['role'] = roles?.map((role) => role.value).toList();
    data['picture'] = picture;
    data['facebookId'] = facebookId;
    data['googleId'] = googleId;
    data['governorate'] = governorate?.id;
    data['bio'] = bio;
    data['isMailVerified'] = isMailVerified;
    data['isVerified'] = isVerified.name;
    return data;
  }

  Map<String, dynamic> toLoginJson() {
    final Map<String, dynamic> data = {};
    if (email != null) data['email'] = email;
    if (phone != null) data['phoneNumber'] = phone;
    data['password'] = password;
    return data;
  }

  static List<Role> parseRoles(String rolesString) {
    final rolesList = rolesString.replaceAll('[', '').replaceAll(']', '').split(',');
    return rolesList.map((role) => RoleExtension.fromString(role.trim())).whereType<Role>().toList();
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['governorate'] = governorate?.id;
    data['birthdate'] = birthdate?.toIso8601String();
    data['gender'] = gender?.value.toLowerCase();
    data['bio'] = bio;
    return data;
  }

  Map<String, dynamic> toSocialJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['email'] = email;
    data['facebookId'] = facebookId;
    data['googleId'] = googleId;
    return data;
  }
}
