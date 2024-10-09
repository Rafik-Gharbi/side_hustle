import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/reservation_database_repository.dart';
import '../helpers/helper.dart';
import '../models/dto/task_details_dto.dart';
import '../models/enum/request_status.dart';
import '../models/reservation.dart';
import '../models/task.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class ReservationRepository extends GetxService {
  static ReservationRepository get find => Get.find<ReservationRepository>();

  // Send a proposal for the task's owner
  Future<bool> addReservation({required Reservation reservation}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/reservation/add', body: reservation.toJson(), sendToken: true);
      if (MainAppController.find.isConnected) ReservationDatabaseRepository.find.addReservation(Reservation.fromJson(result['reservation']));
      return result['reservation'] != null && result['reservation'].toString().isNotEmpty;
    } catch (e) {
      if (e.toString().contains('reservation_already_exist')) {
        Helper.snackBar(message: 'reservation_already_exist'.tr);
      } else {
        Helper.snackBar(message: 'error_sending_proposal'.tr);
      }
      LoggerService.logger?.e('Error occured in addReservation:\n$e');
    }
    return false;
  }

  // Future<List<Reservation>> listReservation() async {
  //   try {
  //     final result = await ApiBaseHelper().request(RequestType.get, '/reservation/list', sendToken: true);
  //     final reservations = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
  //     return reservations;
  //   } catch (e) {
  //     LoggerService.logger?.e('Error occured in listReservation:\n$e');
  //   }
  //   return [];
  // }

  Future<List<Reservation>> getReservationByTaskId(String taskId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/task-reservation?taskId=$taskId', sendToken: true);
      final reservations = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return reservations;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
    return [];
  }

  Future<TaskReservationDetailsDTO?> getTaskReservationDetails(Task task) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/reservation/details?taskId=${task.id}');
      return TaskReservationDetailsDTO.fromJson(result);
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
    return null;
  }

  Future<void> updateReservationStatus(Reservation reservation, RequestStatus status) async {
    try {
      await ApiBaseHelper().request(
        RequestType.post,
        '/reservation/update-status',
        sendToken: true,
        body: {'reservation': reservation.toJson(), 'status': status.name},
      );
      if (MainAppController.find.isConnected) ReservationDatabaseRepository.find.updateReservationStatus(reservation, status);
    } catch (e) {
      Helper.snackBar(message: 'An error has occurred');
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
  }

  Future<List<Reservation>> getUserTasksHistory() async {
    try {
      List<Reservation> reservations = [];
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/reservation/reservations-history', sendToken: true);
        reservations = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      } else {
        reservations = await ReservationDatabaseRepository.find.select();
      }
      // if (reservations.isNotEmpty && MainAppController.find.isConnected) ReservationDatabaseRepository.find.backupReservations(reservations);
      return reservations;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserTasksHistory:\n$e');
    }
    return [];
  }
}
