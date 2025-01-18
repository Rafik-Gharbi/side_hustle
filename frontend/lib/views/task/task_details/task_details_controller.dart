import 'package:get/get.dart';

import '../../../models/reservation.dart';
import '../../../models/task.dart';
import '../../../models/user.dart';
import '../../../repositories/reservation_repository.dart';
import '../../../repositories/task_repository.dart';

class TaskDetailsController extends GetxController {
  final Task task;
  RxInt condidates = 0.obs;
  RxBool isUserConfirmedTaskSeeker = false.obs;
  Rx<User?> confirmedTaskUser = User().obs;
  Reservation? reservation;

  TaskDetailsController(this.task) {
    init();
  }

  Future<void> init() async {
    final result = await ReservationRepository.find.getTaskReservationDetails(task);
    condidates.value = result?.condidates ?? 0;
    isUserConfirmedTaskSeeker.value = result?.isUserTaskSeeker ?? false;
    confirmedTaskUser.value = result?.confirmedTaskUser ?? User();
    reservation = result?.reservation;
  }

  Future<void> getTaskUpdate() async {
    if (task.id == null) return;
    final result = await TaskRepository.find.getTaskById(task.id!);
    if (result != null) {
      task.updateFields(result);
      update();
    }
  }
}
