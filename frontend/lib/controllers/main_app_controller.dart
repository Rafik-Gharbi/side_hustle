import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants/shared_preferences_keys.dart';
import '../database/database_repository/category_database_repository.dart';
import '../database/database_repository/governorate_database_repository.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/governorate.dart';
import '../models/task.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/params_repository.dart';
import '../services/shared_preferences.dart';
import '../services/translation/app_localization.dart';
import '../views/home/home_screen.dart';
import '../views/profile/profile_screen.dart';

class MainAppController extends GetxController {
  static MainAppController get find => Get.find<MainAppController>();
  List<Category> categories = [];
  List<Governorate> governorates = [];
  String countryCode = 'US';
  String languageCode = 'en';
  RxInt bottomNavIndex = 0.obs;
  bool isReady = false;
  RxString currency = 'TND'.obs;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  ConnectivityResult currentConnectivityStatus = ConnectivityResult.none;
  RxBool isConnected = true.obs;

  Category? getCategoryById(id) => categories.cast<Category?>().singleWhere((element) => element?.id == id, orElse: () => null);

  Governorate? getGovernorateById(id) => governorates.cast<Governorate?>().singleWhere((element) => element?.id == id, orElse: () => null);

  MainAppController() {
    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      currentConnectivityStatus = await checkConnectivity(connectivity: result);
      isConnected.value = currentConnectivityStatus != ConnectivityResult.none;
      foundation.debugPrint('Device is connected: $isConnected');
    });
    _init();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  void manageNavigation(String routeName) {
    switch (routeName) {
      case ProfileScreen.routeName:
        bottomNavIndex.value = 3;
        if (Get.currentRoute != ProfileScreen.routeName) Get.offNamed(ProfileScreen.routeName);
        break;
      default:
        bottomNavIndex.value = 0;
    }
  }

  void changeLanguage({Locale? lang}) {
    if (lang == null) return;
    _saveLanguagePreferences(lang);
    Get.updateLocale(lang);
  }

  Future<ConnectivityResult> checkConnectivity({List<ConnectivityResult>? connectivity}) async {
    final List<ConnectivityResult> connectivityResult = connectivity ?? await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return ConnectivityResult.mobile; // Mobile network available.
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return ConnectivityResult.wifi; // Wi-fi is available.
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return ConnectivityResult.ethernet; // Ethernet connection available.
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return ConnectivityResult.vpn; // Vpn connection active.
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return ConnectivityResult.other; // Connected to a network which is not in the above mentioned networks.
    }
    return ConnectivityResult.none;
  }

  Future<void> _init() async {
    currentConnectivityStatus = await checkConnectivity();
    isConnected.value = currentConnectivityStatus != ConnectivityResult.none;
    await Helper.waitAndExecute(
      () => SharedPreferencesService.find.isReady,
      () async {
        try {
          // Get user saved language
          countryCode = SharedPreferencesService.find.get(countryCodeKey)!;
          languageCode = SharedPreferencesService.find.get(languageCodeKey)!;
          Get.updateLocale(Locale(languageCode, countryCode));
        } catch (e) {
          // Get user device language if no specific language has been found
          if (Get.deviceLocale != null && AppLocalization().supportedLocal.contains(Get.deviceLocale)) {
            _saveLanguagePreferences(Get.deviceLocale!);
            Get.updateLocale(Locale(Get.deviceLocale!.languageCode, Get.deviceLocale!.countryCode));
          } else {
            // Set default language fallback
            _saveLanguagePreferences(const Locale('en', 'US'));
            Get.updateLocale(const Locale('en', 'US'));
          }
        }
        if (categories.isEmpty) await _initDefaultCategories();
        if (governorates.isEmpty) await _initDefaultGovernorates();
        ever(
          bottomNavIndex,
          (callback) {
            switch (bottomNavIndex.value) {
              case 0:
                if (Get.currentRoute != HomeScreen.routeName) Get.offAllNamed(HomeScreen.routeName);
                break;
              case 3:
                Get.toNamed(ProfileScreen.routeName);
                break;
              default:
            }
          },
        );
      },
    );
    isReady = true;
  }

  Future<void> _initDefaultCategories() async {
    Future<List<Category>> loadCategories() async {
      final String jsonString = await rootBundle.loadString('assets/json/categories.json');
      final decodedJson = jsonDecode(jsonString) as List<dynamic>;
      return decodedJson.map((category) => Category.fromJson(category)).toList();
    }

    categories = await ParamsRepository.find.getAllCategories() ?? [];
    if (categories.isEmpty) categories = await loadCategories();
    CategoryDatabaseRepository.find.backupCategories(categories);
  }

  Future<void> _initDefaultGovernorates() async {
    Future<List<Governorate>> loadGovernorates() async {
      final String jsonString = await rootBundle.loadString('assets/json/governorates.json');
      final decodedJson = jsonDecode(jsonString) as List<dynamic>;
      return decodedJson.map((category) => Governorate.fromJson(category)).toList();
    }

    governorates = await ParamsRepository.find.getAllGovernorates() ?? [];
    if (governorates.isEmpty) governorates = await loadGovernorates();
    GovernorateDatabaseRepository.find.backupGovernorates(governorates);
  }

  void _saveLanguagePreferences(Locale deviceLocale) {
    SharedPreferencesService.find.add(languageCodeKey, deviceLocale.languageCode);
    SharedPreferencesService.find.add(countryCodeKey, deviceLocale.countryCode!);
  }

  List<Category> getCategoryChildren(Category parentCategory) => categories.where((element) => element.parentId == parentCategory.id).toList();

  Future<bool> toggleFavoriteTask(Task task) async {
    final result = await FavoriteRepository.find.toggleFavorite(idTask: task.id!);
    return result;
  }
}
