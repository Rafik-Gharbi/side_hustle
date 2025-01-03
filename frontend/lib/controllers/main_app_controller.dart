import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/colors.dart';
import '../constants/shared_preferences_keys.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/governorate.dart';
import '../models/store.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../networking/api_base_helper.dart';
import '../repositories/chat_repository.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/params_repository.dart';
import '../repositories/user_repository.dart';
import '../services/authentication_service.dart';
import '../services/logger_service.dart';
import '../services/shared_preferences.dart';
import '../services/theme/theme.dart';
import '../services/translation/app_localization.dart';
import '../views/chat/chat_screen.dart';
import '../views/home/home_screen.dart';
import '../views/store/market/market_screen.dart';
import '../views/profile/profile_screen/profile_screen.dart';
import '../widgets/custom_buttons.dart';

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
  RxBool hasInternetConnection = true.obs;
  RxBool isBackReachable = true.obs;
  RxBool hasVersionUpdate = false.obs;
  final _localAuthentication = LocalAuthentication();
  RxBool isAuthenticationRequired = false.obs;
  RxBool isAuthenticated = false.obs;
  bool _canCheckBiometric = false;
  io.Socket? socket;
  RxInt notSeenMessages = 0.obs;
  RxInt notSeenNotifications = 0.obs;
  RxInt profileActionRequired = 0.obs;

  bool get isConnected => hasInternetConnection.value && isBackReachable.value;

  Category? getCategoryById(id) => categories.cast<Category?>().singleWhere((element) => element?.id == id, orElse: () => null);

  Governorate? getGovernorateById(id) => id == null ? null : governorates.cast<Governorate?>().singleWhere((element) => element?.id == id, orElse: () => null);

  MainAppController() {
    ever(hasVersionUpdate, (_) {
      if (hasVersionUpdate.value) {
        Helper.waitAndExecute(
          () => Get.locale != null,
          () => Get.dialog(
            AlertDialog(
              title: Text('update_required'.tr, style: AppFonts.x15Bold),
              content: Text('update_required_msg'.tr, style: AppFonts.x14Regular),
              actions: [
                CustomButtons.elevatePrimary(
                  onPressed: () => debugPrint('Open Store for update'), // TODO
                  title: 'update_now'.tr,
                  width: 150,
                  height: 40,
                  titleStyle: AppFonts.x14Bold,
                ),
              ],
            ),
            barrierDismissible: false,
          ),
        );
      }
    });
    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      currentConnectivityStatus = await checkConnectivity(connectivity: result);
      await checkVersionRequired();
      hasInternetConnection.value = currentConnectivityStatus != ConnectivityResult.none;
      foundation.debugPrint('Device is connected: $isConnected');
    });
    _init();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> checkVersionRequired() async {
    final (isBEConnected, version) = await ApiBaseHelper.find.checkConnectionToBackend();
    isBackReachable.value = isBEConnected;
    if (version != null) {
      final currentVersion = await Helper.getCurrentVersion();
      hasVersionUpdate.value = Helper.compareVersions(version, currentVersion);
      LoggerService.logger?.i(hasVersionUpdate.value ? 'Version update is required' : 'Current version is compatible');
    } else {
      Helper.snackBar(message: 'Couldn\'t check version update');
    }
  }

  void manageNavigation({int? screenIndex, String? routeName}) {
    assert(screenIndex != null || routeName != null, 'screenIndex or routeName is required!');
    switch (routeName ?? screenIndex) {
      case 0:
      case HomeScreen.routeName:
        bottomNavIndex.value = 0;
        if (Get.currentRoute != HomeScreen.routeName) Get.offAllNamed(HomeScreen.routeName);
        break;
      case 1:
      case MarketScreen.routeName:
        bottomNavIndex.value = 1;
        if (Get.currentRoute != MarketScreen.routeName) Get.offAllNamed(MarketScreen.routeName);
        break;
      case 2:
      case ChatScreen.routeName:
        bottomNavIndex.value = 2;
        if (Get.currentRoute != ChatScreen.routeName) Get.offAllNamed(ChatScreen.routeName);
        break;
      case 3:
      case ProfileScreen.routeName:
        bottomNavIndex.value = 3;
        if (Get.currentRoute != ProfileScreen.routeName) Navigator.of(Get.context!).popUntil((route) => route.settings.name == ProfileScreen.routeName);
        break;
      default:
        bottomNavIndex.value = screenIndex ?? 0;
    }
  }

  void changeLanguage({Locale? lang}) {
    if (lang == null) return;
    if (AuthenticationService.find.isUserLoggedIn.value) {
      Helper.onSearchDebounce(() => UserRepository.find.updateUserLanguage(lang.languageCode), duration: const Duration(seconds: 2));
    }
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

  Future<void> setAuthentication(BuildContext context) async {
    if (isAuthenticationRequired.value) {
      isAuthenticated.value = false;
      await showAuthenticationProcess(Get.currentRoute, context, couldCancel: true);
      if (!isAuthenticated.value) return;
    }
    await screenLockCreate(
      context: context,
      customizedButtonChild: isAuthenticationRequired.value ? const Icon(Icons.delete_forever, color: kNeutralColor100) : null,
      cancelButton: const Icon(Icons.close, color: kNeutralColor100),
      deleteButton: const Icon(Icons.backspace_outlined, color: kNeutralColor100, size: 22),
      customizedButtonTap: () => Helper.openConfirmationDialog(
        content: 'disable_authentication_question'.tr,
        onConfirm: () {
          isAuthenticationRequired.value = false;
          SharedPreferencesService.find.removeKey(userSecretKey);
          Helper.goBack();
          Helper.goBack();
        },
        onCancel: () => Helper.goBack(),
      ),
      keyPadConfig: const KeyPadConfig(buttonConfig: KeyPadButtonConfig(buttonStyle: ButtonStyle(foregroundColor: WidgetStatePropertyAll(kNeutralColor100)))),
      config: ScreenLockConfig(backgroundColor: kNeutralColor100.withOpacity(0.4)),
      onConfirmed: (value) {
        SharedPreferencesService.find.add(userSecretKey, value);
        isAuthenticationRequired.value = true;
        debugPrint(value);
        Helper.goBack();
      },
    );
  }

  Future<void> showAuthenticationProcess(String? route, BuildContext context, {bool replaceNavigation = false, bool couldCancel = false}) async => await screenLock(
        context: context,
        correctString: SharedPreferencesService.find.get(userSecretKey) ?? '0000',
        canCancel: couldCancel,
        cancelButton: const Icon(Icons.close, color: kNeutralColor100),
        deleteButton: const Icon(Icons.backspace_outlined, color: kNeutralColor100, size: 22),
        keyPadConfig: const KeyPadConfig(buttonConfig: KeyPadButtonConfig(buttonStyle: ButtonStyle(foregroundColor: WidgetStatePropertyAll(kNeutralColor100)))),
        config: ScreenLockConfig(backgroundColor: kNeutralColor100.withOpacity(0.4)),
        onUnlocked: () {
          isAuthenticated.value = true;
          if (replaceNavigation) {
            Get.offAllNamed(route ?? HomeScreen.routeName);
          } else {
            Helper.goBack();
          }
        },
        // onCancelled: () => Helper.goBack();,
        onOpened: () async => await _localAuth(route, replaceNavigation),
      );

  Future<void> _init() async {
    currentConnectivityStatus = await Future.delayed(const Duration(milliseconds: 600), () async => await checkConnectivity());
    await checkVersionRequired();
    hasInternetConnection.value = currentConnectivityStatus != ConnectivityResult.none;
    await Helper.waitAndExecute(
      () => SharedPreferencesService.find.isReady.value,
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
        try {
          _canCheckBiometric = await _localAuthentication.canCheckBiometrics;
        } catch (e) {
          foundation.debugPrint(e.toString());
          _canCheckBiometric = false;
        }
        isAuthenticationRequired.value = SharedPreferencesService.find.get(userSecretKey) != null;
        initSocket();
        if (categories.isEmpty) await _initDefaultCategories();
        if (governorates.isEmpty) await _initDefaultGovernorates();
        ever(
          bottomNavIndex,
          (callback) {
            if (!hasInternetConnection.value) {
              checkConnectivity().then((value) {
                currentConnectivityStatus = value;
                hasInternetConnection.value = currentConnectivityStatus != ConnectivityResult.none;
                if (!isBackReachable.value) checkVersionRequired();
              });
            }
            switch (bottomNavIndex.value) {
              case 0:
                Get.offAllNamed(HomeScreen.routeName);
                break;
              case 1:
                Get.toNamed(MarketScreen.routeName);
                break;
              case 2:
                Get.toNamed(ChatScreen.routeName);
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

  Future<void> _localAuth(String? route, bool replaceNavigation) async {
    if (_canCheckBiometric) {
      final didAuthenticate = await _localAuthentication.authenticate(localizedReason: 'please_authenticate'.tr);
      if (didAuthenticate) {
        isAuthenticated.value = true;
        if (replaceNavigation) {
          Get.offAllNamed(route ?? HomeScreen.routeName);
        } else {
          Helper.goBack();
        }
      }
    } else {
      debugPrint('cannot Check Biometrics');
    }
  }

  Future<void> _initDefaultCategories() async {
    Future<List<Category>> loadCategories() async {
      final String jsonString = await rootBundle.loadString('assets/json/categories.json');
      final decodedJson = jsonDecode(jsonString) as List<dynamic>;
      return decodedJson.map((category) => Category.fromJson(category)).toList();
    }

    await updateCategories();
    if (categories.isEmpty) categories = await loadCategories();
  }

  Future<void> updateCategories() async {
    categories = await ParamsRepository.find.getAllCategories() ?? [];
  }

  Future<void> _initDefaultGovernorates() async {
    Future<List<Governorate>> loadGovernorates() async {
      final String jsonString = await rootBundle.loadString('assets/json/governorates.json');
      final decodedJson = jsonDecode(jsonString) as List<dynamic>;
      return decodedJson.map((category) => Governorate.fromJson(category)).toList();
    }

    governorates = await ParamsRepository.find.getAllGovernorates() ?? [];
    if (governorates.isEmpty) governorates = await loadGovernorates();
  }

  void _saveLanguagePreferences(Locale deviceLocale) {
    SharedPreferencesService.find.add(languageCodeKey, deviceLocale.languageCode);
    SharedPreferencesService.find.add(countryCodeKey, deviceLocale.countryCode!);
  }

  List<Category> getCategoryChildren(Category parentCategory) => categories.where((element) => element.parentId == parentCategory.id).toList();

  Future<bool> toggleFavoriteTask(Task task) async {
    final result = await FavoriteRepository.find.toggleTaskFavorite(idTask: task.id!);
    return result;
  }

  Future<bool> toggleFavoriteStore(Store store) async {
    final result = await FavoriteRepository.find.toggleStoreFavorite(idStore: store.id!);
    return result;
  }

  void initSocket() => socket ??= io.io('${ApiBaseHelper.find.baseUrl}/', io.OptionBuilder().setTransports(['websocket']).build());

  Future<void> getNotSeenMessages() async => AuthenticationService.find.isUserLoggedIn.value ? notSeenMessages.value = await ChatRepository.find.getNotSeenMessages() : null;

  Future<void> getNotSeenNotifications() async =>
      AuthenticationService.find.jwtUserData != null ? notSeenNotifications.value = await NotificationRepository.find.getNotSeenNotificationsCount() : null;

  Future<void> resolveProfileActionRequired() async {
    int requiredActions = 0;
    if (AuthenticationService.find.jwtUserData?.isVerified == VerifyIdentityStatus.none) requiredActions++;
    final count = await UserRepository.find.getRequiredActionsCount();
    requiredActions += count;
    profileActionRequired.value = requiredActions;
  }
}
