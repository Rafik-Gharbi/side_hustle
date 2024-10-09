import 'package:drift/drift.dart';

import '../../models/enum/request_status.dart';
import '../database.dart';
import 'service.dart';
import 'user.dart';

class BookingTable extends Table with AutoIncrementingStringPrimaryKey {
  TextColumn get service => text().references(ServiceTable, #id).nullable()();
  DateTimeColumn get date => dateTime().withDefault(Constant(DateTime.now()))();
  RealColumn get totalPrice => real().withDefault(const Constant(0))();
  TextColumn get coupon => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get status => intEnum<RequestStatus>().withDefault(const Constant(0))();
  IntColumn get user => integer().references(UserTable, #id).nullable()();
}
