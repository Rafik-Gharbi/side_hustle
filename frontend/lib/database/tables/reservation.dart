import 'package:drift/drift.dart';

import '../../models/enum/request_status.dart';
import '../database.dart';
import 'task.dart';
import 'user.dart';

class ReservationTable extends Table with AutoIncrementingStringPrimaryKey {
  TextColumn get task => text().references(TaskTable, #id).nullable()();
  TextColumn get service => text().references(TaskTable, #id).nullable()();
  DateTimeColumn get date => dateTime().withDefault(Constant(DateTime.now()))();
  RealColumn get totalPrice => real().withDefault(const Constant(0))();
  RealColumn get proposedPrice => real().nullable()();
  TextColumn get coupon => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get status => intEnum<RequestStatus>().withDefault(const Constant(0))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  IntColumn get user => integer().references(UserTable, #id).nullable()();
  IntColumn get provider => integer().references(UserTable, #id).nullable()();
}
