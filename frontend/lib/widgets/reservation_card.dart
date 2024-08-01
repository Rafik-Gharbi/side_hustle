import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../models/reservation.dart';
import '../services/theme/theme.dart';
import 'task_card.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  const ReservationCard({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
        shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
        tileColor: kNeutralLightOpacityColor,
        splashColor: kPrimaryOpacityColor,
        title: TaskCard(task: reservation.task, dense: true),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Paddings.regular),
            Text('My note: ${reservation.note.isEmpty ? 'not provided' : reservation.note}', style: AppFonts.x14Regular),
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
            // TODO Add task owner review for the user if task is finished
          ],
        ),
      ),
    );
  }
}
