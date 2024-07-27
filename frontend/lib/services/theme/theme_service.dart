import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../shared_preferences.dart';

class ThemeService {
  static ThemeService get find => Get.find<ThemeService>();
  Rx<ThemeMode> currentTheme = ThemeMode.dark.obs;

  ThemeService() {
    init();
  }

  Future<void> init() async {
    await Helper.waitAndExecute(
      () => SharedPreferencesService.find.isReady,
      () => setTheme(ThemeMode.values
              .cast<ThemeMode?>()
              .singleWhere((element) => element?.name != null && element?.name == SharedPreferencesService.find.get(currentThemeKey), orElse: () => null) ??
          ThemeMode.dark),
    );
  }

  void toggleTheme() {
    if (currentTheme.value == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    currentTheme.value = theme;
    Get.changeThemeMode(theme);
    // AppColor().updateTheme(theme);
    SharedPreferencesService.find.add(currentThemeKey, theme == ThemeMode.dark ? 'dark' : 'light');
    Future.delayed(const Duration(milliseconds: 300), () => Get.forceAppUpdate());
  }
}
