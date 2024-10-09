import 'package:drift/drift.dart';

import '../database.dart';
import 'category.dart';
import 'store.dart';

class ServiceTable extends Table with AutoIncrementingStringPrimaryKey {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get category => integer().references(CategoryTable, #id).nullable()();
  IntColumn get store => integer().references(StoreTable, #id).nullable()();
  RealColumn get price => real().withDefault(const Constant(0))();
}
