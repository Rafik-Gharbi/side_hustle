import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../models/service.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../services/navigation_history_observer.dart';

class ServiceRequestController extends GetxController {
  List<Reservation> reservationList = [];
  RxBool isLoading = true.obs;
  Service? service;

  ServiceRequestController() {
    init();
  }

  Future<void> init() async {
    service ??= Get.arguments;
    if (service?.id != null) {
      reservationList = await ReservationRepository.find.getReservationByServiceId(service!.id!);
    }
    isLoading.value = false;
    update();
  }

  void acceptProposal(Reservation reservation) => Helper.openConfirmationDialog(
        content: 'accept_request_msg'.tr,
        onConfirm: () async {
          isLoading.value = true;
          await ReservationRepository.find.updateServiceReservationStatus(reservation, RequestStatus.confirmed);
          isLoading.value = false;
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
          MainAppController.find.resolveProfileActionRequired();
        },
      );

  void rejectProposals(Reservation reservation) => Helper.openConfirmationDialog(
        content: 'reject_request_msg'.tr,
        onConfirm: () async {
          isLoading.value = true;
          await ReservationRepository.find.updateServiceReservationStatus(reservation, RequestStatus.rejected);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
          isLoading.value = false;
          MainAppController.find.resolveProfileActionRequired();
        },
      );
}
