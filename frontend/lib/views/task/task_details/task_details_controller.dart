import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../models/user.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../services/authentication_service.dart';
import '../../home/home_controller.dart';

class TaskDetailsController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  final Task task;
  RxInt condidates = 0.obs;
  RxBool isUserConfirmedTaskSeeker = false.obs;
  Rx<User?> confirmedTaskUser = User().obs;
  Reservation? reservation;

  TaskDetailsController(this.task) {
    init();
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
      Future.delayed(const Duration(milliseconds: 600), () => init());
    }
  }

  void clearFormFields() {
    noteController.clear();
  }

  Future<void> init() async {
    final result = await ReservationRepository.find.getTaskReservationDetails(task);
    condidates.value = result?.condidates ?? 0;
    isUserConfirmedTaskSeeker.value = result?.isUserTaskSeeker ?? false;
    confirmedTaskUser.value = result?.confirmedTaskUser ?? User();
    reservation = result?.reservation;
  }

  void markDoneProposals() => reservation != null
      ? Helper.openConfirmationDialog(
          title: 'Are you sure to mark this task as done?\nThis will automatically pay the task seeker.',
          onConfirm: () async {
            await ReservationRepository.find.updateReservationStatus(reservation!, RequestStatus.finished);
            Get.back();
            HomeController.find.init();
            MainAppController.find.resolveProfileActionRequired();
          },
        )
      : null;
}
