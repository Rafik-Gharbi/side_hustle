import '../../models/user.dart';

extension RoleExtension on Role {
  String get value {
    switch (this) {
      case Role.admin:
        return 'admin';
      case Role.subscribed:
        return 'subscribed';
      case Role.user:
        return 'user';
      default:
        throw Exception('Invalid Role');
    }
  }

  static Role? fromString(String? value) {
    switch (value) {
      case 'admin':
        return Role.admin;
      case 'subscribed':
        return Role.subscribed;
      case 'user':
        return Role.user;
      default:
        return null;
    }
  }
}
