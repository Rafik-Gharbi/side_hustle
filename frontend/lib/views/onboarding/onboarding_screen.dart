import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../constants/sizes.dart';
import '../../repositories/params_repository.dart';
import '../../services/shared_preferences.dart';
import '../../services/theme/theme.dart';
import '../../widgets/main_screen_with_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../settings/components/language_selector.dart';
import 'components/logo_animation.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Locale deviceLocale = Localizations.localeOf(context);
    bool isTerms = true;
    RxBool accepted = false.obs;
    return HoldInSafeArea(
      child: StatefulBuilder(
        builder: (context, setState) {
          Future<File?>? future = isTerms ? ParamsRepository.find.getTermsCondition() : ParamsRepository.find.getPrivacyPolicy();
          return Obx(() => IntroductionScreen(
                pages: [
                  PageViewModel(
                    title: 'welcome_to'.tr,
                    bodyWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LogoAnimation(),
                        const SizedBox(height: Paddings.exceptional),
                        Text('choose_prefered_language'.tr, style: AppFonts.x16Bold),
                        const SizedBox(height: Paddings.large),
                        LanguageSelector(selectedLocale: deviceLocale),
                      ],
                    ),
                  ),
                  PageViewModel(
                    title: 'with_dootify'.tr,
                    body: 'delegate_tasks_save_time'.tr,
                    image: Padding(
                      padding: const EdgeInsets.only(top: Paddings.large),
                      child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.onboarding1, width: Get.width - 30, fit: BoxFit.cover))),
                    ),
                  ),
                  PageViewModel(
                    title: 'earn_with_skills'.tr,
                    body: 'offer_services_earn_income'.tr,
                    image: Padding(
                      padding: const EdgeInsets.only(top: Paddings.large),
                      child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.onboarding2, width: Get.width - 30, fit: BoxFit.cover))),
                    ),
                  ),
                  PageViewModel(
                    title: 'stay_connected'.tr,
                    body: 'engage_with_community'.tr,
                    image: Padding(
                      padding: const EdgeInsets.only(top: Paddings.large),
                      child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.onboarding3, width: Get.width - 30, fit: BoxFit.cover))),
                    ),
                  ),
                  PageViewModel(
                    title: isTerms ? 'terms_condition'.tr : 'privacy_policy'.tr,
                    useScrollView: false,
                    bodyWidget: Padding(
                      padding: const EdgeInsets.only(top: Paddings.large),
                      child: FutureBuilder<File?>(
                        future: future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('error_occurred'.tr));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('no_file_available'.tr));
                          } else {
                            return SizedBox(
                              width: Get.width,
                              height: Get.height * 0.65,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(Paddings.small),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(border: regularBorder, borderRadius: smallRadius),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: ClipRRect(borderRadius: smallRadius, child: SfPdfViewer.file(snapshot.data!, pageSpacing: 1)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.small),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minVerticalPadding: 0,
                                    dense: true,
                                    title: RichText(
                                      text: TextSpan(
                                        text: 'by_using_you_agree'.tr,
                                        style: AppFonts.x14Regular,
                                        children: [
                                          TextSpan(
                                            text: 'terms_condition'.tr,
                                            style: AppFonts.x14Regular.copyWith(color: kPrimaryColor),
                                            recognizer: TapGestureRecognizer()..onTap = () => setState(() => isTerms = true),
                                          ),
                                          TextSpan(text: ' ${'and'.tr} ', style: AppFonts.x14Regular),
                                          TextSpan(
                                            text: 'privacy_policy'.tr,
                                            style: AppFonts.x14Regular.copyWith(color: kPrimaryColor),
                                            recognizer: TapGestureRecognizer()..onTap = () => setState(() => isTerms = false),
                                          ),
                                          const TextSpan(text: '.', style: AppFonts.x14Regular),
                                        ],
                                      ),
                                    ),
                                    leading: Checkbox(
                                      checkColor: kNeutralColor100,
                                      value: accepted.value,
                                      onChanged: (value) => accepted.value = !accepted.value,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
                onDone: accepted.value
                    ? () {
                        SharedPreferencesService.find.add(hasAcceptedTCPPKey, accepted.value.toString());
                        SharedPreferencesService.find.add(isFirstTimeKey, 'false');
                        Get.offAllNamed(MainScreenWithBottomNavigation.routeName);
                      }
                    : null,
                showSkipButton: true,
                skip: Text('skip'.tr, style: AppFonts.x14Regular.copyWith(color: kDisabledColor)),
                next: const Icon(Icons.arrow_forward),
                done: accepted.value ? Text('done'.tr, style: AppFonts.x14Bold) : null,
                overrideDone: accepted.value ? null : Align(alignment: Alignment.center, child: Text('done'.tr, style: AppFonts.x14Bold.copyWith(color: kDisabledColor))),
              ));
        },
      ),
    );
  }
}
