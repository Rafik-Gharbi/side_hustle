import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/icon_map.dart';
import '../constants/shared_preferences_keys.dart';
import '../constants/sizes.dart';
import '../repositories/user_repository.dart';
import '../services/authentication_service.dart';
import '../services/shared_preferences.dart';
import '../services/translation/app_localization.dart';
import '../services/logger_service.dart';
import '../services/theme/theme.dart';
import '../views/verification_screen.dart';
import '../widgets/custom_popup.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_otp_dialog.dart';

class Helper {
  static Timer? _searchOnStoppedTyping;

  static String selectedIsoCode = defaultIsoCode;
  static String phonePrefix = defaultPrefix;

  static void snackBar({String message = 'Snack bar test', String? title, Duration? duration, bool includeDismiss = true, Widget? overrideButton, TextStyle? styleMessage}) =>
      GetSnackBar(
        titleText: title != null ? Text(title.tr, style: styleMessage ?? AppFonts.x16Bold) : null,
        messageText: Text(message.tr, style: styleMessage ?? AppFonts.x14Regular),
        duration: duration ?? const Duration(seconds: 3),
        isDismissible: true,
        borderColor: kSecondaryColor,
        borderWidth: 2,
        borderRadius: 10,
        margin: isMobile ? EdgeInsets.zero : EdgeInsets.only(left: (Get.width / 3) * 2, right: 50, bottom: 10),
        backgroundColor: kNeutralColor100,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: overrideButton ?? (includeDismiss ? TextButton(onPressed: Get.back, child: Text('Dismiss'.tr)) : null),
      ).show();

  static Future<dynamic> waitAndExecute(bool Function() condition, Function callback, {Duration? duration}) async {
    while (!condition()) {
      await Future.delayed(duration ?? const Duration(milliseconds: 800), () {});
    }
    return callback();
  }

  static bool isNullOrEmpty(String? value) => value == null || value.isEmpty;

  static void onSearchDebounce(void Function() callback, {Duration duration = const Duration(milliseconds: 800)}) {
    if (_searchOnStoppedTyping != null) _searchOnStoppedTyping!.cancel();
    _searchOnStoppedTyping = Timer(duration, callback);
  }

  static bool isMobile = Get.width <= kMobileMaxWidth || GetPlatform.isAndroid || GetPlatform.isIOS || GetPlatform.isMobile;

  static bool isColorDarkEnoughForWhiteText(Color color, {double threshold = 0.55}) {
    assert(threshold >= 0 && threshold <= 1, 'The threshold value should be between 0.0 and 1.0');
    // Calculate the relative luminance of the color
    final double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    // Determine if the color is dark enough based on a threshold value
    return luminance > threshold;
  }

