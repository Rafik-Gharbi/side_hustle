import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../../helpers/buildables.dart';
import '../../../../../../services/theme/theme.dart';

class ThreeStatsOverview extends StatelessWidget {
  final int leftNumber;
  final String leftLabel;
  final int? rightNumber;
  final String? rightLabel;
  final int? middleNumber;
  final String? middleLabel;

  const ThreeStatsOverview({
    super.key,
    required this.leftNumber,
    required this.leftLabel,
    this.rightNumber,
    this.rightLabel,
    this.middleNumber,
    this.middleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: LayoutBuilder(
        builder: (context, constraints) => DecoratedBox(
          decoration: BoxDecoration(
            color: kNeutralColor100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(Paddings.small),
            child: SizedBox(
              width: Get.width,
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(leftLabel, textAlign: TextAlign.center, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                        Text('$leftNumber', textAlign: TextAlign.center, style: AppFonts.x24Bold.copyWith(color: kSecondaryColor)),
                      ],
                    ),
                  ),
                  if (rightLabel != null || middleLabel != null)
                    Buildables.verticalDivider(
                      height: constraints.maxHeight,
                      color: kNeutralOpacityColor,
                      thickness: 3,
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                    ),
                  if (middleLabel != null && middleNumber != null) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(middleLabel!, textAlign: TextAlign.center, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                          Text('$middleNumber', textAlign: TextAlign.center, style: AppFonts.x24Bold.copyWith(color: kPrimaryColor)),
                        ],
                      ),
                    ),
                    Buildables.verticalDivider(
                      height: constraints.maxHeight,
                      color: kNeutralOpacityColor,
                      thickness: 3,
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                    ),
                  ],
                  if (rightLabel != null && rightNumber != null) ...[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(rightLabel!, textAlign: TextAlign.center, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                          Text('$rightNumber', textAlign: TextAlign.center, style: AppFonts.x24Bold.copyWith(color: kAccentColor)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
