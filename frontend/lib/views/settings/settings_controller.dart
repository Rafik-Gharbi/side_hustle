import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../database/database.dart';
import '../../helpers/helper.dart';
import '../../services/shared_preferences.dart';

class SettingsController extends GetxController {
  static SettingsController get find => Get.find<SettingsController>();
  bool _is24Hour = true;
  String categoryPreferences = 'show_popular_categories'.tr;

  bool get is24Hour => _is24Hour;

  set is24Hour(bool value) {
    _is24Hour = value;
    SharedPreferencesService.find.add(hourPreferencesKey, _is24Hour.toString());
    update();
  }

  SettingsController() {
    _init();
  }

  Future<void> _init() async {
    // _is24Hour = ParameteredSettings.use24HourTimer!;
  }

  Future<void> deleteCache() async {
    Database.getInstance().deleteAllData();
    Helper.snackBar(message: 'feature_not_available_yet'.tr);
    await SharedPreferencesService.find.clearAllSavedData();
  }

  void toggleCategorySectionPreferences() {
    Helper.snackBar(message: 'feature_not_available_yet'.tr);
    if (categoryPreferences == 'show_popular_categories'.tr) {
      categoryPreferences = 'show_most_searched_categories'.tr;
    } else {
      categoryPreferences = 'show_popular_categories'.tr;
    }
    update();
  }

  Future<void> reviewApp() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      final isAvailable = await inAppReview.isAvailable();
      if (isAvailable) {
        inAppReview.requestReview();
      } else {
        Helper.snackBar(message: 'reviewing_not_available'.tr);
      }
      // TODO adabt app revewing to iOS
    } catch (e) {
      Helper.snackBar(message: '${'error_occurred'.tr}\n$e');
    }
  }
}
