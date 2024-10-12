import 'package:get/get.dart';

import '../../constants/shared_preferences_keys.dart';
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
    // TODO delete all cache
    await SharedPreferencesService.find.clearAllSavedData();
  }

  void toggleCategorySectionPreferences() {
    if (categoryPreferences == 'show_popular_categories'.tr) {
      categoryPreferences = 'show_most_searched_categories'.tr;
    } else {
      categoryPreferences = 'show_popular_categories'.tr;
    }
    update();
  }
}
