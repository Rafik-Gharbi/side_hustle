import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/main_app_controller.dart';
import '../database/database_repository/reservation_database_repository.dart';
import '../helpers/helper.dart';
import '../models/dto/task_details_dto.dart';
import '../models/enum/request_status.dart';
import '../models/reservation.dart';
import '../models/task.dart';
import '../networking/api_base_helper.dart';
import '../services/authentication_service.dart';
import '../services/logger_service.dart';

class ReservationRepository extends GetxService {
  static ReservationRepository get find => Get.find<ReservationRepository>();

  // Send a proposal for the task's owner
  Future<bool> addReservation({required Reservation reservation}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/reservation/add', body: reservation.toJson(), sendToken: true);
      if (MainAppController.find.isConnected) ReservationDatabaseRepository.find.addReservation(Reservation.fromJson(result['reservation']));
      AuthenticationService.find.initiateCurrentUser(result['token'], silent: true);
      return result['reservation'] != null && result['reservation'].toString().isNotEmpty;
    } catch (e) {
      if (e.toString().contains('insufficient_base_coins')) {
        Helper.snackBar(message: 'insufficient_base_coins'.tr);
      } else if (e.toString().contains('reservation_already_exist')) {
        Helper.snackBar(message: 'reservation_already_exist'.tr);
      } else {
        Helper.snackBar(message: 'error_sending_proposal'.tr);
      }
      LoggerService.logger?.e('Error occured in addReservation:\n$e');
    }
    return false;
  }

  Future<List<Reservation>> getReservationByTaskId(String taskId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/task-reservation?taskId=$taskId', sendToken: true);
      final reservations = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return reservations;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getReservationByTaskId:\n$e');
    }
    return [];
  }

  Future<TaskReservationDetailsDTO?> getTaskReservationDetails(Task task) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/reservation/details?taskId=${task.id}');
      return result != null ? TaskReservationDetailsDTO.fromJson(result) : null;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getTaskReservationDetails:\n$e');
    }
    return null;
  }

  Future<bool> updateTaskReservationStatus(Reservation reservation, RequestStatus status) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        '/reservation/update-status',
        sendToken: true,
        body: {'reservation': reservation.toJson(), 'status': status.name},
      );
      if (MainAppController.find.isConnected) ReservationDatabaseRepository.find.updateReservationStatus(reservation, status);
      return result?['done'] == true;
    } catch (e) {
      Helper.snackBar(message: 'error_occurred'.tr);
      LoggerService.logger?.e('Error occured in updateTaskReservationStatus:\n$e');
      return false;
    }
  }

  Future<List<Reservation>> getUserTasksOffers({int page = 0, int limit = kLoadMoreLimit}) async {
    try {
      List<Reservation> reservations = [];
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/reservation/tasks-offers?page=$page&limit=$limit', sendToken: true);
        reservations = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      } else {
        reservations = await ReservationDatabaseRepository.find.select();
      }
      // if (reservations.isNotEmpty && MainAppController.find.isConnected) ReservationDatabaseRepository.find.backupReservations(reservations);
      return reservations;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserTasksOffers:\n$e');
    }
    return [];
  }

  // Send a proposal for the service's owner
  Future<bool> addServiceReservation({required Reservation reservation}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/reservation/add-service', body: reservation.toJson(), sendToken: true);
      if (MainAppController.find.isConnected) ReservationDatabaseRepository.find.addReservation(Reservation.fromJson(result['reservation']));
      AuthenticationService.find.initiateCurrentUser(result['token'], silent: true);
      return result['reservation'] != null && result['reservation'].toString().isNotEmpty;
    } catch (e) {
      if (e.toString().contains('insufficient_base_coins')) {
        Helper.snackBar(message: 'insufficient_base_coins'.tr);
      } else if (e.toString().contains('reservation_already_exist')) {
        Helper.snackBar(message: 'reservation_already_exist'.tr);
      } else if (e.toString().contains('cannot_book_your_own_service')) {
        Helper.snackBar(message: 'cannot_book_your_own_service'.tr);
      } else {
        Helper.snackBar(message: 'error_sending_request'.tr);
      }
      LoggerService.logger?.e('Error occured in addServiceReservation:\n$e');
    }
    return false;
  }

  Future<List<Reservation>> listTaskOffers() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/task-offers', sendToken: true);
      final services = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return services;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listTaskOffers:\n$e');
    }
    return [];
  }

  Future<List<Reservation>> getReservationByServiceId(String serviceId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/service-booking?serviceId=$serviceId', sendToken: true);
      final services = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return services;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getReservationByServiceId:\n$e');
    }
    return [];
  }

  Future<bool> updateServiceReservationStatus(Reservation serviceReservation, RequestStatus status) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        '/reservation/update-service-status',
        sendToken: true,
        body: {'reservation': serviceReservation.toJson(), 'status': status.name},
      );
      if (MainAppController.find.isConnected) ReservationDatabaseRepository.find.updateReservationStatus(serviceReservation, status);
      return result?['done'] == true;
    } catch (e) {
      Helper.snackBar(message: 'error_occurred'.tr);
      LoggerService.logger?.e('Error occured in updateServiceReservationStatus:\n$e');
      return false;
    }
  }

  Future<List<Reservation>> getUserRequestedReservations({int page = 0, int limit = kLoadMoreLimit}) async {
    try {
      List<Reservation> bookings = [];
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/reservation/services-requests?page=$page&limit=$limit', sendToken: true);
        bookings = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      } else {
        bookings = await ReservationDatabaseRepository.find.select();
      }
      if (bookings.isNotEmpty && MainAppController.find.isConnected) ReservationDatabaseRepository.find.backupReservations(bookings);
      return bookings;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserRequestedServices:\n$e');
    }
    return [];
  }

  Future<List<Reservation>> getUserProvidedServices({int page = 0, int limit = kLoadMoreLimit}) async {
    try {
      List<Reservation> bookings = [];
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/reservation/service-offers?page=$page&limit=$limit', sendToken: true);
        bookings = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      } else {
        bookings = await ReservationDatabaseRepository.find.select();
      }
      if (bookings.isNotEmpty && MainAppController.find.isConnected) ReservationDatabaseRepository.find.backupReservations(bookings);
      return bookings;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserProvidedServices:\n$e');
    }
    return [];
  }
}
