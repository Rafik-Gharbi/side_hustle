import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../models/reservation.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/task_card.dart';
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
    );
  }

  Widget buildStatusTaskGroup(String title, List<Reservation> tasks, {bool initiallyOpen = false}) {
    return tasks.isNotEmpty
        ? Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: initiallyOpen,
              title: Text(title, style: AppFonts.x15Bold),
              children: List.generate(
                tasks.length,
                (index) {
                  final reservation = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                      shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                      tileColor: kNeutralLightOpacityColor,
                      splashColor: kPrimaryOpacityColor,
                      title: TaskCard(task: reservation.task, dense: true),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Paddings.regular),
                          Text('My note: ${reservation.note.isEmpty ? 'not provided' : reservation.note}', style: AppFonts.x14Regular),
                          const SizedBox(height: Paddings.regular),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(Helper.formatDate(reservation.date), style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: Paddings.regular),
                                child: Text(reservation.status.value, style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
                              ),
                            ],
                          ),
                          // TODO Add task owner review for the user if task is finished
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : const SizedBox();
  }
}
