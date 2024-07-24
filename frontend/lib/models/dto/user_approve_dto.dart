import '../../networking/api_base_helper.dart';
import '../user.dart';

class UserApproveDTO {
  final User? user;
  final UserDocument? userDocument;

  UserApproveDTO({this.user, this.userDocument});

  factory UserApproveDTO.fromJson(Map<String, dynamic> json) => UserApproveDTO(
        user: User.fromJson(json['user']),
        userDocument: UserDocument.fromJson(json['userDocument']),
      );
}

class UserDocument {
  final int? id;
  final String? frontIdentity;
  final String? backIdentity;
  final String? passport;
  final String? selfie;

  UserDocument({this.id, this.frontIdentity, this.backIdentity, this.passport, this.selfie});

  factory UserDocument.fromJson(Map<String, dynamic> json) => UserDocument(
        id: json['id'],
        frontIdentity: json['front_identity'] != null ? ApiBaseHelper.find.getUserImage(json['front_identity']) : null,
        backIdentity: json['back_identity'] != null ? ApiBaseHelper.find.getUserImage(json['back_identity']) : null,
        passport: json['passport'] != null ? ApiBaseHelper.find.getUserImage(json['passport']) : null,
        selfie: json['selfie'] != null ? ApiBaseHelper.find.getUserImage(json['selfie']) : null,
      );

  bool get isPassport => passport != null;
}
