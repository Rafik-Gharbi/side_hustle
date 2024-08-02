import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../helpers/helper.dart';
import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../services/authentication_service.dart';

class TaskDetailsController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  final Task task;
  RxInt condidates = 0.obs;

  TaskDetailsController(this.task) {
    _init();
  }

  Future<void> submitProposal(Task task) async {
    final result = await ReservationRepository.find.addReservation(
      reservation: Reservation(
        task: task,
        date: DateTime.now(),
        totalPrice: task.price ?? 0,
        note: noteController.text,
        // coupon: coupon,
        user: AuthenticationService.find.jwtUserData!,
      ),
    );
    if (result) {
      Get.back();
      Helper.snackBar(message: 'Proposal sent successfully');
      Future.delayed(const Duration(milliseconds: 600), () => _init());
    }
  }

  void clearFormFields() {
    noteController.clear();
  }

  Future<void> _init() async {
    condidates.value = await ReservationRepository.find.getTaskCondidates(task);
  }
}
