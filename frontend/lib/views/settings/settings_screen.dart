import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:currency_picker/currency_picker.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../services/theme/theme.dart';
import '../../services/theme/theme_service.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/feedback_bottomsheet.dart';
import 'components/animated_list_tile.dart';
import 'components/animated_title.dart';
import 'components/language_selector.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => CustomScaffoldBottomNavigation(
        appBarTitle: 'Settings',
        body: GetBuilder<SettingsController>(
          builder: (controller) => Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Paddings.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedTitle(title: 'general'.tr),
                    Obx(() => AnimatedListTile(
                          leading: const Icon(Icons.light_mode_outlined),
                          subtitle: '${'current_theme'.tr}: ${ThemeService.find.currentTheme.value.name}',
                          title: 'theme'.tr,
                          onTap: () => ThemeService.find.toggleTheme(),
                        )),
                    Obx(() => AnimatedListTile(
                          leading: const Icon(Icons.currency_exchange_outlined),
                          subtitle: '${'current_currency'.tr}: ${MainAppController.find.currency.value}',
                          title: 'currency'.tr,
                          onTap: () => showCurrencyPicker(
                            context: context,
                            theme: CurrencyPickerThemeData(
                              backgroundColor: kNeutralColor100,
                              titleTextStyle: AppFonts.x14Bold,
                              subtitleTextStyle: AppFonts.x14Regular,
                              currencySignTextStyle: AppFonts.x14Bold,
                            ),
                            showFlag: true,
                            showCurrencyName: true,
                            showCurrencyCode: true,
                            onSelect: (Currency currency) => MainAppController.find.currency.value = currency.code,
                          ),
                        )),
                    AnimatedListTile(
                      leading: const Icon(Icons.translate_outlined),
                      subtitle: '${'current_language'.tr}: ${Helper.getReadableLanguage(Get.locale?.languageCode ?? 'en')}',
                      title: 'language'.tr,
                      onTap: () => Get.bottomSheet(const LanguageSelector()),
                    ),
                    AnimatedListTile(
                      leading: const Icon(Icons.favorite_border),
                      subtitle: 'msg_rate_review_us'.tr,
                      title: 'rate_us'.tr,
                    ),
                    AnimatedListTile(
                      leading: const Icon(Icons.mail_outline),
                      subtitle: 'msg_share_thoughts'.tr,
                      title: 'send_feedback'.tr,
                      onTap: () => Get.bottomSheet(const EmotionSliderBottomsheet(), isScrollControlled: true),
                    ),
                    AnimatedListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      subtitle: 'msg_check_our_privacy'.tr,
                      title: 'privacy_policy'.tr,
                    ),
                    Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.regular)),
                    AnimatedTitle(title: 'notifications'.tr),
                    AnimatedListTile(
                      leading: const Icon(Icons.notifications_none_outlined),
                      subtitle: 'enable_notifications'.tr,
                      title: 'msg_push_notifications'.tr,
                      trailing: const Icon(Icons.expand_less),
                    ),
                    AnimatedListTile(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('default_reminders'.tr, overflow: TextOverflow.ellipsis, style: AppFonts.x16Bold),
                          Text('15_m'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.regular)),
                    AnimatedTitle(title: 'preferences'.tr),
                    AnimatedListTile(
                      title: 'switch_24_hour_format'.tr,
                      titleStyle: AppFonts.x16Regular,
                      trailing: Switch(
                        value: controller.is24Hour,
                        activeColor: kPrimaryColor,
                        inactiveTrackColor: kNeutralOpacityColor,
                        inactiveThumbColor: kNeutralColor,
                        trackOutlineColor: controller.is24Hour ? null : WidgetStatePropertyAll(kNeutralOpacityColor),
                        onChanged: (_) => controller.is24Hour = !controller.is24Hour,
                      ),
                    ),
                    AnimatedListTile(
                      subtitle: controller.categoryPreferences == 'Show popular categories' ? 'or my most searched categories' : 'or popular categories',
                      title: controller.categoryPreferences,
                      onTap: () => controller.toggleCategorySectionPreferences(),
                    ),
                    Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.regular)),
                    AnimatedTitle(title: 'security'.tr),
                    Obx(
                      () => AnimatedListTile(
                        leading: const Icon(Icons.fingerprint_outlined),
                        title: MainAppController.find.isAuthenticationRequired.value ? 'update_authentication'.tr : 'set_authentication'.tr,
                        subtitle: MainAppController.find.isAuthenticationRequired.value ? 'authentication_required'.tr : 'authentication_msg'.tr,
                        onTap: () => MainAppController.find.setAuthentication(context),
                      ),
                    ),
                    Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.regular)),
                    AnimatedTitle(title: 'data_management'.tr),
                    AnimatedListTile(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('max_caching'.tr, overflow: TextOverflow.ellipsis, style: AppFonts.x16Bold),
                          Text('500_mb'.tr, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    AnimatedListTile(
                      title: 'delete_cache'.tr,
                      onTap: controller.deleteCache,
                      trailing: const Icon(
                        Icons.delete_forever,
                        color: kErrorColor,
                      ),
                    ),
                    Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.regular)),
                    AnimatedTitle(title: 'support'.tr),
                    AnimatedListTile(
                      title: 'support'.tr,
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    AnimatedListTile(
                      title: 'help'.tr,
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    AnimatedListTile(
                      title: 'faq'.tr,
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
