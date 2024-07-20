import 'package:drift/drift.dart';

import '../database.dart';

class GovernorateTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text().withDefault(const Constant(''))();
}
