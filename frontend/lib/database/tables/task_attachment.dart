import 'package:drift/drift.dart';

import '../database.dart';
import 'task.dart';

class TaskAttachmentTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get url => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant(''))();
  TextColumn get taskId => text().references(TaskTable, #id).nullable()();
}
