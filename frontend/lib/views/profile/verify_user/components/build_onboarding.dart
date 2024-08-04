import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../services/theme/theme.dart';

class BuildOnboarding extends StatelessWidget {
  final Function? onFinish;
  const BuildOnboarding({super.key, this.onFinish});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      headerBackgroundColor: kNeutralColor100,
      finishButtonText: 'Verify',
      onFinish: onFinish,
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
    );
  }
}
