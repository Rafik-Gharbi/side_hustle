import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_buttons.dart';
import '../verify_user_controller.dart';

class BuildSelfiePicturePicker extends StatelessWidget {
  const BuildSelfiePicturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<VerifyUserController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Paddings.exceptional),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                child: Center(child: Lottie.asset(Assets.selfieWithIdentityCard, height: 150, fit: BoxFit.contain)),
              ),
              const SizedBox(height: Paddings.exceptional),
              const Text('Please provide a selfie holding your identity document below your head', style: AppFonts.x14Regular),
              const SizedBox(height: Paddings.extraLarge),
              Center(
                child: controller.selfiePicture != null
                    ? ClipRRect(
                        borderRadius: smallRadius,
                        child: InkWell(
                          onTap: () => controller.uploadVerifUserPicture(type: VerifPicture.selfie),
                          child: Image.file(File(controller.selfiePicture!.path), height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
                        ),
                      )
                    : CustomButtons.elevateSecondary(
                        title: 'Open camera',
                        width: (Get.width - 60) / 2,
                        height: (Get.width - 60) / 2,
                        onPressed: () => controller.uploadVerifUserPicture(type: VerifPicture.selfie),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
