import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_preferences_keys.dart';

class ThemeService {
  // static ThemeService get find => Get.find<ThemeService>();

  Future<ThemeService> init() async {
    final SharedPreferences sharedPreferances = await SharedPreferences.getInstance();
    await setTheme(
      sharedPreferances.get(currentThemeKey) == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light,
    );
    return this;
  }

  void toggleTheme() {
    // if (Get.isDarkMode) {
    //   setTheme(ThemeMode.light);
    // } else {
    //   setTheme(ThemeMode.dark);
    // }
  }

  Future<void> setTheme(ThemeMode theme) async {
    // final sharedPreferances = await SharedPreferences.getInstance();
    // Get.changeThemeMode(theme);
    // await sharedPreferances.setString('CurrentTheme', theme == ThemeMode.dark ? 'dark' : 'light');
  }
}
