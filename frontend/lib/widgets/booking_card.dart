import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../models/booking.dart';
import '../models/store.dart';
import '../services/theme/theme.dart';
import 'service_card.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final Store? store;
  final void Function()? onMarkDone;
  final bool isHighlited;

  const BookingCard({super.key, required this.booking, this.store, this.onMarkDone, this.isHighlited = false});

  @override
  Widget build(BuildContext context) {
    bool highlighted = false;
    bool isInitialized = false;

    return StatefulBuilder(builder: (context, setState) {
      if (context.mounted && !isInitialized) Future.delayed(const Duration(microseconds: 600), () => setState(() => highlighted = isHighlited));
      isInitialized = true;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
          shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
          tileColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
          splashColor: kPrimaryOpacityColor,
          title: ServiceCard(service: booking.service, store: store, bookingStatus: booking.status, onMarkDone: onMarkDone, dense: true),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Paddings.regular),
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
              // TODO Add task owner review for the user if service is finished
            ],
          ),
        ),
      );
    });
  }
}
