import 'package:get/get.dart';

import '../../models/enum/request_status.dart';
import '../../models/reservation.dart';
import '../../repositories/reservation_repository.dart';

class TaskHistoryController extends GetxController {
  List<Reservation> _taskHistoryList = [];
  bool isLoading = true;

  List<Reservation> get ongoingTasks => _taskHistoryList.where((element) => element.status == RequestStatus.confirmed).toList();
  List<Reservation> get pendingTasks => _taskHistoryList.where((element) => element.status == RequestStatus.pending).toList();
  List<Reservation> get finishedTasks => _taskHistoryList.where((element) => element.status == RequestStatus.finished).toList();
  List<Reservation> get rejectedTasks => _taskHistoryList.where((element) => element.status == RequestStatus.rejected).toList();
  bool get hasNoTasksYet => _taskHistoryList.isEmpty;

  TaskHistoryController() {
    init();
  }

  Future<void> init() async {
    _taskHistoryList = await ReservationRepository.find.getUserTasksHistory();
    isLoading = false;
    update();
  }
}
