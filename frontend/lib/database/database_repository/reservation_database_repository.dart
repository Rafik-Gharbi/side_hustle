import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get/get.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../models/enum/request_status.dart';
import '../../models/reservation.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences.dart';
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
    final existingItem = await getReservationById(reservationCompanion.id.value);
    if (existingItem != null) return existingItem;
    await database.into(database.reservationTable).insert(reservationCompanion, mode: InsertMode.insertOrReplace);
    final reservationReservation = await getReservationById(reservationCompanion.id.value);
    return reservationReservation;
  }

  Future<void> backupReservations(List<Reservation> reservations) async {
    LoggerService.logger?.i('Backing up reservations...');
    final tableExists = await Database.doesTableExist(database, 'reservation_table');
    if (tableExists) {
      await deleteAll();
    }
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

  Future<Map<String, List<dynamic>>> getHomeReservations() async {
    LoggerService.logger?.i('Getting home reservations...');
    List<Reservation> reservation = [];
    List<Reservation> ongoingReservation = [];
    List<Reservation> booking = [];
    List<Reservation> ongoingBooking = [];
    final savedReservationKeyIds = SharedPreferencesService.find.get(reservationKey);
    List<String> reservationId = (jsonDecode(savedReservationKeyIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (reservationId.isNotEmpty) {
      for (var reservationId in reservationId) {
        final reservationFound = await getReservationById(reservationId);
        if (reservationFound != null) reservation.add(reservationFound);
      }
    }
    final savedOngoingReservationKeyIds = SharedPreferencesService.find.get(ongoingReservationKey);
    List<String> ongoingReservationId = (jsonDecode(savedOngoingReservationKeyIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (ongoingReservationId.isNotEmpty) {
      for (var reservationId in ongoingReservationId) {
        final reservation = await getReservationById(reservationId);
        if (reservation != null) ongoingReservation.add(reservation);
      }
    }
    final savedBookingKeyIds = SharedPreferencesService.find.get(bookingKey);
    List<String> bookingId = (jsonDecode(savedBookingKeyIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (bookingId.isNotEmpty) {
      for (var reservationId in bookingId) {
        final reservation = await getReservationById(reservationId);
        if (reservation != null) booking.add(reservation);
      }
    }
    final savedOngoingBookingKeyIds = SharedPreferencesService.find.get(ongoingBookingKey);
    List<String> ongoingBookingId = (jsonDecode(savedOngoingBookingKeyIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (ongoingBookingId.isNotEmpty) {
      for (var reservationId in ongoingBookingId) {
        final reservation = await getReservationById(reservationId);
        if (reservation != null) ongoingBooking.add(reservation);
      }
    }
    return {'reservation': reservation, 'ongoingReservation': ongoingReservation, 'booking': booking, 'ongoingBooking': ongoingBooking};
  }

  Future<void> backupHomeReservations(Map<String, List> reservations) async {
    if (reservations['reservation'] != null && (reservations['reservation'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(reservationKey, jsonEncode((reservations['reservation'] as List).map((e) => e.id).toList()));
    }
    if (reservations['ongoingReservation'] != null && (reservations['ongoingReservation'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(ongoingReservationKey, jsonEncode((reservations['ongoingReservation'] as List).map((e) => e.id).toList()));
    }
    if (reservations['booking'] != null && (reservations['booking'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(bookingKey, jsonEncode((reservations['booking'] as List).map((e) => e.id).toList()));
    }
    if (reservations['ongoingBooking'] != null && (reservations['ongoingBooking'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(ongoingBookingKey, jsonEncode((reservations['ongoingBooking'] as List).map((e) => e.id).toList()));
    }
    final List<Reservation> reservationsForBackup = [];
    reservationsForBackup.addAll((reservations['reservation'] as List).map((e) => e as Reservation));
    reservationsForBackup.addAll((reservations['ongoingReservation'] as List).map((e) => e as Reservation));
    reservationsForBackup.addAll((reservations['booking'] as List).map((e) => e as Reservation));
    reservationsForBackup.addAll((reservations['ongoingBooking'] as List).map((e) => e as Reservation));
    await backupReservations(reservationsForBackup);
  }
}
