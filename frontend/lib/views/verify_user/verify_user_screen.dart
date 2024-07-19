import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/buildables.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import 'verify_user_controller.dart';

class VerifyUserScreen extends StatelessWidget {
  static const String routeName = '/verify-user';
  const VerifyUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<VerifyUserController>(
        builder: (controller) => PopScope(
          onPopInvoked: (didPop) => didPop ? controller.clearData() : null,
          child: CustomScaffoldBottomNavigation(
            appBarTitle: 'Verify User',
            onBack: controller.clearData,
            body: Padding(
              padding: const EdgeInsets.only(bottom: Paddings.exceptional),
              child: controller.isOnBoarding
                  ? OnBoardingSlider(
                      headerBackgroundColor: kNeutralColor100,
                      finishButtonText: 'Verify',
                      onFinish: controller.startVerification,
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
                                const Center(child: Text('Verify Your Identity', style: AppFonts.x16Bold)),
                                const SizedBox(height: Paddings.exceptional),
                                const Text(
                                  'To create your account, we need to verify your identity. This helps us ensure the security of our platform and comply with financial regulations.',
                                  style: AppFonts.x14Regular,
                                ),
                                const SizedBox(height: Paddings.regular),
                                const Text(
                                  'Please follow the steps to complete the verification process. Together, we can build a secure and trustworthy service.',
                                  style: AppFonts.x14Regular,
                                ),
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
                                const Center(child: Text('Verify identity steps', style: AppFonts.x16Bold)),
                                const SizedBox(height: Paddings.exceptional),
                                const Text('In order to verify your identity we need to go through these 2 steps:', style: AppFonts.x14Regular),
                                const SizedBox(height: Paddings.regular),
                                const Text('\t1. Scan your identity document.', style: AppFonts.x14Bold),
                                const Text(
                                  '\t\tBefore you start, make sure your identity card or your passport is with you. You will need to scan it during the process.',
                                  style: AppFonts.x14Regular,
                                ),
                                const SizedBox(height: Paddings.regular),
                                const Text('\t2. Take a selfie with your identity document.', style: AppFonts.x14Bold),
                                const Text('\t\tYour face has to be well lit. Make sure you don\'t have any background lights.', style: AppFonts.x14Regular),
                                const SizedBox(height: Paddings.exceptional),
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
                                const Center(child: Text('Start identification', style: AppFonts.x16Bold)),
                                const SizedBox(height: Paddings.exceptional),
                                const Text(
                                  'Finally, be aware with the 60 second timer is going to start. Please make sure to complete this process within that time box.',
                                  style: AppFonts.x14Regular,
                                ),
                                const SizedBox(height: Paddings.exceptional),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(Paddings.large),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.documentType == null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Paddings.exceptional),
                                const Text(
                                  'A 60-second timer has been started.\nYour photo from the chosen document will be compared with your selfie.',
                                  style: AppFonts.x14Regular,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: Paddings.exceptional),
                                ListTile(
                                  onTap: () => controller.setDocumentType(DocumentType.identityCard),
                                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(width: 0.4, color: kNeutralColor)),
                                  title: const Text('Identity Card', style: AppFonts.x14Bold),
                                  leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: const Icon(Icons.badge_outlined)),
                                  trailing: const Icon(Icons.chevron_right_rounded),
                                ),
                                const SizedBox(height: Paddings.regular),
                                ListTile(
                                  onTap: () => controller.setDocumentType(DocumentType.passport),
                                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(width: 0.4, color: kNeutralColor)),
                                  title: const Text('Passport', style: AppFonts.x14Bold),
                                  leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: const Icon(Icons.airplane_ticket_outlined)),
                                  trailing: const Icon(Icons.chevron_right_rounded),
                                ),
                              ],
                            )
                          else if (!controller.hasProvidedDocument)
                            Column(
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
                                                child: Image.file(File(controller.frontIdentityPicture!.path),
                                                    height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
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
                                                child: Image.file(File(controller.backIdentityPicture!.path),
                                                    height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
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
                                              child:
                                                  Image.file(File(controller.passportPicture!.path), height: (Get.width - 60) / 2, width: (Get.width - 60) / 2, fit: BoxFit.cover),
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
                            )
                          else if (controller.selfiePicture == null)
                            Column(
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
                            )
                          else if (controller.verifProcessIsGood)
                            Obx(
                              () => controller.isLoadingDataUpload.value
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
                                          child: Center(
                                              child: Lottie.asset(controller.uploadDocumentResult! ? Assets.verifyIdentity : Assets.failed, height: 150, fit: BoxFit.contain)),
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
                          const Spacer(),
                          if (controller.showTimer)
                            Obx(
                              () => Column(
                                children: [
                                  Container(height: 2, width: (Get.width - 30) / 60 * controller.timerProgress.value.toDouble(), color: kNeutralColor),
                                  Center(
                                    child: Text(
                                      '${controller.timerProgress} seconds left',
                                      style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
