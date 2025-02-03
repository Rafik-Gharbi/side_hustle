import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../services/theme/theme.dart';
import '../verify_user_controller.dart';

class BuildOnboarding extends StatelessWidget {
  final Function? onFinish;
  const BuildOnboarding({super.key, this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OnBoardingSlider(
          headerBackgroundColor: kNeutralColor100,
          finishButtonStyle: const FinishButtonStyle(backgroundColor: Colors.transparent),
          controllerColor: kNeutralColor,
          hasSkip: true,
          skipTextButton: Text('skip'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
          background: const [
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
          totalPage: 3,
          speed: 1.8,
          pageBodies: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Paddings.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                      child: Center(child: Lottie.asset(Assets.verifyIdentity, height: 150, fit: BoxFit.contain)),
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    Center(child: Text('verify_identity'.tr, style: AppFonts.x16Bold)),
                    const SizedBox(height: Paddings.exceptional),
                    Text('verify_identity_msg'.tr, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.regular),
                    Text('verify_identity_msg2'.tr, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.exceptional * 2),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Paddings.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                      child: Center(child: Lottie.asset(Assets.verifyIdentity, height: 150, fit: BoxFit.contain)),
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    Center(child: Text('verify_steps'.tr, style: AppFonts.x16Bold)),
                    const SizedBox(height: Paddings.exceptional),
                    Text('verify_steps_msg'.tr, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.regular),
                    Text('scan_identity'.tr, style: AppFonts.x14Bold),
                    Text('scan_identity_msg'.tr, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.regular),
                    Text('take_selfie'.tr, style: AppFonts.x14Bold),
                    Text('take_selfie_msg'.tr, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                ),
              ),
            ),
            GetBuilder<VerifyUserController>(
              builder: (controller) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Paddings.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                        child: Center(child: Lottie.asset(Assets.verifyIdentity, height: 150, fit: BoxFit.contain)),
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Text('choose_document'.tr, style: AppFonts.x14Regular),
                      const SizedBox(height: Paddings.exceptional),
                      ListTile(
                        onTap: () {
                          controller.setDocumentType(DocumentType.identityCard);
                          onFinish?.call();
                        },
                        shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(width: 0.4, color: kNeutralColor)),
                        title: Text('identity_card'.tr, style: AppFonts.x14Bold),
                        leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: const Icon(Icons.badge_outlined)),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                      const SizedBox(height: Paddings.regular),
                      ListTile(
                        onTap: () {
                          controller.setDocumentType(DocumentType.passport);
                          onFinish?.call();
                        },
                        shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(width: 0.4, color: kNeutralColor)),
                        title: Text('passport'.tr, style: AppFonts.x14Bold),
                        leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: const Icon(Icons.airplane_ticket_outlined)),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Disable onFinish button
        Positioned(bottom: 0, child: InkWell(child: SizedBox(width: Get.width, height: 120)))
      ],
    );
  }
}
