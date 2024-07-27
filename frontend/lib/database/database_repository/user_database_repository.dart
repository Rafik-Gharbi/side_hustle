import 'package:get/get.dart';

import '../../models/user.dart';
import '../../services/logger_service.dart';
import '../database.dart';

class UserDatabaseRepository extends GetxService {
  static UserDatabaseRepository get find => Get.find<UserDatabaseRepository>();
  final Database database = Database.getInstance();

  Future<User?> getUserById(int userId) async {
    try {
      final UserTableData? user = (await (database.select(database.userTable)..where((tbl) => tbl.id.equals(userId))).get()).firstOrNull;
      return user != null ? User.fromUserTable(user: user) : User(id: userId);
    } catch (e) {
      LoggerService.logger?.e(e);
      return null;
    }
  }

  Future<int> delete() async => await database.delete(database.userTable).go();

  Future<void> update(UserTableCompanion userCompanion) async => await database.update(database.userTable).replace(userCompanion);

  Future<User?> insert(UserTableCompanion userCompanion) async {
    final int userId = await database.into(database.userTable).insert(userCompanion);
    final userDTO = await getUserById(userId);
    return userDTO;
  }

  Future<void> backupUser(UserTableCompanion userCompanion) async {
    LoggerService.logger?.i('Backing up user...');
    await delete();
    Future.delayed(const Duration(milliseconds: 800), () async => await insert(userCompanion));
  }
}
