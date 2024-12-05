import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/buildables.dart';
import '../helpers/helper.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_dialog.dart';

class CustomPopup extends CustomDialog {
  final String? title;
  final String content;
  final Function onPressed;
  final Function? onCancel;
  final bool reverseButtons;

  const CustomPopup({
    required this.content,
    required this.onPressed,
    this.title,
    this.onCancel,
    this.reverseButtons = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(RadiusSize.regular))),
      backgroundColor: kNeutralColor100,
      insetPadding: const EdgeInsets.all(Paddings.large),
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      content: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(RadiusSize.large)),
        child: SizedBox(
          width: Get.width - 2 * Paddings.large,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                const SizedBox(height: Paddings.regular),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Paddings.small, horizontal: Paddings.large),
                  child: Text(title!, style: AppFonts.x16Bold),
                ),
                Buildables.lightDivider(),
              ],
              const SizedBox(height: Paddings.regular),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                child: Text(content, style: AppFonts.x14Regular, textAlign: TextAlign.justify),
              ),
              const SizedBox(height: Paddings.large),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (reverseButtons) ...[
                      CustomButtons.elevatePrimary(
                        onPressed: onCancel == null ? () => Navigator.pop(context) : () => onCancel?.call(),
                        title: 'no'.tr,
                        titleStyle: AppFonts.x12Regular.copyWith(color: kNeutralColor100),
                        height: 35,
                        width: 80,
                      ),
                      const SizedBox(width: Paddings.regular),
                      CustomButtons.elevateSecondary(
                        onPressed: () {
                          onPressed.call();
                          Helper.goBack();
                        },
                        title: 'yes'.tr,
                        titleStyle: AppFonts.x12Regular.copyWith(color: kPrimaryColor),
                        height: 35,
                        width: 80,
                      ),
                    ] else ...[
                      CustomButtons.elevateSecondary(
                        onPressed: onCancel == null ? () => Navigator.pop(context) : () => onCancel?.call(),
                        title: 'no'.tr,
                        titleStyle: AppFonts.x12Regular,
                        height: 35,
                        width: 80,
                      ),
                      const SizedBox(width: Paddings.regular),
                      CustomButtons.elevatePrimary(
                        onPressed: () {
                          onPressed.call();
                          Helper.goBack();
                        },
                        title: 'yes'.tr,
                        titleStyle: AppFonts.x12Regular.copyWith(color: kPrimaryColor),
                        height: 35,
                        width: 80,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: Paddings.regular),
            ],
          ),
        ),
      ),
    );
  }
}
