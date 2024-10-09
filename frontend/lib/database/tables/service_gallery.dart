import 'package:drift/drift.dart';

import '../database.dart';
import 'service.dart';

class ServiceGalleryTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get url => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant(''))();
  TextColumn get serviceId => text().references(ServiceTable, #id).nullable()();
}
