import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/notification.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/shared_preferences_keys.dart';
import '../constants/sizes.dart';
import '../models/review.dart';
import '../models/store.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../services/authentication_service.dart';
import '../services/shared_preferences.dart';
import '../services/translation/app_localization.dart';
import '../services/logger_service.dart';
import '../services/theme/theme.dart';
import '../views/notifications/notification_controller.dart';
import '../views/profile/admin_dashboard/components/stats_screen/components/pie_chart.dart';
import '../views/profile/verification_screen.dart';
import '../widgets/custom_popup.dart';
import '../widgets/phone_otp_dialog.dart';
import '../widgets/verify_email_dialog.dart';
import 'extensions/date_time_extension.dart';

class Helper {
  static Timer? _searchOnStoppedTyping;

  static String selectedIsoCode = defaultIsoCode;
  static String phonePrefix = defaultPrefix;
  static bool? lastCheckedVersion;

  static void snackBar({String message = 'Snack bar test', String? title, Duration? duration, bool includeDismiss = true, Widget? overrideButton, TextStyle? styleMessage}) =>
      GetSnackBar(
        titleText: title != null ? Text(title.tr, style: styleMessage ?? AppFonts.x16Bold) : null,
        messageText: Text(message.tr, style: styleMessage ?? AppFonts.x14Regular),
        duration: duration ?? const Duration(seconds: 3),
        isDismissible: true,
        borderColor: kSecondaryColor,
        borderWidth: 2,
        borderRadius: 10,
        margin: isMobile ? const EdgeInsets.symmetric(horizontal: 2).copyWith(bottom: 10) : EdgeInsets.only(left: (Get.width / 3) * 2, right: 50, bottom: 10),
        backgroundColor: kNeutralColor100,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: overrideButton ?? (includeDismiss ? TextButton(onPressed: () => Helper.goBack(), child: Text('dismiss'.tr)) : null),
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

  static bool get isArabic => Get.locale?.languageCode == 'ar';

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
        return 'Français';
      case 'ar':
        return 'العربية';
      // Add more language codes and their readable names as needed
      default:
        return 'Unknown';
    }
  }

  static String getDayFullName(int day) => DateFormat('EEEE').format(DateTime(2023, 5, day));

  static DateTime parseDisplayedDate(String date) => DateFormat('yyyy-MM-dd').parse(date);

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

  static String formatDateWithTime(DateTime createdAt) => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  static String formatAmount(double amount) => amount == amount.roundToDouble() ? amount.toInt().toString() : amount.toStringAsFixed(1);

  static void openConfirmationDialog({String? title, required String content, required void Function() onConfirm, void Function()? onCancel, Color? barrierColor}) => Get.dialog(
        CustomPopup(title: title ?? 'are_you_sure'.tr, content: content, onPressed: onConfirm, onCancel: onCancel),
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

  static Future<bool> mobileEmailVerification(String? email) =>
      Get.dialog(const VerifyEmailDialog()).then((value) => Get.bottomSheet(isScrollControlled: true, PhoneOTPDialog(phone: email!, isEmail: true)).then((code) async {
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
          }));

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
        onTap: (_) => NotificationsController.find.resolveNotificationAction(notification),
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
  static bool shouldUpdateCoordinates(LatLng? initialPosition, LatLng newPostion) {
    if (initialPosition == null) return true;
    double distance = calculateDistance(initialPosition.latitude, initialPosition.longitude, newPostion.latitude, newPostion.longitude);
    return distance > 10;
  }

  static String resolveDisplayDate(DateTime createdDate) {
    if (createdDate.isSameDate(DateTime.now())) return 'today'.tr;
    if (createdDate.isSameDate(DateTime.now().subtract(const Duration(days: 1)))) return 'yesterday'.tr;
    if (createdDate.isSameDate(DateTime.now().add(const Duration(days: 1)))) return 'tomorrow'.tr;
    return DateFormat.MMMEd().format(createdDate);
  }

  static bool isUUID(String str) {
    final uuidRegExp = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegExp.hasMatch(str);
  }

  /// Ignores snackbar if there are any, go to previous screen and snackbar dismisses by itself.
  static void goBack() => Get.isSnackbarOpen ? Navigator.of(Get.context!).pop() : Get.back();

  static int calculateTaskCoinsPrice(double taskPrice) {
    const baseCoins = 5;
    const basePriceThreshold = 50;
    if (taskPrice <= basePriceThreshold) return baseCoins;
    final additionalCoins = (max(0, taskPrice - basePriceThreshold) / basePriceThreshold).ceil();
    return baseCoins + additionalCoins;
  }

  static Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // e.g., "1.2.3"
  }

  static bool compareVersions(String latestVersion, String currentVersion) {
    // Split versions into major, minor, and patch numbers
    List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
    List<int> latestParts = latestVersion.split('.').map(int.parse).toList();
    // Check for major, minor, or patch updates
    if (latestParts[0] > currentParts[0] || (latestParts[0] == currentParts[0] && latestParts[1] > currentParts[1])) {
      // Major or minor update: required update
      return lastCheckedVersion = true;
    } else if (latestParts[2] > currentParts[2]) {
      // Patch update: suggest update with a snackbar
      if (lastCheckedVersion == null) {
        Helper.waitAndExecute(
          () => Get.locale != null,
          () => snackBar(title: 'new_update_available'.tr, message: 'new_update_available_msg'.tr, duration: const Duration(seconds: 5)),
        );
        LoggerService.logger?.i('New update available');
        Future.delayed(const Duration(minutes: 1), () => lastCheckedVersion = null);
      }
    }
    return lastCheckedVersion = false;
  }

  static double getBiggestDouble(List<double> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    return numbers.reduce(max);
  }

  static double getSmallestDouble(List<double> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    return numbers.reduce(min);
  }

  static Color getRandomColor({Color? baseColor}) => ColorGenerator().getRandomColor(baseColor: baseColor);

  static Map<T, double> sortByValueDesc<T>(Map<T, double> map) => Map.fromEntries(
        map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
      );

  static Map<DateTime, double> sortByDateDesc(Map<DateTime, double> map) => Map.fromEntries(
        map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );

  static int resolveBiggestIndex(List<PieChartModel> list) => list.indexWhere((element) => element.amount == Helper.getBiggestDouble(list.map((e) => e.amount).toList()));

  static void verifyUser(void Function() callback, {bool isLoggedIn = true, bool isVerified = false, String? loginErrorMsg}) {
    if (isLoggedIn && AuthenticationService.find.isUserLoggedIn.value || !isLoggedIn) {
      if (isVerified && AuthenticationService.find.jwtUserData?.isVerified == VerifyIdentityStatus.verified || !isVerified) {
        callback();
      } else {
        snackBar(message: 'verify_profile_msg'.tr);
      }
    } else {
      snackBar(message: loginErrorMsg ?? 'login_express_interest_msg'.tr);
    }
  }

  static bool isImage(String fileName) {
    if (!fileName.contains('.')) return false;
    fileName = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    return imageExtensions.contains(fileName);
  }

  static Future<List<XFile>?> pickFiles({List<String>? allowedExtensions, bool multiple = true, FileType type = FileType.custom}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowMultiple: multiple,
        allowedExtensions: allowedExtensions ?? ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );
      return result?.xFiles;
    } catch (e) {
      LoggerService.logger?.e('Error occured in pickFiles:\n$e');
      return null;
    }
  }
}

