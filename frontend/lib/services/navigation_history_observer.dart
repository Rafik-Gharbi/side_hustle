import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/chat/chat_controller.dart';
import '../views/chat/chat_screen.dart';
import '../views/chat/components/messages_screen.dart';
import '../views/home/home_screen.dart';

import '../../services/shared_preferences.dart';
import '../constants/shared_preferences_keys.dart';
import '../helpers/helper.dart';
import '../views/profile/profile_screen/profile_screen.dart';

class NavigationHistoryObserver extends NavigatorObserver {
  static final NavigationHistoryObserver instance = NavigationHistoryObserver._();
  final int _maxHistoryLength = 50;
  final history = Queue<Route<dynamic>?>();
  Route<dynamic>? _currentRoute;
  // bool _fetchSavedHistoryRequired = true;

  String get previousRouteHistory => history.length >= 2 ? history.elementAt(history.length - 2)?.settings.name ?? HomeScreen.routeName : HomeScreen.routeName;

  factory NavigationHistoryObserver() => instance;

  NavigationHistoryObserver._() {
    // history.map((e) => e?.settings.name).toList()
    history.add(_createRouteFromName(HomeScreen.routeName));
  }

  Route<dynamic>? get currentRoute => _currentRoute;

  bool get isStackHasProfileScreen => history.isNotEmpty && history.any((element) => element?.settings.name == ProfileScreen.routeName);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == HomeScreen.routeName) history.clear();
    if (history.isNotEmpty && (previousRouteHistory == route.settings.name || previousRouteHistory == previousRoute?.settings.name)) _removeLastHistory();
  }

  @override
  Future<void> didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    // clear & initialize history when on home screen
    _checkChatLoadingStatus(route, previousRoute);
    if (route.settings.name == HomeScreen.routeName) {
      history.clear();
      history.add(_createRouteFromName(HomeScreen.routeName));
      Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () => SharedPreferencesService.find.removeKey(navigationStackKey));
    }
    // save navigation history in shared preferences
    // if (history.length > 1 && route.settings.name != HomeScreen.routeName) {
    // Helper.waitAndExecute(
    //   () => SharedPreferencesService.find.isReady,
    //   () {
    //     final encodedStack = jsonEncode(history
    //         .where((element) => element != null)
    //         .map((e) {
    //           final entry = routesDictionary.entries.cast<MapEntry<String, String>?>().firstWhere(
    //                 (element) => element != null ? e!.settings.name?.contains(element.value) ?? false : false,
    //                 orElse: () => null,
    //               );
    //           return entry != null ? entry.key + (e?.settings.name?.substring(entry.value.length) ?? '') : null;
    //         })
    //         .where((element) => element != null)
    //         .toList());
    //     SharedPreferencesService.find.add(navigationStackKey, encodedStack);
    //   },
    // );
    // Get lost navigation if any (when reloading page)
    // } else if (_fetchSavedHistoryRequired && history.length <= 1 && route.settings.name != HomeScreen.routeName) {
    // _fetchSavedHistoryRequired = false;
    // Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () {
    //   final savedHistory = SharedPreferencesService.find.get(navigationStackKey);
    //   if (savedHistory != null) {
    //     try {
    //       final mappedSavedHistory = (jsonDecode(savedHistory) as List).map((e) => e as String).map(
    //           (e) => _createRouteFromName(routesDictionary[e.contains('/') ? e.substring(0, e.indexOf('/')) : e]!, arg: e.contains('/') ? e.substring(e.indexOf('/')) : null));
    //       final Iterable<Route<dynamic>?> routes = mappedSavedHistory;
    //       history.clear();
    //       history.addAll(routes);
    //       _addRoute(route);
    //     } catch (e) {
    //       LoggerService.logger?.e(e);
    //     }
    //   }
    // });
    // }
    _addRoute(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == HomeScreen.routeName) {
      history.clear();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _addRoute(newRoute);

  void goToPreviousRoute({bool? result, bool popToProfile = false}) {
    if (popToProfile) {
      while (previousRouteHistory != ProfileScreen.routeName) {
        _removeLastHistory();
      }
      Get.offNamedUntil(ProfileScreen.routeName, (route) => route.settings.name == ProfileScreen.routeName);
    } else if (result != null) {
      Helper.goBack(result: result);
      _removeLastHistory();
    } else if (history.length <= 1) {
      // get saved history and populate [history]
      // if (_fetchSavedHistoryRequired) {
      //   Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () {
      //     final savedHistory = SharedPreferencesService.find.get(navigationStackKey);
      //     _fetchSavedHistoryRequired = false;
      //     if (savedHistory != null) {
      //       try {
      //         final mappedSavedHistory = (jsonDecode(savedHistory) as List).map((e) => e as String).map(
      //             (e) => _createRouteFromName(routesDictionary[e.contains('/') ? e.substring(0, e.indexOf('/')) : e]!, arg: e.contains('/') ? e.substring(e.indexOf('/')) : null));
      //         final Iterable<Route<dynamic>?> routes = mappedSavedHistory;
      //         history.addAll(routes);
      //       } catch (e) {
      //         LoggerService.logger?.e(e);
      //       }
      //     }
      //     Get.toNamed(previousRoute);
      //     _removeLastHistory();
      //   });
      // } else {
      Get.toNamed(previousRouteHistory);
      // }
    } else {
      _removeLastHistory();
      Helper.goBack();
    }
  }

  void _removeLastHistory({String? untilRouteName}) {
    final historyLength = history.length;
    do {
      history.removeLast();
    } while (untilRouteName != null && history.isNotEmpty ? history.last?.settings.name == untilRouteName : history.length >= historyLength);
  }

  void _addRoute(Route<dynamic>? newRoute) {
    if (newRoute?.settings.name == null) return;
    _currentRoute = newRoute;
    if (history.any((element) => element?.settings.name == newRoute!.settings.name) && history.last?.settings.name != newRoute!.settings.name) {
      _removeLastHistory(untilRouteName: newRoute.settings.name);
      history.add(newRoute);
    } else if (history.isNotEmpty && newRoute!.settings.name != history.last?.settings.name || history.isEmpty) {
      history.add(newRoute);
    }
    if (history.length > _maxHistoryLength) {
      history.removeFirst();
    }
  }

  Route<dynamic> _createRouteFromName(String routeName) {
    switch (routeName) {
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (context) => const HomeScreen(), settings: const RouteSettings(name: HomeScreen.routeName));
      // ...other routes
      default:
        throw Exception('Unknown route name: $routeName');
    }
  }

  Map<String, String> routesDictionary = {
    '0': HomeScreen.routeName,
  };

  void _checkChatLoadingStatus(Route route, Route? previousRoute) {
    if ((route.settings.name != ChatScreen.routeName || route.settings.name != MessagesScreen.routeName) &&
        (previousRoute?.settings.name == ChatScreen.routeName || previousRoute?.settings.name == MessagesScreen.routeName)) {
      ChatController.find.isLoading.value = true;
    }
  }
}
