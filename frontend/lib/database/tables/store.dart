import 'package:drift/drift.dart';

import '../database.dart';
import 'governorate.dart';
import 'user.dart';

class StoreTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get picture => text().withDefault(const Constant(''))();
  TextColumn get coordinates => text().withDefault(const Constant(''))();
  IntColumn get governorate => integer().references(GovernorateTable, #id).nullable()();
  IntColumn get owner => integer().references(UserTable, #id).nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
