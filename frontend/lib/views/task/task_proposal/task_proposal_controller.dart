import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../services/navigation_history_observer.dart';
import '../../review/add_review/add_review_bottomsheet.dart';

class TaskProposalController extends GetxController {
  List<Reservation> reservationList = [];
  bool isLoading = true;
  Task? task;

  TaskProposalController() {
    init();
  }

  Future<void> init() async {
    task ??= Get.arguments;
    if (task?.id != null) {
      reservationList = await ReservationRepository.find.getReservationByTaskId(task!.id!);
    }
    isLoading = false;
    update();
  }

  void acceptProposal(Reservation reservation) => Helper.openConfirmationDialog(
        title: 'accept_proposal_msg'.tr,
        onConfirm: () async {
          await ReservationRepository.find.updateReservationStatus(reservation, RequestStatus.confirmed);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
        },
      );

  void rejectProposals(Reservation reservation) => Helper.openConfirmationDialog(
        title: 'reject_proposal_msg'.tr,
        onConfirm: () async {
          await ReservationRepository.find.updateReservationStatus(reservation, RequestStatus.rejected);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
        },
      );

  void markDoneProposals(Reservation reservation) => Helper.openConfirmationDialog(
        title: 'mark_task_done_msg'.tr,
        onConfirm: () async {
          await ReservationRepository.find.updateReservationStatus(reservation, RequestStatus.finished);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
          MainAppController.find.resolveProfileActionRequired();
          Get.bottomSheet(AddReviewBottomsheet(user: reservation.user), isScrollControlled: true);
        },
      );
}
