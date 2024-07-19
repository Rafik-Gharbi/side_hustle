import '../../models/user.dart';

extension RoleExtension on Role {
  String get value {
    switch (this) {
      case Role.admin:
        return 'admin';
      case Role.provider:
        return 'provider';
      case Role.seeker:
        return 'seeker';
      default:
        throw Exception('Invalid Role');
    }
  }

  static Role? fromString(String? value) {
    switch (value) {
      case 'admin':
        return Role.admin;
      case 'provider':
        return Role.provider;
      case 'seeker':
        return Role.seeker;
      default:
        return null;
    }
  }
}
