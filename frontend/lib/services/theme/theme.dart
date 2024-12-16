import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../constants/colors.dart';

enum MyThemeMode { light, dark }

class AppFonts {
  static const TextStyle x30Regular = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 40,
  );
  static const TextStyle x24Regular = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 24,
  );
  static const TextStyle x24Bold = TextStyle(
    color: kBlackColor,
    fontFamily: 'Outfit',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x18Bold = TextStyle(
    color: kBlackColor,
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x18Regular = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 18,
  );
  static const TextStyle x16Bold = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x16Regular = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 16,
  );
  static const TextStyle x15Bold = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x14Bold = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle x14Regular = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 14,
  );
  static const TextStyle x12Bold = TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.bold,
    color: kBlackColor,
    fontSize: 12,
  );
  static const TextStyle x12Regular = TextStyle(
    fontFamily: 'Outfit',
    color: kBlackColor,
    fontSize: 12,
  );
  static const TextStyle x11Bold = TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.bold,
    color: kBlackColor,
    fontSize: 11,
  );
  static const TextStyle x10Bold = TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.bold,
    color: kBlackColor,
    fontSize: 10,
  );
  static const TextStyle x10Regular = TextStyle(
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
        bottomSheetTheme: const BottomSheetThemeData(
          surfaceTintColor: Colors.transparent,
          dragHandleColor: kPrimaryColor,
          backgroundColor: kNeutralColor100,
        ),
        scrollbarTheme: const ScrollbarThemeData(thumbColor: WidgetStatePropertyAll(kNeutralColor)),
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
        textTheme: basicTextTheme(darkBase.textTheme).copyWith(
          displayLarge: AppFonts.x18Bold.copyWith(color: kNeutralColor100),
        ),
        brightness: Brightness.dark,
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
