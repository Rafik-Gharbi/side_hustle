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

class BuildDocumentFilesPicker extends StatelessWidget {
  const BuildDocumentFilesPicker({super.key});

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
                child: Center(child: Lottie.asset(Assets.scanIdentityCard, height: 150, fit: BoxFit.contain)),
              ),
              const SizedBox(height: Paddings.exceptional),
              if (controller.documentType == DocumentType.identityCard) ...[
                const Text('Please provide a photo of the front and back of your identity card', style: AppFonts.x14Regular),
                const SizedBox(height: Paddings.extraLarge),
                Row(
                  children: [
                    Column(
                      children: [
                        if (controller.frontIdentityPicture != null)
                          ClipRRect(
                            borderRadius: smallRadius,
                            child: InkWell(
                              onTap: () => controller.uploadVerifUserPicture(type: VerifPicture.frontIdentity),
                              child: Image.file(File(controller.frontIdentityPicture!.path), height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
                            ),
                          )
                        else
                          CustomButtons.elevateSecondary(
                            title: 'Open camera',
                            width: (Get.width - 60) / 2,
                            height: (Get.width - 60) / 2,
                            onPressed: () => controller.uploadVerifUserPicture(type: VerifPicture.frontIdentity),
                          ),
                        const SizedBox(height: Paddings.regular),
                        const Text('Front picture', style: AppFonts.x12Bold),
                      ],
                    ),
                    const VerticalDivider(),
                    Column(
                      children: [
                        if (controller.backIdentityPicture != null)
                          ClipRRect(
                            borderRadius: smallRadius,
                            child: InkWell(
                              onTap: () => controller.uploadVerifUserPicture(type: VerifPicture.backIdentity),
                              child: Image.file(File(controller.backIdentityPicture!.path), height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
                            ),
                          )
                        else
                          CustomButtons.elevateSecondary(
                            title: 'Open camera',
                            width: (Get.width - 60) / 2,
                            height: (Get.width - 60) / 2,
                            onPressed: () => controller.uploadVerifUserPicture(type: VerifPicture.backIdentity),
                          ),
                        const SizedBox(height: Paddings.regular),
                        const Text('Back picture', style: AppFonts.x12Bold),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                const Text('Please provide a photo of your passport main page', style: AppFonts.x14Regular),
                const SizedBox(height: Paddings.extraLarge),
                Center(
                  child: controller.passportPicture != null
                      ? ClipRRect(
                          borderRadius: smallRadius,
                          child: InkWell(
                            onTap: () => controller.uploadVerifUserPicture(type: VerifPicture.passport),
                            child: Image.file(File(controller.passportPicture!.path), height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
                          ),
                        )
                      : CustomButtons.elevateSecondary(
                          title: 'Open camera',
                          width: (Get.width - 60) / 2,
                          height: (Get.width - 60) / 2,
                          onPressed: () => controller.uploadVerifUserPicture(type: VerifPicture.passport),
                        ),
                ),
              ],
              const SizedBox(height: Paddings.exceptional),
            ],
          ),
        ),
      ),
    );
  }
}