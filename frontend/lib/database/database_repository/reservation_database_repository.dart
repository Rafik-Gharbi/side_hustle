import 'package:get/get.dart';

import '../../models/enum/request_status.dart';
import '../../models/reservation.dart';
import '../../services/logger_service.dart';
import '../database.dart';
import 'task_database_repository.dart';

class ReservationDatabaseRepository extends GetxService {
  static ReservationDatabaseRepository get find => Get.find<ReservationDatabaseRepository>();
  final Database database = Database.getInstance();

  Future<List<Reservation>> select() async {
    List<ReservationTableData> result = await database.select(database.reservationTable).get();
    List<Reservation> reservations = [];
    for (var reservation in result) {
      final task = await TaskDatabaseRepository.find.getTaskById(reservation.task!);
      reservations.add(Reservation.fromReservationData(reservation: reservation.toCompanion(true), task: task!));
    }
    return reservations;
  }

  Future<Reservation?> getReservationById(String reservationId) async {
    try {
      final ReservationTableData reservation = (await (database.select(database.reservationTable)..where((tbl) => tbl.id.equals(reservationId))).get()).first;
      final task = await TaskDatabaseRepository.find.getTaskById(reservation.task!);
      return Reservation.fromReservationData(reservation: reservation.toCompanion(true), task: task!);
    } catch (e) {
      LoggerService.logger?.e(e);
      return null;
    }
  }

  Future<int> delete(Reservation reservation) async => await database.delete(database.reservationTable).delete(reservation.toReservationCompanion());

  Future<int> deleteAll() async => await database.delete(database.reservationTable).go();

  Future<void> update(ReservationTableCompanion reservationCompanion) async => await database.update(database.reservationTable).replace(reservationCompanion);

  Future<Reservation?> insert(ReservationTableCompanion reservationCompanion) async {
    final String reservationId = (await database.into(database.reservationTable).insert(reservationCompanion)).toString(); // TODO fix this
    final reservationReservation = await getReservationById(reservationId);
    return reservationReservation;
  }

  Future<void> backupReservations(List<Reservation> reservations) async {
    LoggerService.logger?.i('Backing up reservations...');
    await deleteAll();
    for (var element in reservations) {
      await insert(element.toReservationCompanion());
    }
  }

  Future<void> updateReservationStatus(Reservation reservation, RequestStatus status) async {
    await update(reservation.toReservationCompanion(statusUpdate: status));
  }

  Future<void> addReservation(Reservation reservation) async {
    await insert(reservation.toReservationCompanion());
  }
}
