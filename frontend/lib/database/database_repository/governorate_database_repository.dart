import 'package:get/get.dart';

import '../../models/governorate.dart';
import '../../services/logger_service.dart';
import '../database.dart';

class GovernorateDatabaseRepository extends GetxService {
  static GovernorateDatabaseRepository get find => Get.find<GovernorateDatabaseRepository>();
  final Database database = Database.getInstance();

  Future<List<Governorate>> select() async {
    List<GovernorateTableData> result = await database.select(database.governorateTable).get();
    List<Governorate> governorates = [];
    for (var governorate in result) {
      governorates.add(Governorate.fromGovernorateData(governorate: governorate.toCompanion(true)));
    }
    return governorates;
  }

  Future<Governorate?> getGovernorateById(int governorateId) async {
    try {
      final GovernorateTableData governorate = (await (database.select(database.governorateTable)..where((tbl) => tbl.id.equals(governorateId))).get()).first;
      return Governorate.fromGovernorateData(governorate: governorate.toCompanion(true));
    } catch (e) {
      LoggerService.logger?.e(e);
      return null;
    }
  }

  Future<int> delete(Governorate governorate) async {
    return await database.delete(database.governorateTable).delete(governorate.toGovernorateCompanion());
  }

  Future<int> deleteAll() async {
    return await database.delete(database.governorateTable).go();
  }

  Future<Governorate> update(GovernorateTableCompanion governorateCompanion) async {
    await database.update(database.governorateTable).replace(governorateCompanion);
    final governorateGovernorate = Governorate.fromGovernorateData(governorate: governorateCompanion);
    return governorateGovernorate;
  }

  Future<Governorate?> insert(GovernorateTableCompanion governorateCompanion, {bool isSyncing = false}) async {
    Governorate? governorateGovernorate;
    if (isSyncing) {
      governorateGovernorate = Governorate.fromGovernorateData(governorate: governorateCompanion);
    } else {
      final int governorateId = await database.into(database.governorateTable).insert(governorateCompanion);
      governorateGovernorate = await getGovernorateById(governorateId);
    }
    return governorateGovernorate;
  }

  Future<void> backupGovernorates(List<Governorate> governorates) async {
    LoggerService.logger?.i('Backing up governorates...');
    await deleteAll();
    for (var element in governorates) {
      await insert(element.toGovernorateCompanion());
    }
  }
}
