import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/booking.dart';
import '../../../models/enum/request_status.dart';
import '../../../repositories/booking_repository.dart';

class ServiceHistoryController extends GetxController {
  List<Booking> _taskHistoryList = [];
  bool isLoading = true;

  List<Booking> get ongoingServices => _taskHistoryList.where((element) => element.status == RequestStatus.confirmed).toList();
  List<Booking> get pendingServices => _taskHistoryList.where((element) => element.status == RequestStatus.pending).toList();
  List<Booking> get finishedServices => _taskHistoryList.where((element) => element.status == RequestStatus.finished).toList();
  List<Booking> get rejectedServices => _taskHistoryList.where((element) => element.status == RequestStatus.rejected).toList();
  bool get hasNoServicesYet => _taskHistoryList.isEmpty;

  ServiceHistoryController() {
    init();
  }

  Future<void> init() async {
    _taskHistoryList = await BookingRepository.find.getUserServicesHistory();
    isLoading = false;
    update();
  }

  void markBookingAsDone(Booking booking) => Helper.openConfirmationDialog(
        title: 'Are you sure to mark this service done?',
        onConfirm: () async {
          await BookingRepository.find.updateBookingStatus(booking, RequestStatus.finished);
          Get.back();
          init();
          MainAppController.find.resolveProfileActionRequired();
        },
      );
}
