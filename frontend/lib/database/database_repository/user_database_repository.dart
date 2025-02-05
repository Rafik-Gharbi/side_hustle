import 'package:drift/drift.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../services/logging/logger_service.dart';
import '../database.dart';

class UserDatabaseRepository extends GetxService {
  static UserDatabaseRepository get find => Get.find<UserDatabaseRepository>();
  final Database database = Database.getInstance();

  Future<User?> getUserById(int userId) async {
    try {
      final UserTableData? user = (await (database.select(database.userTable)..where((tbl) => tbl.id.equals(userId))).get()).firstOrNull;
      return user != null ? User.fromUserTable(user: user) : null;
    } catch (e) {
      LoggerService.logger?.e(e);
      return null;
    }
  }

  Future<int> delete() async => await database.delete(database.userTable).go();

  Future<void> update(UserTableCompanion userCompanion) async => await database.update(database.userTable).replace(userCompanion);

  Future<User?> insert(UserTableCompanion userCompanion) async {
    final existingItem = await getUserById(userCompanion.id.value);
    if (existingItem != null) return existingItem;
    final int userId = await database.into(database.userTable).insert(userCompanion, mode: InsertMode.insertOrReplace);
    final userDTO = await getUserById(userId);
    return userDTO;
  }

  Future<void> backupUser(UserTableCompanion userCompanion) async {
    LoggerService.logger?.i('Backing up user...');
    final tableExists = await Database.doesTableExist(database, 'user_table');
    if (tableExists) {
      await delete();
    }
    Future.delayed(const Duration(milliseconds: 800), () async => await insert(userCompanion));
  }
}
