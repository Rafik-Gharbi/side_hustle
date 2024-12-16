import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../services/navigation_history_observer.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../profile/user_profile/user_profile_screen.dart';
import '../my_store/my_store_controller.dart';
import '../my_store/my_store_screen.dart';
import 'service_request_controller.dart';

class ServiceRequestScreen extends StatelessWidget {
  static const String routeName = '/service-request';
  const ServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ServiceRequestController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'service_requests'.tr,
          onBack: NavigationHistoryObserver.instance.previousRouteHistory == MyStoreScreen.routeName ? () => MyStoreController.find.init() : null,
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
                            user: reservation.user,
                            requestStatus: reservation.status,
                            isService: true,
                            onAccept: () => controller.acceptProposal(reservation),
                            onReject: () => controller.rejectProposals(reservation),
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
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(reservation.user.name ?? '', style: AppFonts.x16Bold),
                                  // TODO Add user review score
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${'note'.tr}: ${reservation.note.isEmpty ? 'not_provided'.tr : reservation.note}', style: AppFonts.x14Regular),
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
