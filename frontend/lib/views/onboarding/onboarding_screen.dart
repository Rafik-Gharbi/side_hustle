import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../constants/sizes.dart';
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
    return HoldInSafeArea(
      child: StatefulBuilder(
        builder: (context, setState) {
          return IntroductionScreen(
            pages: [
              PageViewModel(
                titleWidget: Text('welcome_to'.tr, style: AppFonts.x16Bold),
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
                titleWidget: Text('with_dootify'.tr, style: AppFonts.x16Bold),
                bodyWidget: Text('delegate_tasks_save_time'.tr, style: AppFonts.x14Regular),
                image: Padding(
                  padding: const EdgeInsets.only(top: Paddings.large),
                  child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.onboarding1, width: Get.width - 30, fit: BoxFit.cover))),
                ),
              ),
              PageViewModel(
                titleWidget: Text('earn_with_skills'.tr, style: AppFonts.x16Bold),
                bodyWidget: Text('offer_services_earn_income'.tr, style: AppFonts.x14Regular),
                image: Padding(
                  padding: const EdgeInsets.only(top: Paddings.large),
                  child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.onboarding2, width: Get.width - 30, fit: BoxFit.cover))),
                ),
              ),
              PageViewModel(
                titleWidget: Text('stay_connected'.tr, style: AppFonts.x16Bold),
                bodyWidget: Text('engage_with_community'.tr, style: AppFonts.x14Regular),
                image: Padding(
                  padding: const EdgeInsets.only(top: Paddings.large),
                  child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.onboarding3, width: Get.width - 30, fit: BoxFit.cover))),
                ),
              ),
            ],
            onDone: () {
              SharedPreferencesService.find.add(isFirstTimeKey, 'false');
              Get.offAllNamed(MainScreenWithBottomNavigation.routeName);
            },
            showSkipButton: true,
            skip: Text('skip'.tr, style: AppFonts.x14Regular.copyWith(color: kDisabledColor)),
            next: const Icon(Icons.arrow_forward),
            done: Text('done'.tr, style: AppFonts.x14Bold),
          );
        },
      ),
    );
  }
}
