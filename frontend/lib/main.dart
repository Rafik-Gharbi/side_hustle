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
import 'repositories/balance_repository.dart';
import 'repositories/boost_repository.dart';
import 'repositories/chat_repository.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/notification_repository.dart';
import 'repositories/params_repository.dart';
import 'repositories/payment_repository.dart';
import 'repositories/referral_repository.dart';
import 'repositories/reservation_repository.dart';
import 'repositories/review_repository.dart';
import 'repositories/store_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/transaction_repository.dart';
import 'repositories/user_repository.dart';
import 'services/authentication_service.dart';
import 'services/payment_service.dart';
import 'services/theme/theme_service.dart';
import 'views/boost/list_boost/list_boost_controller.dart';
import 'views/boost/list_boost/list_boost_screen.dart';
import 'views/notifications/notification_controller.dart';
import 'views/notifications/notification_screen.dart';
import 'views/profile/admin_dashboard/admin_dashboard_controller.dart';
import 'views/profile/admin_dashboard/admin_dashboard_screen.dart';
import 'views/profile/admin_dashboard/components/feedbacks/feedbacks_controller.dart';
import 'views/profile/admin_dashboard/components/feedbacks/feedbacks_screen.dart';
import 'views/profile/admin_dashboard/components/manage_balance/manage_balance_controller.dart';
import 'views/profile/admin_dashboard/components/manage_balance/manage_balance_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/balance_stats/balance_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/balance_stats/balance_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/category_stats/category_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/category_stats/category_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/chat_stats/chat_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/chat_stats/chat_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/coins_stats/coins_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/coins_stats/coins_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/contract_stats/contract_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/contract_stats/contract_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/favorite_stats/favorite_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/favorite_stats/favorite_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/feedbacks_stats/feedbacks_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/feedbacks_stats/feedbacks_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/governorate_stats/governorate_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/governorate_stats/governorate_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/referrals_stats/referrals_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/referrals_stats/referrals_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/report_stats/report_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/report_stats/report_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/review_stats/review_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/review_stats/review_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/store_stats/store_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/store_stats/store_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/task_stats/task_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/task_stats/task_stats_screen.dart';
import 'views/profile/admin_dashboard/components/stats_screen/user_stats/user_stats_controller.dart';
import 'views/profile/admin_dashboard/components/stats_screen/user_stats/user_stats_screen.dart';
import 'views/splash/splash_screen.dart';
import 'views/support/components/ticket_details.dart';
import 'views/profile/admin_dashboard/components/support_system/support_controller.dart';
import 'views/profile/admin_dashboard/components/support_system/support_screen.dart';
import 'views/profile/admin_dashboard/components/user_reports/user_reports_controller.dart';
import 'views/profile/admin_dashboard/components/user_reports/user_reports_screen.dart';
import 'views/profile/balance/balance_screen.dart';
import 'views/profile/referral/components/referees_screen.dart';
import 'views/profile/referral/referral_controller.dart';
import 'views/profile/referral/referral_screen.dart';
import 'views/profile/transactions/transactions_controller.dart';
import 'views/profile/transactions/transactions_screen.dart';
import 'views/support/customer_support.dart';
import 'views/settings/components/delete_profile.dart';
import 'views/settings/components/privacy_policy_screen.dart';
import 'views/settings/components/terms_condition_screen.dart';
import 'views/store/service_history/service_history_controller.dart';
import 'views/store/service_history/service_history_screen.dart';
import 'views/task/add_task/add_task_bottomsheet.dart';
import 'views/profile/admin_dashboard/components/approve_user/approve_user_controller.dart';
import 'views/profile/admin_dashboard/components/approve_user/approve_user_screen.dart';
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
import 'widgets/coins_market.dart';

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
  runApp(const RestartWidget(child: MyApp()));
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
    if (state == AppLifecycleState.resumed) {
      _checkUserPosition();
      MainAppController.find.checkVersionRequired();
    }
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
        title: 'Dootify',
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
        initialRoute: SplashScreen.routeName,
        navigatorObservers: <NavigationHistoryObserver>[NavigationHistoryObserver()],
        getPages: [
          GetPage(
            name: SplashScreen.routeName,
            page: () => const SplashScreen(),
          ),
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
            name: TransactionsScreen.routeName,
            page: () => const TransactionsScreen(),
            binding: BindingsBuilder.put(() => TransactionsController()),
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
          GetPage(
            name: CoinsMarket.routeName,
            page: () => const CoinsMarket(),
            binding: BindingsBuilder.put(() => CoinsMarketController()),
          ),
          GetPage(
            name: ReferralScreen.routeName,
            page: () => const ReferralScreen(),
            binding: BindingsBuilder.put(() => ReferralController()),
          ),
          GetPage(
            name: RefereesScreen.routeName,
            page: () => const RefereesScreen(),
            binding: BindingsBuilder.put(() => ReferralController()),
          ),
          GetPage(
            name: BalanceScreen.routeName,
            page: () => BalanceScreen(loggedUser: Get.arguments),
          ),
          GetPage(
            name: AdminDashboardScreen.routeName,
            page: () => const AdminDashboardScreen(),
            binding: BindingsBuilder.put(() => AdminDashboardController()),
            children: [
              GetPage(name: UserStatsScreen.routeName, page: () => const UserStatsScreen(), binding: BindingsBuilder.put(() => UserStatsController())),
              GetPage(name: BalanceStatsScreen.routeName, page: () => const BalanceStatsScreen(), binding: BindingsBuilder.put(() => BalanceStatsController())),
              GetPage(name: ContractStatsScreen.routeName, page: () => const ContractStatsScreen(), binding: BindingsBuilder.put(() => ContractStatsController())),
              GetPage(name: TaskStatsScreen.routeName, page: () => const TaskStatsScreen(), binding: BindingsBuilder.put(() => TaskStatsController())),
              GetPage(name: StoreStatsScreen.routeName, page: () => const StoreStatsScreen(), binding: BindingsBuilder.put(() => StoreStatsController())),
              GetPage(name: FeedbacksStatsScreen.routeName, page: () => const FeedbacksStatsScreen(), binding: BindingsBuilder.put(() => FeedbacksStatsController())),
              GetPage(name: ReportStatsScreen.routeName, page: () => const ReportStatsScreen(), binding: BindingsBuilder.put(() => ReportStatsController())),
              GetPage(name: CategoryStatsScreen.routeName, page: () => const CategoryStatsScreen(), binding: BindingsBuilder.put(() => CategoryStatsController())),
              GetPage(name: ChatStatsScreen.routeName, page: () => const ChatStatsScreen(), binding: BindingsBuilder.put(() => ChatStatsController())),
              GetPage(name: CoinsStatsScreen.routeName, page: () => const CoinsStatsScreen(), binding: BindingsBuilder.put(() => CoinsStatsController())),
              GetPage(name: FavoriteStatsScreen.routeName, page: () => const FavoriteStatsScreen(), binding: BindingsBuilder.put(() => FavoriteStatsController())),
              GetPage(name: GovernorateStatsScreen.routeName, page: () => const GovernorateStatsScreen(), binding: BindingsBuilder.put(() => GovernorateStatsController())),
              GetPage(name: ReferralsStatsScreen.routeName, page: () => const ReferralsStatsScreen(), binding: BindingsBuilder.put(() => ReferralsStatsController())),
              GetPage(name: ReviewStatsScreen.routeName, page: () => const ReviewStatsScreen(), binding: BindingsBuilder.put(() => ReviewStatsController())),
            ],
          ),
          GetPage(
            name: ManageBalanceScreen.routeName,
            page: () => const ManageBalanceScreen(),
            binding: BindingsBuilder.put(() => ManageBalanceController()),
          ),
          GetPage(
            name: UserReportsScreen.routeName,
            page: () => const UserReportsScreen(),
            binding: BindingsBuilder.put(() => UserReportsController()),
          ),
          GetPage(
            name: FeedbacksScreen.routeName,
            page: () => const FeedbacksScreen(),
            binding: BindingsBuilder.put(() => FeedbacksController()),
          ),
          GetPage(
            name: SupportScreen.routeName,
            page: () => const SupportScreen(),
            binding: BindingsBuilder.put(() => SupportController()),
          ),
          GetPage(
            name: PrivacyPolicyScreen.routeName,
            page: () => const PrivacyPolicyScreen(),
          ),
          GetPage(
            name: TermsConditionScreen.routeName,
            page: () => const TermsConditionScreen(),
          ),
          GetPage(
            name: DeleteProfile.routeName,
            page: () => const DeleteProfile(),
          ),
          GetPage(
            name: CustomerSupport.routeName,
            page: () => const CustomerSupport(),
          ),
          GetPage(
            name: TicketDetails.routeName,
            page: () => TicketDetails(ticket: Get.arguments),
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
    Get.put(PaymentService(), permanent: true);
    // Repositories
    Get.put(ChatRepository(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(ParamsRepository(), permanent: true);
    Get.put(TaskRepository(), permanent: true);
    Get.put(FavoriteRepository(), permanent: true);
    Get.put(ReservationRepository(), permanent: true);
    Get.put(StoreRepository(), permanent: true);
    Get.put(NotificationRepository(), permanent: true);
    Get.put(ReviewRepository(), permanent: true);
    Get.put(BoostRepository(), permanent: true);
    Get.put(TransactionRepository(), permanent: true);
    Get.put(ReferralRepository(), permanent: true);
    Get.put(BalanceRepository(), permanent: true);
    Get.put(PaymentRepository(), permanent: true);
    // Database repositories
    Get.put(UserDatabaseRepository(), permanent: true);
    Get.put(TaskDatabaseRepository(), permanent: true);
    Get.put(CategoryDatabaseRepository(), permanent: true);
    Get.put(GovernorateDatabaseRepository(), permanent: true);
    Get.put(StoreDatabaseRepository(), permanent: true);
    Get.put(ReservationDatabaseRepository(), permanent: true);
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) => context.findAncestorStateOfType<RestartWidgetState>()?.restartApp();

  @override
  RestartWidgetState createState() => RestartWidgetState();
}

class RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() => setState(() => key = UniqueKey());

  @override
  Widget build(BuildContext context) => KeyedSubtree(key: key, child: widget.child);
}
