import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../models/reservation.dart';
import '../models/store.dart';
import '../services/theme/theme.dart';
import 'service_card.dart';

class BookingCard extends StatelessWidget {
  final Reservation reservation;
  final Store? store;
  final void Function()? onMarkDone;
  final bool isHighlited;

  const BookingCard({super.key, required this.reservation, this.store, this.onMarkDone, this.isHighlited = false});

  @override
  Widget build(BuildContext context) {
    bool highlighted = false;
    bool isInitialized = false;

    return StatefulBuilder(builder: (context, setState) {
      if (context.mounted && !isInitialized) Future.delayed(const Duration(microseconds: 600), () => context.mounted ? setState(() => highlighted = isHighlited) : null);
      isInitialized = true;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
          shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
          tileColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
          splashColor: kPrimaryOpacityColor,
          title: ServiceCard(service: reservation.service!, store: store, bookingStatus: reservation.status, onMarkDone: onMarkDone, dense: true),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Paddings.regular),
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
              // TODO Add task owner review for the user if service is finished
            ],
          ),
        ),
      );
    });
  }
}
