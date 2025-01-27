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
import '../../../../widgets/main_screen_with_bottom_navigation.dart';
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
                      Text('uploading_wait'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
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
                      Center(child: Text('${'verification'.tr} ${controller.uploadDocumentResult! ? 'complete'.tr : 'failed'.tr}!', style: AppFonts.x16Bold)),
                      const SizedBox(height: Paddings.exceptional),
                      if (controller.uploadDocumentResult!)
                        Text('verification_completed_msg'.tr, style: AppFonts.x14Regular)
                      else
                        Text('error_occurred'.tr, style: AppFonts.x14Regular),
                      const SizedBox(height: Paddings.regular),
                      Text('appreciate_patience_cooperation'.tr, style: AppFonts.x14Regular),
                      const SizedBox(height: Paddings.exceptional * 2),
                      if (!controller.hasEnabledNotification) ...[
                        CustomButtons.elevatePrimary(
                          title: 'enable_notifications'.tr,
                          width: Get.width,
                          onPressed: controller.enableNotifications,
                        ),
                        const SizedBox(height: Paddings.regular),
                      ],
                      CustomButtons.elevateSecondary(
                        title: 'back_home'.tr,
                        width: Get.width,
                        onPressed: () {
                          Get.offAllNamed(MainScreenWithBottomNavigation.routeName);
                          MainAppController.find.bottomNavIndex.value = 0;
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
