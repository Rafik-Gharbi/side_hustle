import 'package:drift/drift.dart';

import '../database.dart';

class CategoryTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text().withDefault(const Constant(''))();
  IntColumn get icon => integer()();
  IntColumn get parent => integer().references(CategoryTable, #id).withDefault(const Constant(-1))();
  IntColumn get subscribed => integer().withDefault(const Constant(0))();
}
