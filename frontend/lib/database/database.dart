import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show Color;

import '../models/enum/request_status.dart';
import '../models/user.dart';
import 'connection/connection.dart' as impl;
import 'tables/reservation.dart';
import 'tables/service.dart';
import 'tables/service_gallery.dart';
import 'tables/store.dart';
import 'tables/task_attachment.dart';
import 'tables/user.dart';
import 'tables/governorate.dart';
import 'tables/category.dart';
import 'tables/task.dart';

part 'database.g.dart';

@DriftDatabase(tables: <Type>[
  TaskTable,
  UserTable,
  CategoryTable,
  GovernorateTable,
  TaskAttachmentTable,
  StoreTable,
  ServiceTable,
  ServiceGalleryTable,
  ReservationTable,
])
class Database extends _$Database {
  // Private constructor to prevent external instantiation
  Database._(super.e);

  static Database? _instance; // Singleton instance

  // Factory method to get the singleton instance
  factory Database.getInstance() => _instance ??= Database._(impl.connect());

  @override
  int get schemaVersion => 1;

  Future<void> deleteTransactionTable() async {
    await customStatement('DELETE FROM "task";');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll(); // create all tables
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // if (from < 5) {
        //   // we added the isSaving budget in the change from version 4 to version 5
        //   await m.addColumn(budget, budget.isSaving);
        // }
        // if (from < 6) {
        //   // we added category persistance from version 5 to version 6
        //   await m.createTable(category);
        // }
        // if (from < 7) {
        //   // we added account initial amount from version 6 to version 7
        //   await m.addColumn(account, account.initialAmount);
        // }
      },
    );
  }
}

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

mixin AutoIncrementingStringPrimaryKey on Table {
  TextColumn get id => text()();
}

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.value;
}
