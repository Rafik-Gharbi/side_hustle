import 'package:get/get.dart';

import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../services/navigation_history_observer.dart';

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
        title: 'Are you sure to accept this proposal? This will automatically reject other proposals if any.',
        onConfirm: () async {
          await ReservationRepository.find.updateReservationStatus(reservation, RequestStatus.confirmed);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
        },
      );

  void rejectProposals(Reservation reservation) => Helper.openConfirmationDialog(
        title: 'Are you sure to reject this proposal?',
        onConfirm: () async {
          await ReservationRepository.find.updateReservationStatus(reservation, RequestStatus.rejected);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
        },
      );
}
