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
import '../../widgets/hold_in_safe_area.dart';
import '../home/home_screen.dart';
import '../settings/components/language_selector.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Locale deviceLocale = Localizations.localeOf(context);
    return HoldInSafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'welcome_dootify'.tr,
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('choose_prefered_language'.tr, style: AppFonts.x16Bold),
                const SizedBox(height: Paddings.large),
                LanguageSelector(selectedLocale: deviceLocale),
              ],
            ),
          ),
          PageViewModel(
            title: 'welcome_dootify'.tr,
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
        ],
        onDone: () {
          SharedPreferencesService.find.add(isFirstTimeKey, 'false');
          Get.toNamed(HomeScreen.routeName);
        },
        showSkipButton: true,
        skip: Text('skip'.tr, style: AppFonts.x14Regular.copyWith(color: kDisabledColor)),
        next: const Icon(Icons.arrow_forward),
        done: Text('done'.tr, style: AppFonts.x14Bold),
      ),
    );
  }
}