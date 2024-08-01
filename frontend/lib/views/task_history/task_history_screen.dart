import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../models/reservation.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/reservation_card.dart';
import 'task_history_controller.dart';

class TaskHistoryScreen extends StatelessWidget {
  static const String routeName = '/task-history';
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<TaskHistoryController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'Task History',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.hasNoTasksYet
                ? const Center(child: Text('You haven\'t done any task yet!', style: AppFonts.x14Regular))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                      child: Column(
                        children: [
                          buildStatusTaskGroup('Ongoing Tasks', controller.ongoingTasks, initiallyOpen: true),
                          buildStatusTaskGroup('Pending Tasks', controller.pendingTasks, initiallyOpen: true),
                          buildStatusTaskGroup('Finished Tasks', controller.finishedTasks),
                          buildStatusTaskGroup('Rejected Tasks', controller.rejectedTasks),
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
        ? Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: initiallyOpen,
              title: Text(title, style: AppFonts.x15Bold),
              children: List.generate(
                reservations.length,
                (index) => ReservationCard(reservation: reservations[index]),
              ),
            ),
          )
        : const SizedBox();
  }
}
