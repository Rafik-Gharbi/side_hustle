import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../repositories/reservation_repository.dart';
import '../../review/add_review/add_review_bottomsheet.dart';

class ServiceHistoryController extends GetxController {
  List<Reservation> _taskHistoryList = [];
  RxBool isLoading = true.obs;
  Reservation? highlightedReservation;

  List<Reservation> get ongoingServices => _taskHistoryList.where((element) => element.status == RequestStatus.confirmed).toList();
  List<Reservation> get pendingServices => _taskHistoryList.where((element) => element.status == RequestStatus.pending).toList();
  List<Reservation> get finishedServices => _taskHistoryList.where((element) => element.status == RequestStatus.finished).toList();
  List<Reservation> get rejectedServices => _taskHistoryList.where((element) => element.status == RequestStatus.rejected).toList();
  bool get hasNoServicesYet => _taskHistoryList.isEmpty;

  ServiceHistoryController() {
    init();
  }

  Future<void> init() async {
    _taskHistoryList = await ReservationRepository.find.getUserServicesHistory();
    if (Get.arguments != null) highlightedReservation = _taskHistoryList.cast<Reservation?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    if (highlightedReservation != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedReservation = null;
        update();
      });
    }
    isLoading.value = false;
    update();
  }

  void markServiceReservationAsDone(Reservation booking) => Helper.openConfirmationDialog(
        title: 'mark_service_done_msg'.tr,
        onConfirm: () async {
          await ReservationRepository.find.updateServiceReservationStatus(booking, RequestStatus.finished);
          Helper.goBack();
          init();
          MainAppController.find.resolveProfileActionRequired();
          Get.bottomSheet(AddReviewBottomsheet(user: booking.provider), isScrollControlled: true);
        },
      );
}
