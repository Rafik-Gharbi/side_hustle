import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'database/database_repository/category_database_repository.dart';
import 'database/database_repository/governorate_database_repository.dart';
import 'database/database_repository/task_database_repository.dart';
import 'database/database_repository/user_database_repository.dart';
import 'networking/api_base_helper.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/params_repository.dart';
import 'repositories/reservation_repository.dart';
import 'repositories/store_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/user_repository.dart';
import 'services/authentication_service.dart';
import 'views/add_task/add_task_bottomsheet.dart';
import 'views/approve_user/approve_user_controller.dart';
import 'views/approve_user/approve_user_screen.dart';
import 'views/chat/chat_controller.dart';
import 'views/chat/chat_screen.dart';
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
import 'views/market/market_controller.dart';
import 'views/market/market_screen.dart';
import 'views/my_store/my_store_controller.dart';
import 'views/my_store/my_store_screen.dart';
import 'views/profile/profile_controller.dart';
import 'views/profile/profile_screen.dart';
import 'views/task_details/task_details_screen.dart';
import 'views/task_history/task_history_controller.dart';
import 'views/task_history/task_history_screen.dart';
import 'views/task_list/task_list_controller.dart';
import 'views/task_list/task_list_screen.dart';
import 'views/task_proposal/task_proposal_controller.dart';
import 'views/task_proposal/task_proposal_screen.dart';
import 'views/task_request/task_request_controller.dart';
import 'views/task_request/task_request_screen.dart';
import 'views/user_profile/user_profile_screen.dart';
import 'views/verification_screen.dart';
import 'views/verify_user/verify_user_controller.dart';
import 'views/verify_user/verify_user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
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
            name: UserProfileScreen.routeName,
            page: () => const UserProfileScreen(),
          ),
          GetPage(
            name: TaskListScreen.routeName,
            page: () => Get.arguments ?? const TaskListScreen(),
            binding: BindingsBuilder.put(() => TaskListController()),
          ),
          GetPage(
            name: TaskDetailsScreen.routeName,
            page: () => TaskDetailsScreen(task: Get.arguments),
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
            name: TaskRequestScreen.routeName,
            page: () => const TaskRequestScreen(),
            binding: BindingsBuilder.put(() => TaskRequestController()),
          ),
          GetPage(
            name: TaskProposalScreen.routeName,
            page: () => const TaskProposalScreen(),
            binding: BindingsBuilder.put(() => TaskProposalController()),
          ),
          GetPage(
            name: TaskHistoryScreen.routeName,
            page: () => const TaskHistoryScreen(),
            binding: BindingsBuilder.put(() => TaskHistoryController()),
          ),
          GetPage(
            name: ChatScreen.routeName,
            page: () => const ChatScreen(),
            binding: BindingsBuilder.put(() => ChatController()),
          ),
          GetPage(
            name: MarketScreen.routeName,
            page: () => const MarketScreen(),
            binding: BindingsBuilder.put(() => MarketController()),
          ),
          GetPage(
            name: MyStoreScreen.routeName,
            page: () => const MyStoreScreen(),
            binding: BindingsBuilder.put(() => MyStoreController()),
          ),
          GetPage(
            name: ApproveUserScreen.routeName,
            page: () => const ApproveUserScreen(),
            binding: BindingsBuilder.put(() => ApproveUserController()),
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
    Get.put(ReservationRepository(), permanent: true);
    Get.put(StoreRepository(), permanent: true);
    // Database repositories
    Get.put(UserDatabaseRepository(), permanent: true);
    Get.put(TaskDatabaseRepository(), permanent: true);
    Get.put(CategoryDatabaseRepository(), permanent: true);
    Get.put(GovernorateDatabaseRepository(), permanent: true);
  }
}
