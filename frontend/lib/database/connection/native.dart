// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../controllers/main_app_controller.dart';

Future<File> get databaseFile async {
  // We use `path_provider` to find a suitable path to store our data in.
  final Directory appDir = await getApplicationDocumentsDirectory();
  final file = File(p.join(appDir.path, 'dootify.db'));
  if (MainAppController.find.isConnected) {
    if (await file.exists()) await file.delete();
    await file.create();
    // ignore: avoid_print
    print('Database file has been recreated');
  }
  return file;
}

/// Obtains a database connection for running drift in a Dart VM.
DatabaseConnection connect() => DatabaseConnection.delayed(
      Future(() async => NativeDatabase.createBackgroundConnection(await databaseFile, logStatements: false)),
    );

// Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
//   // This method validates that the actual schema of the opened database matches
//   // the tables, views, triggers and indices for which drift_dev has generated
//   // code.
//   // Validating the database's schema after opening it is generally a good idea,
//   // since it allows us to get an early warning if we change a table definition
//   // without writing a schema migration for it.
//   //
//   // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
//   if (kDebugMode) {
//     await VerifySelf(database).validateDatabaseSchema();
//   }
// }
