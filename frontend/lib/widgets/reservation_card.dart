import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../models/reservation.dart';
import '../services/theme/theme.dart';
import 'task_card.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final bool isHighlited;
  const ReservationCard({super.key, required this.reservation, this.isHighlited = false});

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
          title: TaskCard(task: reservation.task!, dense: true),
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
              // TODO Add task owner review for the user if task is finished
            ],
          ),
        ),
      );
    });
  }
}
