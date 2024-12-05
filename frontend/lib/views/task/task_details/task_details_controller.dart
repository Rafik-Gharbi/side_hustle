import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../models/user.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../repositories/task_repository.dart';
import '../../../services/authentication_service.dart';
import '../../home/home_controller.dart';
import '../../review/add_review/add_review_bottomsheet.dart';

class TaskDetailsController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController proposedPriceController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
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
        proposedPrice: double.tryParse(proposedPriceController.text),
        dueDate: DateTime.tryParse(deliveryDateController.text),
        note: noteController.text,
        coins: task.coins,
        // coupon: coupon,
        provider: AuthenticationService.find.jwtUserData!,
        user: task.owner,
      ),
    );
    if (result) {
      Helper.goBack();
      Helper.snackBar(message: 'proposal_sent_successfully'.tr);
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
          content: 'mark_task_done_msg'.tr,
          onConfirm: () async {
            await ReservationRepository.find.updateTaskReservationStatus(reservation!, RequestStatus.finished);
            Helper.goBack();
            HomeController.find.init();
            MainAppController.find.resolveProfileActionRequired();
            Get.bottomSheet(AddReviewBottomsheet(user: reservation!.user), isScrollControlled: true);
          },
        )
      : null;

  Future<void> getTaskUpdate() async {
    if (task.id == null) return;
    final result = await TaskRepository.find.getTaskById(task.id!);
    if (result != null) {
      task.updateFields(result);
      update();
    }
  }
}
