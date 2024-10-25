import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_preferences_keys.dart';

class SharedPreferencesService extends GetxService {
  SharedPreferences? _prefs;
  bool isReady = false;

  static SharedPreferencesService get find => Get.find<SharedPreferencesService>();

  // TODO use encrypted SharedPreferences
  SharedPreferencesService() {
    _getSharedPreferencesInstance();
  }

  void add(String key, String value) => _prefs!.setString(key, value);

  String? get(String key) => _prefs!.getString(key);

  void removeKey(String key) => _prefs!.remove(key);

  Future<void> _getSharedPreferencesInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    SharedPreferencesService.find.removeKey(baseUrlKey);
    isReady = true;
  }

  Future<void> clearAllSavedData() async {
    _prefs!.getKeys().forEach((element) => _prefs!.remove(element));
  }
}
