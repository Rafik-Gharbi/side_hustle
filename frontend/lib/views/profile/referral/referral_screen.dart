import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../settings/components/terms_condition_screen.dart';
import 'components/referees_screen.dart';
import 'referral_controller.dart';

class ReferralScreen extends StatelessWidget {
  static const String routeName = '/referral';
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ReferralController>(
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'referrals'.tr,
          actionButton: CustomButtons.icon(
            icon: Icon(Icons.people_alt_outlined, color: kBlackColor),
            onPressed: () => Get.toNamed(RefereesScreen.routeName),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                  child: Stack(
                    children: [
                      Positioned(top: 0, left: 0, child: Icon(Icons.format_quote, color: kPrimaryDark.withOpacity(0.5), size: 28)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge * 2, vertical: Paddings.small),
                        child: Text('referral_quote'.tr, style: AppFonts.x14Regular.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.justify),
                      ),
                      Positioned(bottom: 0, right: 0, child: Transform.rotate(angle: -pi / 1.0, child: Icon(Icons.format_quote, color: kPrimaryDark.withOpacity(0.5), size: 28))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Paddings.large),
                  child: DecoratedBox(
                    decoration: BoxDecoration(borderRadius: smallRadius, color: kAccentColor),
                    child: SizedBox(
                      width: double.infinity,
                      height: 232,
                      child: Padding(
                        padding: const EdgeInsets.all(Paddings.regular),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('refere_earn'.tr, style: AppFonts.x18Bold.copyWith(color: kNeutralColor100)),
                            const SizedBox(height: Paddings.regular),
                            Text('refere_earn_msg'.tr, textAlign: TextAlign.center, style: AppFonts.x14Regular.copyWith(color: kNeutralColor100.withOpacity(0.9))),
                            const SizedBox(height: Paddings.large),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                              child: DecoratedBox(
                                decoration: BoxDecoration(borderRadius: circularRadius, color: kNeutralLightColor.withOpacity(0.4)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: Paddings.large),
                                    Text(
                                      AuthenticationService.find.jwtUserData!.referralCode ?? '',
                                      style: AppFonts.x16Bold.copyWith(color: kNeutralColor100),
                                    ),
                                    const SizedBox(width: Paddings.regular),
                                    CustomButtons.icon(
                                      icon: Icon(Icons.copy_outlined, color: kNeutralColor100),
                                      onPressed: controller.copyCodeToClipboard,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                            CustomButtons.text(
                              onPressed: controller.shareReferralCode,
                              child: DecoratedBox(
                                decoration: BoxDecoration(borderRadius: circularRadius, color: kPrimaryColor.withOpacity(0.8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: Paddings.large),
                                      Icon(Icons.share_outlined, color: kNeutralColor100),
                                      const SizedBox(width: Paddings.regular),
                                      Text('share_with_friends'.tr, style: AppFonts.x16Bold.copyWith(color: kNeutralColor100)),
                                      const SizedBox(width: Paddings.large),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Paddings.exceptional),
                Text('how_it_works'.tr, style: AppFonts.x16Bold),
                const SizedBox(height: Paddings.large),
                ListTile(
                  title: Text('how_it_works_step1'.tr, style: AppFonts.x14Bold),
                  subtitle: Text('how_it_works_step1_subtitle'.tr, softWrap: true, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  leading: CircleAvatar(backgroundColor: kNeutralLightColor, child: Center(child: Text('1', style: AppFonts.x18Bold))),
                ),
                ListTile(
                  title: Text('how_it_works_step2'.tr, style: AppFonts.x14Bold),
                  subtitle: Text('how_it_works_step2_subtitle'.tr, softWrap: true, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  leading: CircleAvatar(backgroundColor: kNeutralLightColor, child: Center(child: Text('2', style: AppFonts.x18Bold))),
                ),
                ListTile(
                  title: Text('how_it_works_step3'.tr, style: AppFonts.x14Bold),
                  subtitle: Text('how_it_works_step3_subtitle'.tr, softWrap: true, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  leading: CircleAvatar(backgroundColor: kNeutralLightColor, child: Center(child: Text('3', style: AppFonts.x18Bold))),
                ),
                ListTile(
                  title: Text('how_it_works_step4'.tr, style: AppFonts.x14Bold),
                  subtitle: Text('how_it_works_step4_subtitle'.tr, softWrap: true, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  leading: CircleAvatar(backgroundColor: kNeutralLightColor, child: Center(child: Text('4', style: AppFonts.x18Bold))),
                ),
                const SizedBox(height: Paddings.small),
                CustomButtons.text(
                  title: 'read_terms_conditions'.tr,
                  titleStyle: AppFonts.x10Regular.copyWith(color: kSelectedDarkColor),
                  onPressed: () => Get.toNamed(TermsConditionScreen.routeName),
                ),
                const SizedBox(height: Paddings.exceptional),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
