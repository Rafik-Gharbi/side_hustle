import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/buildables.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_buttons.dart';
import '../verify_user_controller.dart';

class BuildFinishVerificationProcess extends StatelessWidget {
  const BuildFinishVerificationProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<VerifyUserController>(
        builder: (controller) => Obx(
          () => SingleChildScrollView(
            child: controller.isLoadingDataUpload.value
                ? Column(
                    children: [
                      SizedBox(height: Get.height * 0.2),
                      Buildables.buildLoadingWidget(height: 150),
                      Text('Uploading your document, please wait.', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                      SizedBox(height: Get.height * 0.2),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Paddings.exceptional),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                        child: Center(child: Lottie.asset(controller.uploadDocumentResult! ? Assets.verifyIdentity : Assets.failed, height: 150, fit: BoxFit.contain)),
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Center(child: Text('Verification ${controller.uploadDocumentResult! ? 'Complete' : 'Failed'}!', style: AppFonts.x16Bold)),
                      const SizedBox(height: Paddings.exceptional),
                      if (controller.uploadDocumentResult!) ...[
                        const Text(
                          'Thank you for completing the verification process. Our team will review your provided information and contact you via phone call shortly. Once verified, your profile will be activated.',
                          style: AppFonts.x14Regular,
                        ),
                      ] else ...[
                        const Text('An error has occurred please try again!', style: AppFonts.x14Regular),
                      ],
                      const SizedBox(height: Paddings.regular),
                      const Text('We appreciate your patience and cooperation.', style: AppFonts.x14Regular),
                      const SizedBox(height: Paddings.exceptional * 2),
                      CustomButtons.elevatePrimary(
                        title: 'Back to home',
                        width: Get.width,
                        onPressed: () => MainAppController.find.bottomNavIndex.value = 0,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
