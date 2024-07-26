import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../user_profile/user_profile_screen.dart';
import 'service_request_controller.dart';

class ServiceRequestScreen extends StatelessWidget {
  static const String routeName = '/service-request';
  const ServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ServiceRequestController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'Service Requests',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.bookingList.isEmpty
                ? const Center(child: Text('We found nothing!', style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.bookingList.length,
                    itemBuilder: (context, index) {
                      final booking = controller.bookingList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                        child: OpenContainer<bool>(
                          closedElevation: 0,
                          transitionDuration: const Duration(milliseconds: 600),
                          onClosed: (data) => data != null && data ? Future.delayed(const Duration(milliseconds: 600), () => controller.init()) : null,
                          openBuilder: (_, __) => UserProfileScreen(
                            user: booking.user,
                            requestStatus: booking.status,
                            onAccept: () => controller.acceptProposal(booking),
                            onReject: () => controller.rejectProposals(booking),
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
                                  Text(booking.user.name ?? '', style: AppFonts.x16Bold),
                                  // TODO Add user review score
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Note: ${booking.note.isEmpty ? 'not provided' : booking.note}', style: AppFonts.x14Regular),
                                  const SizedBox(height: Paddings.regular),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(Helper.formatDate(booking.date), style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: Paddings.regular),
                                        child: Text(booking.status.value, style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
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
