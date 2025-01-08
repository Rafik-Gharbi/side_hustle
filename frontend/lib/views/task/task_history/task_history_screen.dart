import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../models/reservation.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/reservation_card.dart';
import '../../profile/profile_screen/profile_controller.dart';
import 'task_history_controller.dart';

class TaskHistoryScreen extends StatelessWidget {
  static const String routeName = '/task-history';
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<TaskHistoryController>(
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          onBack: () => ProfileController.find.init(),
          title: 'task_history'.tr,
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.hasNoTasksYet
                ? Center(child: Text('done_no_task_yet'.tr, style: AppFonts.x14Regular))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                      child: Column(
                        children: [
                          buildStatusTaskGroup('ongoing_tasks'.tr, controller.ongoingTasks, initiallyOpen: true),
                          buildStatusTaskGroup('pending_tasks'.tr, controller.pendingTasks, initiallyOpen: true),
                          buildStatusTaskGroup('finished_tasks'.tr, controller.finishedTasks),
                          buildStatusTaskGroup('rejected_tasks'.tr, controller.rejectedTasks),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildStatusTaskGroup(String title, List<Reservation> reservations, {bool initiallyOpen = false}) {
    return reservations.isNotEmpty
        ? GetBuilder<TaskHistoryController>(
            builder: (controller) => Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: initiallyOpen,
                title: Text(title, style: AppFonts.x15Bold),
                children: List.generate(
                  reservations.length,
                  (index) => ReservationCard(reservation: reservations[index], isHighlited: controller.highlightedReservation?.id == reservations[index].id),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
