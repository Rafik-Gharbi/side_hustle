import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../models/reservation.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/booking_card.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../profile/profile_screen/profile_controller.dart';
import 'service_history_controller.dart';

class ServiceHistoryScreen extends StatelessWidget {
  static const String routeName = '/service-history';
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ServiceHistoryController>(
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          onBack: () => ProfileController.find.init(),
          title: 'service_history'.tr,
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.hasNoServicesYet
                ? Center(child: Text('done_no_service_yet'.tr, style: AppFonts.x14Regular))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                      child: Column(
                        children: [
                          buildStatusServiceGroup(
                            'ongoing_services'.tr,
                            controller.ongoingServices,
                            initiallyOpen: true,
                            onMarkDone: (booking) => controller.markServiceReservationAsDone(booking),
                          ),
                          buildStatusServiceGroup('pending_services'.tr, controller.pendingServices, initiallyOpen: true),
                          buildStatusServiceGroup('finished_services'.tr, controller.finishedServices),
                          buildStatusServiceGroup('rejected_services'.tr, controller.rejectedServices),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildStatusServiceGroup(String title, List<Reservation> bookings, {void Function(Reservation)? onMarkDone, bool initiallyOpen = false}) {
    return bookings.isNotEmpty
        ? GetBuilder<ServiceHistoryController>(
            builder: (controller) => Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: initiallyOpen,
                title: Text(title, style: AppFonts.x15Bold),
                children: List.generate(
                  bookings.length,
                  (index) => BookingCard(
                      reservation: bookings[index], onMarkDone: () => onMarkDone?.call(bookings[index]), isHighlited: controller.highlightedReservation?.id == bookings[index].id),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
