import 'package:drift/drift.dart';

import '../database.dart';

class CategoryTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get icon => text()();
  IntColumn get parent => integer().references(CategoryTable, #id).withDefault(const Constant(-1))();
  IntColumn get subscribed => integer().withDefault(const Constant(0))();
}
