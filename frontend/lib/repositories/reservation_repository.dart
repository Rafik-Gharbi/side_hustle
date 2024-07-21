import 'package:get/get.dart';

import '../helpers/helper.dart';
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

  Future<List<Reservation>> listReservation() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/list', sendToken: true);
      final tasks = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
    return [];
  }

  Future<List<Reservation>> getReservationByTaskId(int taskId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/task-reservation?taskId=$taskId', sendToken: true);
      final tasks = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
    return [];
  }

  Future<int> getTaskCondidates(Task task) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/condidates?taskId=${task.id}');
      return result['condidates'] ?? 0;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
    return 0;
  }

  Future<void> updateReservationStatus(Reservation reservation, ReservationStatus status) async {
    try {
      await ApiBaseHelper().request(
        RequestType.post,
        '/reservation/update-status',
        sendToken: true,
        body: {'reservation': reservation.toJson(), 'status': status.name},
      );
    } catch (e) {
      Helper.snackBar(message: 'An error has occurred');
      LoggerService.logger?.e('Error occured in listReservation:\n$e');
    }
  }

  Future<List<Reservation>> getUserTasksHistory() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/reservation/tasks-history', sendToken: true);
      final tasks = (result['formattedList'] as List).map((e) => Reservation.fromJson(e)).toList();
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserTasksHistory:\n$e');
    }
    return [];
  }
}
