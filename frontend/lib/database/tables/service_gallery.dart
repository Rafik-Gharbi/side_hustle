import 'package:drift/drift.dart';

import '../database.dart';
import 'service.dart';

class ServiceGalleryTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get url => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant(''))();
  IntColumn get serviceId => integer().references(ServiceTable, #id).nullable()();
}
