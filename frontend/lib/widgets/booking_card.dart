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

  const BookingCard({super.key, required this.booking, this.store, this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
        shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
        tileColor: kNeutralLightOpacityColor,
        splashColor: kPrimaryOpacityColor,
        title: ServiceCard(service: booking.service, store: store, bookingStatus: booking.status, onMarkDone: onMarkDone, dense: true),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Paddings.regular),
            Text('My note: ${booking.note.isEmpty ? 'not provided' : booking.note}', style: AppFonts.x14Regular),
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
            // TODO Add task owner review for the user if task is finished
          ],
        ),
      ),
    );
  }
}
