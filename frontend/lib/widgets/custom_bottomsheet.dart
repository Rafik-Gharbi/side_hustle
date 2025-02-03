import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';

class CustomBottomsheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final double? height;
  final double? topRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomBottomsheet({super.key, required this.child, this.height, this.margin, this.padding, this.topRadius, this.title});

  Future<void> showBottomSheet({bool isScrollControlled = false}) async => await Get.bottomSheet(this, isScrollControlled: isScrollControlled);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        height: height != null ? height! + 15 : null,
        child: Material(
          color: kNeutralColor100,
          borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius ?? 30)),
          child: Column(
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(Paddings.regular),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Text(title ?? '', style: AppFonts.x16Bold),
                      CustomButtons.icon(icon: Icon(Icons.close, color: kBlackColor), onPressed: Helper.goBack),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(Paddings.large),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
