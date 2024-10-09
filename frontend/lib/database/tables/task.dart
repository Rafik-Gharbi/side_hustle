import 'package:drift/drift.dart';

import '../database.dart';
import 'category.dart';
import 'governorate.dart';
import 'user.dart';

class TaskTable extends Table with AutoIncrementingStringPrimaryKey {
  RealColumn get price => real().withDefault(const Constant(0))();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get category => integer().references(CategoryTable, #id)();
  IntColumn get governorate => integer().references(GovernorateTable, #id).nullable()();
  IntColumn get owner => integer().references(UserTable, #id).nullable()();
  DateTimeColumn get dueDate => dateTime().withDefault(Constant(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59)))();
  TextColumn get delivrables => text().withDefault(const Constant(''))();
  BoolColumn get isfavorite => boolean().withDefault(const Constant(false))();
}
