import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../services/theme/theme.dart';

class BuildIdentityDocumentChooser extends StatelessWidget {
  final void Function()? onIdentityCardSelected;
  final void Function()? onPassportSelected;
  const BuildIdentityDocumentChooser({super.key, this.onIdentityCardSelected, this.onPassportSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Paddings.exceptional),
        Text('timer_started'.tr, style: AppFonts.x14Regular, textAlign: TextAlign.justify),
        const SizedBox(height: Paddings.exceptional),
        ListTile(
          onTap: () => onIdentityCardSelected?.call(),
          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: const BorderSide(width: 0.4, color: kNeutralColor)),
          title: Text('identity_card'.tr, style: AppFonts.x14Bold),
          leading: const CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: Icon(Icons.badge_outlined)),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
        const SizedBox(height: Paddings.regular),
        ListTile(
          onTap: () => onPassportSelected?.call(),
          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: const BorderSide(width: 0.4, color: kNeutralColor)),
          title: Text('passport'.tr, style: AppFonts.x14Bold),
          leading: const CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: Icon(Icons.airplane_ticket_outlined)),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
