import 'package:get/get.dart';

import '../../helpers/helper.dart';
import '../../models/booking.dart';
import '../../models/enum/request_status.dart';
import '../../models/service.dart';
import '../../repositories/booking_repository.dart';
import '../../services/navigation_history_observer.dart';

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
        title: 'Are you sure to accept this request?',
        onConfirm: () async {
          await BookingRepository.find.updateBookingStatus(booking, RequestStatus.confirmed);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
        },
      );

  void rejectProposals(Booking booking) => Helper.openConfirmationDialog(
        title: 'Are you sure to reject this request?',
        onConfirm: () async {
          await BookingRepository.find.updateBookingStatus(booking, RequestStatus.rejected);
          NavigationHistoryObserver.instance.goToPreviousRoute(result: true);
        },
      );
}
