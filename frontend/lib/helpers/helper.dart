import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/notification.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/icon_map.dart';
import '../constants/shared_preferences_keys.dart';
import '../constants/sizes.dart';
import '../models/review.dart';
import '../models/store.dart';
import '../repositories/user_repository.dart';
import '../services/authentication_service.dart';
import '../services/shared_preferences.dart';
import '../services/translation/app_localization.dart';
import '../services/logger_service.dart';
import '../services/theme/theme.dart';
import '../views/chat/chat_screen.dart';
import '../views/notifications/notification_controller.dart';
import '../views/profile/verification_screen.dart';
import '../widgets/custom_popup.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_otp_dialog.dart';
import 'extensions/date_time_extension.dart';

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

  static String formatDateWithTime(DateTime createdAt) => DateFormat('yyyy-MM-dd hh:mm').format(createdAt);

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

  static Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    // Test if location services are enabled.
    serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  static Future<LatLng?> getPosition() async {
    final permission = await handlePermission();
    if (!permission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true);
      final latitude = position.latitude;
      final longitude = position.longitude;
      return LatLng(latitude, longitude);
    } catch (error) {
      debugPrint('Error getting location: $error');
    }
    return null;
  }

  static void showModifyLocationAlert(void Function(LatLng?) onSubmit) => Get.dialog(
        AlertDialog(
          title: const Text('Modifier et partager la position actuelle'),
          content: const Text('Voulez-vous modifier et partager votre position actuelle ?'),
          actions: [
            ElevatedButton(
              child: const Text('Annuler'),
              onPressed: () => Get.back(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Modifier et partager'),
              onPressed: () async {
                Get.back();
                final coordinates = await getPosition();
                onSubmit.call(coordinates);
              },
            ),
          ],
        ),
      );

  static double degreesToMeters(double distanceInDegrees) {
    const double earthRadius = 6371000;
    double distanceInMeters = distanceInDegrees * (pi / 180) * earthRadius;
    return distanceInMeters;
  }

  static void showNotification(NotificationModel notification) => GetSnackBar(
        titleText: Text(notification.title, style: AppFonts.x16Bold),
        messageText: Text(notification.body, style: AppFonts.x14Regular, overflow: TextOverflow.ellipsis),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        borderColor: kPrimaryColor,
        borderWidth: 2,
        borderRadius: 10,
        dismissDirection: DismissDirection.up,
        icon: const Icon(Icons.notifications_active_outlined, color: kBlackColor),
        onTap: (_) => Get.toNamed(ChatScreen.routeName),
        maxWidth: 400,
        margin: isMobile ? const EdgeInsets.all(5) : EdgeInsets.only(left: Get.width / 2, right: 50, top: 10),
        backgroundColor: kNeutralColor100,
        snackPosition: SnackPosition.TOP,
        mainButton: TextButton(onPressed: () => NotificationsController.find.resolveNotificationAction(notification), child: const Text('Open')),
      ).show();

  static double resolveDouble(json) => json == null
      ? 0
      : json is int
          ? json.toDouble()
          : json is String
              ? double.parse(json)
              : json as double;

  static Icon resolveRatingSatisfaction(double rating) {
    if (rating < 1) {
      return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
    } else if (rating < 2) {
      return const Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent);
    } else if (rating < 3) {
      return const Icon(Icons.sentiment_neutral, color: Colors.amber);
    } else if (rating <= 4) {
      return const Icon(Icons.sentiment_satisfied, color: Colors.lightGreen);
    } else {
      return const Icon(Icons.sentiment_very_satisfied, color: Colors.green);
    }
  }

  static double getRatingPercentage(List<Review> reviews, int index) {
    int reviewCount = 0;
    for (Review review in reviews) {
      if (review.rating.toInt() == index) {
        reviewCount++;
      }
    }
    double percentage = reviewCount > 0 ? (reviewCount / reviews.length) : 0;

    return percentage;
  }

  static double calculateRating(List<Review> userReviews) =>
      userReviews.isEmpty ? 0 : userReviews.map((e) => e.rating).reduce((value, element) => value + element) / userReviews.length;

  static double getStoreCheapestService(Store store) {
    double cheapestService = 9999;
    for (var element in store.services!) {
      if ((element.price ?? 0) < cheapestService) cheapestService = element.price ?? 0;
    }
    return cheapestService;
  }

  // Helper method to calculate distance between two coordinates using the Haversine formula
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Helper method to convert degrees to radians
    double degreesToRadians(double degrees) => degrees * pi / 180;

    const double R = 6371; // Radius of the Earth in kilometers
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) + cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in kilometers
  }

  // Method to check if coordinates have changed by more than 10 km and update if necessary
  static bool shouldUpdateCoordinates(LatLng initialPosition, LatLng newPostion) {
    double distance = calculateDistance(initialPosition.latitude, initialPosition.longitude, newPostion.latitude, newPostion.longitude);
    return distance > 10;
  }

  static String resolveDisplayDate(DateTime createdDate) {
    if (createdDate.isSameDate(DateTime.now())) return 'today'.tr;
    if (createdDate.isSameDate(DateTime.now().subtract(const Duration(days: 1)))) return 'yesterday'.tr;
    if (createdDate.isSameDate(DateTime.now().add(const Duration(days: 1)))) return 'tomorrow'.tr;
    return DateFormat.MMMEd().format(createdDate);
  }
}
