import 'package:drift/drift.dart';

import '../database.dart';

class GovernorateTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get category => text().withDefault(const Constant(''))();
  RealColumn get estimation => real().withDefault(const Constant(0.0))();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isSaving => boolean().withDefault(const Constant(false))();
  TextColumn get notionId => text().nullable()();
}
