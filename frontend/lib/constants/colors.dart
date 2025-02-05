import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/theme/theme_service.dart';

const Color kPrimaryColor = Color(0xFF0074FE);
const Color kPrimaryColorWhiter = Color.fromARGB(255, 119, 180, 165);
Color kPrimaryOpacityColor = kPrimaryColor.withOpacity(0.5);
const LinearGradient bPrimaryColor = LinearGradient(colors: [Color.fromRGBO(29, 134, 100, 1), Color.fromRGBO(46, 165, 127, 1)]);
Color kPrimaryDark = Color.alphaBlend(kPrimaryColor, kNeutralColor.withOpacity(0.1));
const Color kSecondaryColor = Color(0xff232d37);
const Color kAccentColor = Color(0xFFFF9931);
const Color kAccentDarkColor = Color.fromARGB(255, 131, 78, 24); // Colors.orange;
const Color kErrorColor = Color(0xFFE21200);
Color kErrorLightColor = Colors.red.shade600;
const Color kRatingColor = Color(0xFFFDCC0D);
const Color _kNeutralColor = Color(0xFF252535);
const Color _kNeutralLightColor = Color(0xFFE9E9E9);
const Color _kNeutralLightDarkColor = Color.fromARGB(255, 97, 97, 102);
const Color _kBlackColor = Colors.black;
const Color _kBGDarkColor = Color.fromARGB(255, 30, 30, 30);
const Color _kNeutralColor100 = Colors.white;
const Color kDisabledColor = Colors.grey;
const Color kConfirmedColor = Color(0xFF34A853);
const Color kSelectedDarkColor = Color.fromARGB(255, 0, 114, 208);
const Color kSelectedColor = Color(0xff008BF9);
const Color kSelectedLightColor = Color.fromARGB(255, 49, 162, 255);

Color get kNeutralOpacityColor => kNeutralColor.withOpacity(0.7);
Color get kNeutralLightOpacityColor => kNeutralLightColor.withOpacity(0.7);
Color get kNeutralLightColor => Get.isRegistered<ThemeService>() && ThemeService.find.isDark ? _kNeutralLightDarkColor : _kNeutralLightColor; // Colors.grey.shade200;
Color get kNeutralColor => Get.isRegistered<ThemeService>() && ThemeService.find.isDark ? _kNeutralLightColor : _kNeutralColor;
Color get kBlackColor => Get.isRegistered<ThemeService>() && ThemeService.find.isDark ? _kNeutralColor100 : _kBlackColor;
Color get kBlackReversedColor => Get.isRegistered<ThemeService>() && ThemeService.find.isDark ? _kBlackColor : _kNeutralColor100;
Color get kNeutralColor100 => Get.isRegistered<ThemeService>() && ThemeService.find.isDark ? _kBGDarkColor : _kNeutralColor100;
