import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../services/theme/theme.dart';

class EmptyAnimation extends StatelessWidget {
  final String? lottieAsset;
  final String? message;
  final int itemCount;
  final double? height;
  final Widget child;

  const EmptyAnimation({required this.child, required this.itemCount, this.height, this.lottieAsset, this.message, super.key});

  @override
  Widget build(BuildContext context) => itemCount == 0
      ? SizedBox(
          height: height ?? Get.height * 0.6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: Paddings.exceptional),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(scale: 2, child: Lottie.asset(lottieAsset ?? Assets.emptyAnimation, width: 150)),
                    const SizedBox(height: Paddings.exceptional * 2),
                    Align(alignment: Alignment.center, child: Text(message ?? 'no_data_here'.tr, style: AppFonts.x16Bold.copyWith(color: kNeutralColor)))
                  ],
                ),
              ),
            ),
          ),
        )
      : child;
}
