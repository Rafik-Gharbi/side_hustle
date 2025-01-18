import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_standard_scaffold.dart';
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
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'task_proposals'.tr,
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.reservationList.isEmpty
                ? Center(child: Text('found_nothing'.tr, style: AppFonts.x14Regular))
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
                            user: reservation.provider,
                            reservation: reservation,
                            requestStatus: reservation.status,
                            onAccept: () => controller.acceptProposal(reservation),
                            onReject: () => controller.rejectProposals(reservation),
                            onMarkDone: () => controller.markDoneProposals(reservation),
                          ),
                          closedBuilder: (_, openContainer) => Padding(
                            padding: const EdgeInsets.only(bottom: Paddings.regular),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                              shape: RoundedRectangleBorder(borderRadius: smallRadius, side: const BorderSide(color: kNeutralLightColor)),
                              tileColor: kNeutralLightOpacityColor,
                              splashColor: kPrimaryOpacityColor,
                              onTap: openContainer,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(reservation.provider.name ?? '', style: AppFonts.x16Bold),
                                  // user rating
                                  Row(
                                    children: [
                                      Text(Helper.formatAmount(reservation.provider.rating), style: AppFonts.x16Bold),
                                      const SizedBox(width: Paddings.small),
                                      const Icon(Icons.star, color: Colors.amber),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${'note'.tr}: ${reservation.note.isEmpty ? 'not_provided'.tr : reservation.note}', style: AppFonts.x14Regular),
                                  if (reservation.proposedPrice != null && reservation.proposedPrice! > 0)
                                    Text('${'proposed_price'.tr}: ${reservation.proposedPrice}', style: AppFonts.x14Regular),
                                  if (reservation.dueDate != null) Text('${'due_date'.tr}: ${Helper.formatDate(reservation.dueDate!)}', style: AppFonts.x14Regular),
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
                                        child: Text(reservation.status.value.tr, style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
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
