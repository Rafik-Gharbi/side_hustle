import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../profile/user_profile/user_profile_screen.dart';
import 'task_proposal_controller.dart';

class TaskProposalScreen extends StatelessWidget {
  static const String routeName = '/task-proposal';
  const TaskProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<TaskProposalController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'Task Proposals',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.reservationList.isEmpty
                ? const Center(child: Text('We found nothing!', style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.reservationList.length,
                    itemBuilder: (context, index) {
                      final reservation = controller.reservationList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                        child: OpenContainer<bool>(
                          closedElevation: 0,
                          transitionDuration: const Duration(milliseconds: 600),
                          onClosed: (data) => data != null && data ? Future.delayed(const Duration(milliseconds: 600), () => controller.init()) : null,
                          openBuilder: (_, __) => UserProfileScreen(
                            user: reservation.user,
                            requestStatus: reservation.status,
                            onAccept: () => controller.acceptProposal(reservation),
                            onReject: () => controller.rejectProposals(reservation),
                          ),
                          closedBuilder: (_, openContainer) => Padding(
                            padding: const EdgeInsets.only(bottom: Paddings.regular),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                              shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                              tileColor: kNeutralLightOpacityColor,
                              splashColor: kPrimaryOpacityColor,
                              onTap: openContainer,
                              title: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(reservation.user.name ?? '', style: AppFonts.x16Bold),
                                  // TODO Add user review score
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Note: ${reservation.note.isEmpty ? 'not provided' : reservation.note}', style: AppFonts.x14Regular),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