class ColorGenerator {
  late List<Color> _availableColors;
  final Random _random = Random();
  List<Color> colors = Colors.primaries;

  ColorGenerator() {
    _availableColors = List.from(colors)..shuffle(_random);
  }

  Color getRandomColor({Color? baseColor}) {
    if (baseColor != null) {
      // Generate a random variation of the baseColor
      return _getRandomVariation(baseColor);
    } else {
      // Use existing logic for default random color
      if (_availableColors.isEmpty) {
        _availableColors.addAll(colors);
        _availableColors.shuffle(_random);
      }
      return _availableColors.removeLast();
    }
  }

  Color _getRandomVariation(Color baseColor) {
    // Convert baseColor to HSLColor
    final baseHSLColor = HSLColor.fromColor(baseColor);
    // Adjust hue by a random value between -0.4 and 0.2
    final adjustedHue = baseHSLColor.hue + _random.nextDouble() * 0.4 - 0.2;
    // Ensure hue stays within 0.0 to 360.0 range
    final normalizedHue = adjustedHue % 360.0;
    final adjustedSaturation = baseHSLColor.saturation * (1.0 + _random.nextDouble() * 0.2 - 0.1);
    final adjustedLightness = baseHSLColor.lightness * (1.0 + _random.nextDouble() * 0.2 - 0.1);
    // Create a new HSLColor with adjusted hue and original saturation/lightness
    return HSLColor.fromAHSL(1.0, normalizedHue, adjustedSaturation, adjustedLightness).toColor();
  }
}
