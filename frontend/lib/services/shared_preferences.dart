import 'package:get/get.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_preferences_keys.dart';

class SharedPreferencesService extends GetxService {
  SharedPreferences? _prefs;
  RxBool isReady = false.obs;

  static SharedPreferencesService get find => Get.find<SharedPreferencesService>();

  SharedPreferencesService() {
    _getSharedPreferencesInstance();
  }

  void add(String key, String value) => _prefs!.setString(key, value);

  String? get(String key) => _prefs?.getString(key);

  void removeKey(String key) => _prefs!.remove(key);

  Future<void> _getSharedPreferencesInstance() async {
    _prefs ??= await EncryptedSharedPreferences().getInstance();
    SharedPreferencesService.find.removeKey(baseUrlKey);
    isReady.value = true;
  }

  Future<void> clearAllSavedData() async {
    _prefs!.getKeys().forEach((element) => _prefs!.remove(element));
  }
}
