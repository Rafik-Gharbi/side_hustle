import 'dart:collection';

import 'package:flutter/material.dart';
import '../views/home/home_screen.dart';

import '../../services/shared_preferences.dart';
import '../constants/shared_preferences_keys.dart';
import '../helpers/helper.dart';
import '../widgets/main_screen_with_bottom_navigation.dart';

class NavigationHistoryObserver extends NavigatorObserver {
  static final NavigationHistoryObserver instance = NavigationHistoryObserver._();
  final int _maxHistoryLength = 50;
  final history = Queue<Route<dynamic>?>();
  Route<dynamic>? _currentRoute;
  // bool _fetchSavedHistoryRequired = true;

  String get previousRouteHistory =>
      history.length >= 2 ? history.elementAt(history.length - 2)?.settings.name ?? MainScreenWithBottomNavigation.routeName : MainScreenWithBottomNavigation.routeName;

  factory NavigationHistoryObserver() => instance;

  NavigationHistoryObserver._() {
    // history.map((e) => e?.settings.name).toList()
    history.add(_createRouteFromName(MainScreenWithBottomNavigation.routeName));
  }

  Route<dynamic>? get currentRoute => _currentRoute;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // if (route.settings.name == MainScreenWithBottomNavigation.routeName) history.clear();
    // if (history.isNotEmpty && (previousRouteHistory == route.settings.name || previousRouteHistory == previousRoute?.settings.name)) _removeLastHistory();
  }

  @override
  Future<void> didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    // clear & initialize history when on home screen
    if (route.settings.name == MainScreenWithBottomNavigation.routeName) {
      history.clear();
      history.add(_createRouteFromName(MainScreenWithBottomNavigation.routeName));
      Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () => SharedPreferencesService.find.removeKey(navigationStackKey));
    }
    // save navigation history in shared preferences
    // if (history.length > 1 && route.settings.name != CustomScaffoldBottomNavigation.routeName) {
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
    // } else if (_fetchSavedHistoryRequired && history.length <= 1 && route.settings.name != CustomScaffoldBottomNavigation.routeName) {
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
    if (route.settings.name == MainScreenWithBottomNavigation.routeName) {
      history.clear();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _addRoute(newRoute);

  void goToPreviousRoute({bool? result}) {
    if (result != null) {
      Helper.goBack(result: result);
      _removeLastHistory();
    // } else if (history.length <= 1) {
    //   // get saved history and populate [history]
    //   // if (_fetchSavedHistoryRequired) {
    //   //   Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () {
    //   //     final savedHistory = SharedPreferencesService.find.get(navigationStackKey);
    //   //     _fetchSavedHistoryRequired = false;
    //   //     if (savedHistory != null) {
    //   //       try {
    //   //         final mappedSavedHistory = (jsonDecode(savedHistory) as List).map((e) => e as String).map(
    //   //             (e) => _createRouteFromName(routesDictionary[e.contains('/') ? e.substring(0, e.indexOf('/')) : e]!, arg: e.contains('/') ? e.substring(e.indexOf('/')) : null));
    //   //         final Iterable<Route<dynamic>?> routes = mappedSavedHistory;
    //   //         history.addAll(routes);
    //   //       } catch (e) {
    //   //         LoggerService.logger?.e(e);
    //   //       }
    //   //     }
    //   //     Get.toNamed(previousRoute);
    //   //     _removeLastHistory();
    //   //   });
    //   // } else {
    //   Get.toNamed(previousRouteHistory);
      // }
    } else {
      Helper.goBack();
      _removeLastHistory();
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
      case MainScreenWithBottomNavigation.routeName:
        return MaterialPageRoute(builder: (context) => const HomeScreen(), settings: const RouteSettings(name: MainScreenWithBottomNavigation.routeName));
      // ...other routes
      default:
        throw Exception('Unknown route name: $routeName');
    }
  }

  Map<String, String> routesDictionary = {
    '0': MainScreenWithBottomNavigation.routeName,
  };
}
