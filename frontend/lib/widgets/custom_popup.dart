import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_dialog.dart';

class CustomPopup extends CustomDialog {
  final String? title;
  final String content;
  final Function onPressed;
  final Function? onCancel;

  const CustomPopup({
    required this.content,
    required this.onPressed,
    this.title,
    this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(RadiusSize.regular)),
      ),
      backgroundColor: kNeutralColor100,
      insetPadding: const EdgeInsets.all(Paddings.small),
      elevation: 0,
      contentPadding: const EdgeInsets.all(Paddings.large),
      title: title != null ? Text(title!) : null,
      content: Container(
        width: 284,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(RadiusSize.large)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Paddings.small),
            Text(
              content,
              style: AppFonts.x16Regular,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: Paddings.large),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                    Get.back();
                  },
                  title: 'yes'.tr,
                  titleStyle: AppFonts.x12Regular.copyWith(color: kPrimaryColor),
                  height: 35,
                  width: 80,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
