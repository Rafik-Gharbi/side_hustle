import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/main_app_controller.dart';
import '../database/database.dart';
import '../helpers/extensions/lat_lon_extension.dart';
import '../helpers/helper.dart';
import '../networking/api_base_helper.dart';
import 'governorate.dart';

enum Role { admin, user, subscribed, trial }

enum VerifyIdentityStatus {
  none,
  pending,
  verified;

  factory VerifyIdentityStatus.fromString(String value) => VerifyIdentityStatus.values.singleWhere((element) => element.name == value);
}

enum Gender {
  male('male'),
  female('female'),
  other('other');

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
  Role? role;
  String? picture;
  Governorate? governorate;
  String? bio;
  String? referralCode;
  LatLng? coordinates;
  bool hasSharedPosition;
  Gender? gender;
  VerifyIdentityStatus isVerified;
  bool? isMailVerified;
  double rating;
  int baseCoins;
  int availableCoins;
  int availablePurchasedCoins;
  double balance;
  String? bankNumber;
  DateTime? createdAt;
  String? language;

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
    this.referralCode,
    this.coordinates,
    this.role,
    this.picture,
    this.isMailVerified,
    this.hasSharedPosition = false,
    this.isVerified = VerifyIdentityStatus.none,
    this.rating = 0,
    this.balance = 0,
    this.bankNumber,
    this.baseCoins = 0,
    this.availableCoins = 0,
    this.availablePurchasedCoins = 0,
    this.createdAt,
    this.language,
  });

  int get totalCoins => availableCoins + availablePurchasedCoins;
  bool get isProfileCompleted => email != null && name != null && phone != null && birthdate != null && (isMailVerified ?? false) && governorate != null;

  factory User.fromToken(Map<String, dynamic> payload) => User(
        id: payload['id'],
        name: payload['name'],
        language: payload['language'],
        balance: Helper.resolveDouble(payload['balance'] ?? '0'),
        baseCoins: payload['coins'],
        availableCoins: payload['availableCoins'],
        availablePurchasedCoins: payload['availablePurchasedCoins'],
        hasSharedPosition: payload['hasSharedPosition'],
        referralCode: payload['referral_code'],
        isMailVerified: payload['isMailVerified'],
        isVerified: VerifyIdentityStatus.fromString(payload['isVerified']),
        role: Role.values.singleWhere((element) => element.name == payload['role']), // Parse roles from string
        picture: payload['picture'] != null ? ApiBaseHelper().getUserImage(payload['picture']) : null,
        governorate: payload['governorate_id'] != null ? MainAppController.find.getGovernorateById(payload['governorate_id']) : null,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        language: json['language'],
        phone: json['phone_number'],
        password: json['password'],
        coordinates: json['coordinates'] != null ? (json['coordinates'] as String).fromString() : null,
        hasSharedPosition: json['hasSharedPosition'] ?? false,
        birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        gender: json['gender'] != null ? Gender.fromString(json['gender']) : null,
        role: json['role'] != null ? Role.values.singleWhere((element) => element.name == json['role']) : null,
        picture: json['picture'] != null ? ApiBaseHelper().getUserImage(json['picture']) : null,
        facebookId: json['facebookId'],
        googleId: json['googleId'],
        governorate: json['governorate_id'] != null ? MainAppController.find.getGovernorateById(json['governorate_id']) : null,
        bio: json['bio'],
        bankNumber: json['bankNumber'],
        referralCode: json['referral_code'],
        baseCoins: json['coins'] ?? 0,
        balance: json['balance'] != null ? Helper.resolveDouble(json['balance']) : 0,
        availableCoins: json['availableCoins'] ?? 0,
        availablePurchasedCoins: json['availablePurchasedCoins'] ?? 0,
        isMailVerified: json['isMailVerified'],
        isVerified: json['isVerified'] != null ? VerifyIdentityStatus.fromString(json['isVerified']) : VerifyIdentityStatus.none,
        rating: Helper.resolveDouble(json['rating']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (email != null) data['email'] = email?.toLowerCase();
    if (name != null) data['name'] = name;
    if (language != null) data['language'] = language;
    if (password != null) data['password'] = password;
    if (bankNumber != null) data['bankNumber'] = bankNumber;
    if (phone != null) data['phoneNumber'] = phone;
    if (coordinates != null) data['coordinates'] = coordinates?.toCoordinatesString();
    if (birthdate != null) data['birthdate'] = birthdate?.toIso8601String();
    if (gender != null) data['gender'] = gender?.value.toLowerCase();
    if (role != null) data['role'] = role?.name;
    if (picture != null) data['picture'] = picture;
    if (facebookId != null) data['facebookId'] = facebookId;
    if (googleId != null) data['googleId'] = googleId;
    if (governorate != null) data['governorate'] = governorate?.id;
    if (bio != null) data['bio'] = bio;
    if (isMailVerified != null) data['isMailVerified'] = isMailVerified;
    if (referralCode != null) data['referralCode'] = referralCode;
    data['balance'] = balance;
    data['hasSharedPosition'] = hasSharedPosition;
    data['isVerified'] = isVerified.name;
    return data;
  }

  Map<String, dynamic> toLoginJson() {
    final Map<String, dynamic> data = {};
    if (email != null) data['email'] = email;
    if (phone != null) data['phoneNumber'] = phone;
    if (facebookId != null) data['facebookId'] = facebookId;
    if (googleId != null) data['googleId'] = googleId;
    if (password != null) data['password'] = password;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (email != null) data['email'] = email;
    if (name != null) data['name'] = name;
    if (language != null) data['language'] = language;
    if (phone != null) data['phone'] = phone;
    if (coordinates != null) data['coordinates'] = coordinates?.toCoordinatesString();
    if (governorate != null) data['governorate'] = governorate?.id;
    if (birthdate != null) data['birthdate'] = birthdate?.toIso8601String();
    if (gender != null) data['gender'] = gender?.value.toLowerCase();
    if (bio != null) data['bio'] = bio;
    if (bankNumber != null) data['bankNumber'] = bankNumber;
    data['hasSharedPosition'] = hasSharedPosition;
    data['balance'] = balance;
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

  factory User.fromUserTable({required UserTableData user}) => User(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        birthdate: user.birthdate,
        gender: user.gender,
        bio: user.bio,
        referralCode: user.referralCode,
        picture: user.picture,
        isVerified: user.isVerified,
        isMailVerified: user.isMailVerified,
        role: user.role,
        baseCoins: user.coins,
        availableCoins: user.availableCoins,
        availablePurchasedCoins: user.availablePurchasedCoins,
        coordinates: user.coordinates != null ? (user.coordinates as String).fromString() : null,
        governorate: MainAppController.find.getGovernorateById(user.governorate),
      );

  UserTableCompanion toUserCompanion() => UserTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        email: email == null ? const Value.absent() : Value(email!),
        name: name == null ? const Value.absent() : Value(name!),
        governorate: governorate?.id == null ? const Value.absent() : Value(governorate!.id),
        phone: phone == null ? const Value.absent() : Value(phone!),
        birthdate: birthdate == null ? const Value.absent() : Value(birthdate!),
        bio: bio == null ? const Value.absent() : Value(bio!),
        picture: picture == null ? const Value.absent() : Value(picture!),
        gender: gender == null ? const Value.absent() : Value(gender!),
        isVerified: Value(isVerified),
        referralCode: Value(referralCode ?? ''),
        coins: Value(baseCoins),
        availableCoins: Value(availableCoins),
        availablePurchasedCoins: Value(availablePurchasedCoins),
        isMailVerified: isMailVerified == null ? const Value.absent() : Value(isMailVerified!),
        role: role == null ? const Value.absent() : Value(role!),
        coordinates: coordinates == null ? const Value.absent() : Value(coordinates!.toCoordinatesString()),
      );
}
