import 'package:drift/drift.dart';

import '../../models/user.dart';
import '../database.dart';
import 'governorate.dart';

class UserTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get picture => text().withDefault(const Constant(''))();
  IntColumn get role => intEnum<Role>().withDefault(const Constant(2))();
  IntColumn get gender => intEnum<Gender>().withDefault(const Constant(2))();
  IntColumn get isVerified => intEnum<VerifyIdentityStatus>().withDefault(const Constant(2))();
  BoolColumn get isMailVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get birthdate => dateTime().nullable()();
  TextColumn get bio => text().withDefault(const Constant(''))();
  TextColumn get coordinates => text().nullable()();
  IntColumn get governorate => integer().references(GovernorateTable, #id).withDefault(const Constant(0))();
}
