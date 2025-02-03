import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../constants/colors.dart';

enum MyThemeMode { light, dark }

class AppFonts {
  static TextStyle get x30Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 40,
      );
  static TextStyle get x24Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 24,
      );
  static TextStyle get x24Bold => TextStyle(
        color: kBlackColor,
        fontFamily: 'Outfit',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get x18Bold => TextStyle(
        color: kBlackColor,
        fontFamily: 'Outfit',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get x18Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 18,
      );
  static TextStyle get x16Bold => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get x16Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 16,
      );
  static TextStyle get x15Bold => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get x14Bold => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get x14Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 14,
      );
  static TextStyle get x12Bold => TextStyle(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
        color: kBlackColor,
        fontSize: 12,
      );
  static TextStyle get x12Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 12,
      );
  static TextStyle get x11Bold => TextStyle(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
        color: kBlackColor,
        fontSize: 11,
      );
  static TextStyle get x10Bold => TextStyle(
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
        color: kBlackColor,
        fontSize: 10,
      );
  static TextStyle get x10Regular => TextStyle(
        fontFamily: 'Outfit',
        color: kBlackColor,
        fontSize: 10,
      );

  ThemeData basicTheme({MyThemeMode theme = MyThemeMode.light}) {
    final ThemeData lightBase = ThemeData.light();
    final ThemeData darkBase = ThemeData.dark();
    final Logger logger = Logger();

    TextTheme basicTextTheme(TextTheme base) => base.copyWith(displayLarge: AppFonts.x18Bold);

    if (theme == MyThemeMode.light) {
      return lightBase.copyWith(
        textTheme: basicTextTheme(lightBase.textTheme),
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kNeutralColor100,
        bottomSheetTheme: BottomSheetThemeData(
          surfaceTintColor: Colors.transparent,
          dragHandleColor: kPrimaryColor,
          backgroundColor: kNeutralColor100,
        ),
        scrollbarTheme: ScrollbarThemeData(thumbColor: WidgetStatePropertyAll(kNeutralColor)),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: kPrimaryColor,
          onPrimary: Color.alphaBlend(kPrimaryColor, kNeutralColor.withOpacity(0.2)),
          secondary: kAccentColor,
          onSecondary: Color.alphaBlend(kAccentColor, kNeutralColor.withOpacity(0.2)),
          error: kErrorColor,
          onError: Color.alphaBlend(kErrorColor, kNeutralColor.withOpacity(0.2)),
          surface: kBlackColor,
          onSurface: Color.alphaBlend(kBlackColor, kNeutralColor.withOpacity(0.2)),
        ),
      );
    } else if (theme == MyThemeMode.dark) {
      return darkBase.copyWith(
        textTheme: basicTextTheme(darkBase.textTheme),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: kBlackColor),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kNeutralColor,
        // colorScheme: const ColorScheme(error: kErrorColor),
      );
    } else {
      logger.e('Error: Provided theme does not exist');
    }
    return ThemeData.light(); //default Flutter theme
  }
}
