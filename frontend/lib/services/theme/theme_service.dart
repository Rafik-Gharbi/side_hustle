import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../shared_preferences.dart';

class ThemeService {
  static ThemeService get find => Get.find<ThemeService>();
  Rx<ThemeMode> currentTheme = ThemeMode.light.obs;

  ThemeService() {
    init();
  }

  bool get isDark => currentTheme.value == ThemeMode.dark;

  Future<void> init() async {
    await Helper.waitAndExecute(
      () => SharedPreferencesService.find.isReady.value,
      () => setTheme(ThemeMode.values
              .cast<ThemeMode?>()
              .singleWhere((element) => element?.name != null && element?.name == SharedPreferencesService.find.get(currentThemeKey), orElse: () => null) ??
          ThemeMode.dark),
    );
  }

  void toggleTheme() {
    // Helper.snackBar(message: 'feature_not_available_yet'.tr);
    if (currentTheme.value == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    currentTheme.value = theme;
    Get.changeThemeMode(theme);
    SharedPreferencesService.find.add(currentThemeKey, theme == ThemeMode.dark ? 'dark' : 'light');
    Future.delayed(Durations.long1, () => Get.forceAppUpdate());
  }
}