  static String getReadableLanguage(String? languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'ar':
        return 'Arabic';
      // Add more language codes and their readable names as needed
      default:
        return 'Unknown';
    }
  }

  static String getDayFullName(int day) => DateFormat('EEEE').format(DateTime(2023, 5, day));

  static DateTime parseDisplayedDate(String date) => DateFormat('MMM d, h:mm a').parse(date).copyWith(year: DateTime.now().year);

  static AlertDialog buildDialog({
    required Widget child,
    double? width,
    double? height,
    Color backgroundColor = kNeutralColor100,
    double radius = RadiusSize.large,
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
        backgroundColor: backgroundColor,
        insetPadding: padding,
        contentPadding: padding,
        elevation: 0,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            width: width ?? Get.width * 0.8,
            height: height ?? Get.height * 0.8,
            child: child,
          ),
        ),
      );

  static Future<bool> launchUrlHelper(String url) async {
    LoggerService.logger!.i('launching: $url');
    try {
      bool result = false;
      if (await canLaunchUrl(Uri.parse(url))) {
        result = await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
      return result;
    } catch (e) {
      LoggerService.logger?.e('Error catched in launchUrlHelper: $e');
    }
    return false;
  }

  static dynamic decryptResponse(String response) {
    final decryptedDataString = Helper.decryptData(response);
    final jsonDecrypted = json.decode(decryptedDataString);
    return jsonDecrypted;
  }

  static String encryptData(String password) {
    // final key = enc.Key.fromUtf8('23557520584123485319BCFAEFEDADEF');
    // final iv = enc.IV(Uint8List.fromList(List<int>.filled(16, 0)));
    // final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    // final encrypted = encrypter.encrypt(password, iv: iv);
    // return encrypted.base64;
    return '';
  }

  static String decryptData(String encryptedData) {
    // final key = enc.Key.fromUtf8('23557520584123485319BCFAEFEDADEF');
    // final iv = enc.IV(Uint8List.fromList(List<int>.filled(16, 0)));
    // final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    // final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    // return decrypted;
    return '';
  }

  static String getNameInitials(String? name) {
    name = name?.trim();
    return isNullOrEmpty(name)
        ? 'GU'
        : name!.contains(' ')
            ? name.split(' ').map((e) => e[0].toUpperCase()).join()
            : name[0].toUpperCase();
  }

  static Locale? getLocaleFromLangName(String? language) {
    String? langCode;
    switch (language) {
      case 'English':
        langCode = 'en';
        break;
      case 'French':
        langCode = 'fr';
        break;
      case 'Arabic':
        langCode = 'ar';
        break;
      // Add more language codes and their readable names as needed
      default:
        return null;
    }
    return AppLocalization().supportedLocal.cast<Locale?>().singleWhere((element) => element?.languageCode == langCode, orElse: () => null);
  }

  static String formatDate(DateTime createdAt) => DateFormat('yyyy-MM-dd').format(createdAt);

  static String formatAmount(double amount) => amount == amount.roundToDouble() ? amount.toInt().toString() : amount.toStringAsFixed(1);

  static void openConfirmationDialog({required String title, required void Function() onConfirm, void Function()? onCancel, Color? barrierColor}) => Get.dialog(
        CustomPopup(content: title, onPressed: onConfirm, onCancel: onCancel),
        barrierColor: barrierColor?.withOpacity(0.3),
      );

  static void openDatePicker({dynamic Function(DateTime)? onConfirm, void Function()? onClear, DateTime? currentTime, bool isFutureDate = false}) {
    picker.LocaleType mapLocale(Locale locale) {
      if (locale.languageCode == 'fr') {
        return picker.LocaleType.fr;
      } else {
        return picker.LocaleType.en;
      }
    }

    picker.DatePicker.showDatePicker(
      Get.context!,
      // dialogConstraints: const BoxConstraints(maxWidth: 800, maxHeight: 400),
      showTitleActions: true,
      theme: const picker.DatePickerTheme(
        containerHeight: 290,
        backgroundColor: kNeutralColor100,
        cancelStyle: AppFonts.x14Bold,
        doneStyle: AppFonts.x14Bold,
        itemStyle: AppFonts.x14Regular,
      ),
      minTime: isFutureDate ? DateTime.now() : DateTime(1900),
      maxTime: isFutureDate ? DateTime.now().add(const Duration(days: 60)) : DateTime.now(),
      onConfirm: onConfirm,
      currentTime: currentTime,
      onCancel: onClear,
      // cancelTitle: 'btn_clear'.tr,
      locale: mapLocale(Locale(SharedPreferencesService.find.get(languageCodeKey)!, SharedPreferencesService.find.get(countryCodeKey)!)),
    );
  }

  static Future<bool> mobileEmailVerification(String? email) => Get.bottomSheet(isScrollControlled: true, PhoneOTPDialog(phone: email!, isEmail: true)).then((code) async {
        if (code != null) {
          UserRepository.find.verifyEmail(code, email: email).then(
                (value) => WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    if (value != null && value is Map && value['token'] != null) AuthenticationService.find.initiateCurrentUser(value['token']);
                    if (value != null && value is Map && value['token'] != null) value = '';
                    Get.toNamed(VerificationScreen.routeName, arguments: value);
                  },
                ),
              );
          return true;
        } else {
          LoggerService.logger?.i('Phone verification process canceled by the user');
          return false;
        }
      });

  static void openIconsBottomsheet(void Function(IconData) onSelectIcon) {
    final scrollController = ScrollController();
    List<IconData> filteredIcons = materialSymbolsMap.values.toList();

    List<IconData> filterIcons(String value) {
      if (value.isEmpty) {
        filteredIcons = materialSymbolsMap.values.toList();
      } else {
        filteredIcons = materialSymbolsMap.entries.where((element) => element.key.toString().toLowerCase().contains(value.toLowerCase())).map((e) => e.value).toList();
      }
      return filteredIcons;
    }

    Get.bottomSheet(
      DecoratedBox(
        decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusSize.extraLarge))),
        child: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              height: Get.height / 2,
              child: Scrollbar(
                controller: scrollController,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'search_icons'.tr,
                      // textStyle: AppFonts.x14Regular.copyWith(height: 0.1),
                      // border: UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
                      onChanged: (value) => Helper.onSearchDebounce(() => setState(() => filteredIcons = filterIcons(value))),
                    ),
                    const SizedBox(height: Paddings.regular),
                    Expanded(
                      child: GridView.extent(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: const ScrollPhysics(),
                        maxCrossAxisExtent: 50.0,
                        mainAxisSpacing: Paddings.regular,
                        crossAxisSpacing: Paddings.regular,
                        padding: const EdgeInsets.all(Paddings.large),
                        children: filteredIcons
                            .map(
                              (iconData) => InkWell(
                                onTap: () {
                                  onSelectIcon.call(iconData);
                                  Get.back();
                                },
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: kNeutralLightColor,
                                    child: Center(child: Icon(iconData, color: kBlackColor)),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}