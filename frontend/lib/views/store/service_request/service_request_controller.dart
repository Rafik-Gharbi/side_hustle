import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/booking.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/service.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/navigation_history_observer.dart';

class ServiceRequestController extends GetxController {
  List<Booking> bookingList = [];
  bool isLoading = true;
  Service? service;

  ServiceRequestController() {
    init();
  }

  Future<void> init() async {
    service ??= Get.arguments;
    if (service?.id != null) {
      bookingList = await BookingRepository.find.getBookingByServiceId(service!.id!);
    }
    isLoading = false;
    update();
  }

  void acceptProposal(Booking booking) => Helper.openConfirmationDialog(
        title: 'accept_request_msg'.tr,
        onConfirm: () async {
          await BookingRepository.find.updateBookingStatus(booking, RequestStatus.confirmed);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
          MainAppController.find.resolveProfileActionRequired();
        },
      );

  void rejectProposals(Booking booking) => Helper.openConfirmationDialog(
        title: 'reject_request_msg'.tr,
        onConfirm: () async {
          await BookingRepository.find.updateBookingStatus(booking, RequestStatus.rejected);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
          MainAppController.find.resolveProfileActionRequired();
        },
      );
}
