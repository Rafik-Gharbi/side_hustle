import 'package:flutter/material.dart';

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
        const Text(
          'A 60-second timer has been started.\nYour photo from the chosen document will be compared with your selfie.',
          style: AppFonts.x14Regular,
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: Paddings.exceptional),
        ListTile(
          onTap: () => onIdentityCardSelected?.call(),
          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(width: 0.4, color: kNeutralColor)),
          title: const Text('Identity Card', style: AppFonts.x14Bold),
          leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: const Icon(Icons.badge_outlined)),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
        const SizedBox(height: Paddings.regular),
        ListTile(
          onTap: () => onPassportSelected?.call(),
          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(width: 0.4, color: kNeutralColor)),
          title: const Text('Passport', style: AppFonts.x14Bold),
          leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: const Icon(Icons.airplane_ticket_outlined)),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
