import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'constants/colors.dart';
import 'database/database_repository/booking_database_repository.dart';
import 'database/database_repository/category_database_repository.dart';
import 'database/database_repository/governorate_database_repository.dart';
import 'database/database_repository/reservation_database_repository.dart';
import 'database/database_repository/store_database_repository.dart';
import 'database/database_repository/task_database_repository.dart';
import 'database/database_repository/user_database_repository.dart';
import 'firebase_options.dart';
import 'helpers/helper.dart';
import 'helpers/notification_service.dart';
import 'networking/api_base_helper.dart';
import 'repositories/booking_repository.dart';
import 'repositories/boost_repository.dart';
import 'repositories/chat_repository.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/notification_repository.dart';
import 'repositories/params_repository.dart';
import 'repositories/reservation_repository.dart';
import 'repositories/review_repository.dart';
import 'repositories/store_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/user_repository.dart';
import 'services/authentication_service.dart';
import 'services/theme/theme_service.dart';
import 'views/boost/list_boost/list_boost_controller.dart';
import 'views/boost/list_boost/list_boost_screen.dart';
import 'views/notifications/notification_controller.dart';
import 'views/notifications/notification_screen.dart';
import 'views/store/service_history/service_history_controller.dart';
import 'views/store/service_history/service_history_screen.dart';
import 'views/task/add_task/add_task_bottomsheet.dart';
import 'views/profile/approve_user/approve_user_controller.dart';
import 'views/profile/approve_user/approve_user_screen.dart';
import 'views/chat/chat_controller.dart';
import 'views/chat/chat_screen.dart';
import 'views/chat/components/messages_screen.dart';
import 'views/profile/favorite/favorite_controller.dart';
import 'views/profile/favorite/favorite_screen.dart';
import 'views/home/home_screen.dart';

import 'controllers/main_app_controller.dart';
import 'services/logger_service.dart';
import 'services/navigation_history_observer.dart';
import 'services/shared_preferences.dart';
import 'services/theme/theme.dart';
import 'services/translation/app_localization.dart';
import 'views/home/home_controller.dart';
import 'views/store/market/market_controller.dart';
import 'views/store/market/market_screen.dart';
import 'views/store/my_store/my_store_controller.dart';
import 'views/store/my_store/my_store_screen.dart';
import 'views/profile/profile_screen/profile_controller.dart';
import 'views/profile/profile_screen/profile_screen.dart';
import 'views/store/service_request/service_request_controller.dart';
import 'views/store/service_request/service_request_screen.dart';
import 'views/settings/settings_controller.dart';
import 'views/settings/settings_screen.dart';
import 'views/task/task_details/task_details_screen.dart';
import 'views/task/task_history/task_history_controller.dart';
import 'views/task/task_history/task_history_screen.dart';
import 'views/task/task_list/task_list_controller.dart';
import 'views/task/task_list/task_list_screen.dart';
import 'views/task/task_proposal/task_proposal_controller.dart';
import 'views/task/task_proposal/task_proposal_screen.dart';
import 'views/task/task_request/task_request_controller.dart';
import 'views/task/task_request/task_request_screen.dart';
import 'views/profile/user_profile/user_profile_screen.dart';
import 'views/profile/verification_screen.dart';
import 'views/profile/verify_user/verify_user_controller.dart';
import 'views/profile/verify_user/verify_user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) => AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.hashCode,
          channelKey: 'basic_channel',
          actionType: ActionType.Default,
          title: message.notification?.title,
          body: message.notification?.body,
        ),
      ));
  AwesomeNotifications()
      .initialize(
        // 'resource://drawable/res_app_icon',
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: kPrimaryColor,
              ledColor: Colors.white)
        ],
        channelGroups: [NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')],
        debug: true,
      )
      .then(
        (value) => AwesomeNotifications().setListeners(
          onActionReceivedMethod: NotificationService.onActionReceivedMethod,
          onNotificationCreatedMethod: NotificationService.onNotificationCreatedMethod,
          onNotificationDisplayedMethod: NotificationService.onNotificationDisplayedMethod,
          onDismissActionReceivedMethod: NotificationService.onDismissActionReceivedMethod,
        ),
      );
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: message.hashCode,
      channelKey: 'basic_channel',
      actionType: ActionType.Default,
      title: message.notification?.title,
      body: message.notification?.body,
    ),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkUserPosition();
  }

  Future<void> _checkUserPosition() async {
    final user = AuthenticationService.find.jwtUserData;
    if (AuthenticationService.find.isUserLoggedIn.value && (user?.hasSharedPosition ?? false)) {
      final coordinates = await Helper.getPosition();
      if (coordinates != null && Helper.shouldUpdateCoordinates(user!.coordinates!, coordinates)) {
        user.coordinates = coordinates;
        UserRepository.find.updateUser(user, silent: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        navigatorKey: MyApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Abid Concept',
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
            name: ServiceHistoryScreen.routeName,
            page: () => const ServiceHistoryScreen(),
            binding: BindingsBuilder.put(() => ServiceHistoryController()),
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
            name: ServiceRequestScreen.routeName,
            page: () => const ServiceRequestScreen(),
            binding: BindingsBuilder.put(() => ServiceRequestController()),
          ),
          GetPage(
            name: SettingsScreen.routeName,
            page: () => const SettingsScreen(),
            binding: BindingsBuilder.put(() => SettingsController()),
          ),
          GetPage(
            name: ListBoostScreen.routeName,
            page: () => const ListBoostScreen(),
            binding: BindingsBuilder.put(() => ListBoostController()),
          ),
          GetPage(
            name: NotificationScreen.routeName,
            page: () => const NotificationScreen(),
          ),
          GetPage(
            name: AddTaskBottomsheet.routeName,
            page: () => const AddTaskBottomsheet(),
          ),
          GetPage(
            name: MessagesScreen.routeName,
            page: () => const MessagesScreen(),
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
    Get.put(ThemeService(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    // Repositories
    Get.put(ChatRepository(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(ParamsRepository(), permanent: true);
    Get.put(TaskRepository(), permanent: true);
    Get.put(FavoriteRepository(), permanent: true);
    Get.put(ReservationRepository(), permanent: true);
    Get.put(BookingRepository(), permanent: true);
    Get.put(StoreRepository(), permanent: true);
    Get.put(NotificationRepository(), permanent: true);
    Get.put(ReviewRepository(), permanent: true);
    Get.put(BoostRepository(), permanent: true);
    // Database repositories
    Get.put(UserDatabaseRepository(), permanent: true);
    Get.put(TaskDatabaseRepository(), permanent: true);
    Get.put(CategoryDatabaseRepository(), permanent: true);
    Get.put(GovernorateDatabaseRepository(), permanent: true);
    Get.put(StoreDatabaseRepository(), permanent: true);
    Get.put(ReservationDatabaseRepository(), permanent: true);
    Get.put(BookingDatabaseRepository(), permanent: true);
  }
}
