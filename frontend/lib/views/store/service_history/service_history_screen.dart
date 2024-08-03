import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/sizes.dart';
import '../../../models/booking.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/booking_card.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
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
        builder: (controller) => CustomScaffoldBottomNavigation(
          onBack: () => ProfileController.find.init(),
          appBarTitle: 'Service History',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.hasNoServicesYet
                ? const Center(child: Text('You haven\'t done any service yet!', style: AppFonts.x14Regular))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                      child: Column(
                        children: [
                          buildStatusServiceGroup(
                            'Ongoing Services',
                            controller.ongoingServices,
                            initiallyOpen: true,
                            onMarkDone: (booking) => controller.markBookingAsDone(booking),
                          ),
                          buildStatusServiceGroup('Pending Services', controller.pendingServices, initiallyOpen: true),
                          buildStatusServiceGroup('Finished Services', controller.finishedServices),
                          buildStatusServiceGroup('Rejected Services', controller.rejectedServices),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildStatusServiceGroup(String title, List<Booking> bookings, {void Function(Booking)? onMarkDone, bool initiallyOpen = false}) {
    return bookings.isNotEmpty
        ? Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: initiallyOpen,
              title: Text(title, style: AppFonts.x15Bold),
              children: List.generate(
                bookings.length,
                (index) => BookingCard(booking: bookings[index], onMarkDone: () => onMarkDone?.call(bookings[index])),
              ),
            ),
          )
        : const SizedBox();
  }
}
