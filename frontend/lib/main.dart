import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'database/database_repository/category_database_repository.dart';
import 'database/database_repository/governorate_database_repository.dart';
import 'database/database_repository/task_database_repository.dart';
import 'database/database_repository/user_database_repository.dart';
import 'networking/api_base_helper.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/params_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/user_repository.dart';
import 'services/authentication_service.dart';
import 'views/add_task/add_task_bottomsheet.dart';
import 'views/favorite/favorite_controller.dart';
import 'views/favorite/favorite_screen.dart';
import 'views/home/home_screen.dart';

import 'controllers/main_app_controller.dart';
import 'services/logger_service.dart';
import 'services/navigation_history_observer.dart';
import 'services/shared_preferences.dart';
import 'services/theme/theme.dart';
import 'services/translation/app_localization.dart';
import 'views/home/home_controller.dart';
import 'views/profile/profile_controller.dart';
import 'views/profile/profile_screen.dart';
import 'views/task_details/task_details_controller.dart';
import 'views/task_details/task_details_screen.dart';
import 'views/task_list/task_list_controller.dart';
import 'views/task_list/task_list_screen.dart';
import 'views/verification_screen.dart';
import 'views/verify_user/verify_user_controller.dart';
import 'views/verify_user/verify_user_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Side Hustle',
        logWriterCallback: (text, {isError = false}) => isError ? LoggerService.logger?.e(text) : LoggerService.logger?.i(text),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus},
        ),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalization().supportedLocal,
        translations: AppLocalization(),
        fallbackLocale: const Locale('en', 'US'),
        theme: AppFonts().basicTheme(),
        initialBinding: InitialBindings(),
        initialRoute: HomeScreen.routeName,
        navigatorObservers: <NavigationHistoryObserver>[NavigationHistoryObserver()],
        getPages: [
          GetPage(
            name: HomeScreen.routeName,
            page: () => const HomeScreen(),
            binding: BindingsBuilder.put(() => HomeController()),
          ),
          GetPage(
            name: ProfileScreen.routeName,
            page: () => const ProfileScreen(),
            binding: BindingsBuilder.put(() => ProfileController()),
          ),
          GetPage(
            name: TaskListScreen.routeName,
            page: () => Get.arguments ?? const TaskListScreen(),
            binding: BindingsBuilder.put(() => TaskListController()),
          ),
          GetPage(
            name: TaskDetailsScreen.routeName,
            page: () => TaskDetailsScreen(task: Get.arguments),
            binding: BindingsBuilder.put(() => TaskDetailsController()),
          ),
          GetPage(
            name: VerifyUserScreen.routeName,
            page: () => const VerifyUserScreen(),
            binding: BindingsBuilder.put(() => VerifyUserController()),
          ),
          GetPage(
            name: FavoriteScreen.routeName,
            page: () => const FavoriteScreen(),
            binding: BindingsBuilder.put(() => FavoriteController()),
          ),
          GetPage(
            name: AddTaskBottomsheet.routeName,
            page: () => const AddTaskBottomsheet(),
          ),
          GetPage(
            name: VerificationScreen.routeName,
            page: () => const VerificationScreen(),
          ),
        ],
      );
}

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // Controllers & Services
    Get.put(SharedPreferencesService(), permanent: true);
    Get.put(LoggerService(), permanent: true);
    Get.put(MainAppController(), permanent: true);
    Get.put(AuthenticationService(), permanent: true);
    Get.put(ApiBaseHelper(), permanent: true);
    // Repositories
    Get.put(UserRepository(), permanent: true);
    Get.put(ParamsRepository(), permanent: true);
    Get.put(TaskRepository(), permanent: true);
    Get.put(FavoriteRepository(), permanent: true);
    // Database repositories
    Get.put(UserDatabaseRepository(), permanent: true);
    Get.put(TaskDatabaseRepository(), permanent: true);
    Get.put(CategoryDatabaseRepository(), permanent: true);
    Get.put(GovernorateDatabaseRepository(), permanent: true);
  }
}
