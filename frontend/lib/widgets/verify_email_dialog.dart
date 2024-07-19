import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';

class VerifyEmailDialog extends StatelessWidget {
  const VerifyEmailDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: kNeutralColor100,
        surfaceTintColor: Colors.transparent,
        content: SizedBox(
          height: 350,
          width: 350,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                child: Center(child: Lottie.asset(Assets.emailVerify, height: 150, fit: BoxFit.contain)),
              ),
              Center(child: Text('email_verify_msg'.tr, style: AppFonts.x14Regular)),
              const SizedBox(height: Paddings.exceptional),
              CustomButtons.elevatePrimary(
                onPressed: Get.back,
                width: 150,
                title: 'ok'.tr,
              ),
              const Spacer(),
            ],
          ),
        ),
      );
}
