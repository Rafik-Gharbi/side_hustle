import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/filter_model.dart';
import '../services/navigation_history_observer.dart';
import '../services/theme/theme.dart';
import '../services/theme/theme_service.dart';
import '../views/chat/chat_controller.dart';
import '../views/profile/admin_dashboard/admin_dashboard_screen.dart';
import '../views/profile/admin_dashboard/components/approve_user/approve_user_screen.dart';
import '../views/profile/admin_dashboard/components/feedbacks/feedbacks_screen.dart';
import '../views/profile/admin_dashboard/components/manage_balance/manage_balance_screen.dart';
import '../views/profile/admin_dashboard/components/user_reports/user_reports_screen.dart';
import '../views/profile/profile_screen/components/profile_completion_indicator.dart';
import '../views/profile/profile_screen/profile_controller.dart';
import '../views/profile/referral/components/referees_screen.dart';
import '../views/store/market/market_controller.dart';
import '../views/store/service_request/service_request_screen.dart';
import '../views/task/add_task/add_task_bottomsheet.dart';
import '../views/chat/chat_screen.dart';
import '../views/chat/components/messages_screen.dart';
import '../views/home/home_screen.dart';
import '../views/store/market/market_screen.dart';
import '../views/profile/profile_screen/profile_screen.dart';
import '../views/task/task_filter/more_filters_popup.dart';
import '../views/task/task_proposal/task_proposal_screen.dart';
import 'coins_market.dart';
import 'custom_buttons.dart';
import 'custom_text_field.dart';
import 'hold_in_safe_area.dart';

final screens = {
  'home': const HomeScreen(),
  'stores_market': const MarketScreen(),
  'messages': const ChatScreen(),
  'profile': const ProfileScreen(),
};

class MainScreenWithBottomNavigation extends StatelessWidget {
  static const String routeName = '/home';
  static RxBool isOnTutorial = false.obs;
  static RxBool notShowAgain = false.obs;

  final bool noAppBar;
  final void Function()? onBack;
  final bool hideBottomNavigation;

  const MainScreenWithBottomNavigation({
    super.key,
    this.onBack,
    this.noAppBar = false,
    this.hideBottomNavigation = false,
  });

  bool get isNotMainRoute =>
      Get.currentRoute != routeName && !MainAppController.find.isProfileScreen && !MainAppController.find.isMarketScreen && !MainAppController.find.isChatScreen;

  @override
  Widget build(BuildContext context) {
    bool showConnectivityMsg = true;
    return PopScope(
      canPop: MainAppController.find.bottomNavIndex.value != 0,
      onPopInvokedWithResult: (didPop, result) {
        if (isOnTutorial.value) return;
        if (MainAppController.find.bottomNavIndex.value != 0) {
          MainAppController.find.bottomNavIndex.value = 0;
        } else {
          SystemNavigator.pop();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: kNeutralColor100,
          appBar: noAppBar || MainAppController.find.isHomeScreen
              ? null
              : AppBar(
                  title: Text(screens.keys.toList()[MainAppController.find.bottomNavIndex.value].tr, style: AppFonts.x16Bold),
                  backgroundColor: MainAppController.find.isProfileScreen ? kNeutralLightColor : kNeutralColor100,
                  actions: resolveScreenActions(),
                  centerTitle: true,
                  bottom: resolveScreenAppBarBottom(),
                  leading: isNotMainRoute
                      ? CustomButtons.icon(
                          icon: Icon(Icons.chevron_left, size: 28, color: kBlackColor),
                          onPressed: () => onBackButtonPressed(),
                        )
                      : const SizedBox(),
                ),
          body: HoldInSafeArea(
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  Obx(
                    () => (!MainAppController.find.hasInternetConnection.value || !MainAppController.find.isBackReachable.value) && showConnectivityMsg
                        ? DecoratedBox(
                            decoration: BoxDecoration(color: kErrorColor.withOpacity(0.8)),
                            child: SizedBox(
                              width: Get.width,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        !MainAppController.find.hasInternetConnection.value
                                            ? 'offline_msg'.tr
                                            : !MainAppController.find.isBackReachable.value
                                                ? 'server_offline_msg'.tr
                                                : 'error_occurred'.tr,
                                        style: AppFonts.x12Bold.copyWith(color: kNeutralColor100),
                                        softWrap: true,
                                      ),
                                    ),
                                    CustomButtons.icon(
                                      icon: Icon(Icons.close, color: kNeutralColor100),
                                      onPressed: () => setState(() => showConnectivityMsg = false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => Expanded(
                      child: IndexedStack(
                        index: MainAppController.find.bottomNavIndex.value,
                        children: screens.values.toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: hideBottomNavigation
              ? null
              : FloatingActionButton(
                  onPressed: MainAppController.find.isConnected
                      ? () => Helper.verifyUser(
                            isVerified: true,
                            loginErrorMsg: 'login_add_task_msg'.tr,
                            () => Get.bottomSheet(const AddTaskBottomsheet(), isScrollControlled: true, backgroundColor: Colors.transparent),
                          )
                      : null,
                  mini: true,
                  shape: const CircleBorder(),
                  child: Icon(Icons.add, color: ThemeService.find.isDark ? kBlackColor : kNeutralColor100),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: hideBottomNavigation
              ? null
              : Obx(
                  () => AnimatedBottomNavigationBar(
                    backgroundColor: kNeutralColor100,
                    builder: (widget, index, isActive) {
                      widget = Icon((widget as Icon).icon, color: isActive ? kPrimaryColor : kBlackColor);
                      return index == 2 // Chat
                          ? Obx(
                              () => Badge(
                                offset: const Offset(-28, 8),
                                isLabelVisible: MainAppController.find.notSeenMessages.value > 0,
                                label: Text(
                                  MainAppController.find.notSeenMessages.value.toString(),
                                  style: AppFonts.x10Bold.copyWith(color: ThemeService.find.isDark ? kBlackColor : kNeutralColor100),
                                ),
                                child: SizedBox(width: 60, height: 60, child: widget),
                              ),
                            )
                          : index == 3 // Profile
                              ? Obx(
                                  () => Badge(
                                    offset: const Offset(-28, 8),
                                    isLabelVisible: MainAppController.find.profileActionRequired.value > 0,
                                    label: Text(
                                      MainAppController.find.profileActionRequired.value.toString(),
                                      style: AppFonts.x10Bold.copyWith(color: ThemeService.find.isDark ? kBlackColor : kNeutralColor100),
                                    ),
                                    child: SizedBox(width: 60, height: 60, child: widget),
                                  ),
                                )
                              : widget;
                    },
                    icons: const [Icons.home_outlined, Icons.store_outlined, Icons.chat_outlined, Icons.person_outlined],
                    activeIndex: MainAppController.find.bottomNavIndex.value,
                    gapLocation: GapLocation.center,
                    notchSmoothness: NotchSmoothness.defaultEdge,
                    borderColor: kNeutralLightColor,
                    splashColor: kPrimaryColor,
                    onTap: (index) => MainAppController.find.manageNavigation(screenIndex: index),
                    activeColor: kPrimaryColor,
                  ),
                ),
        ),
      ),
    );
  }

  void onBackButtonPressed() {
    onBack?.call();
    final currentRoute = Get.currentRoute;
    final previousRoute = NavigationHistoryObserver.instance.previousRouteHistory;
    final specialRoutes = {
      TaskProposalScreen.routeName,
      MessagesScreen.routeName,
      CoinsMarket.routeName,
      RefereesScreen.routeName,
      UserReportsScreen.routeName,
      FeedbacksScreen.routeName,
      ApproveUserScreen.routeName,
      ManageBalanceScreen.routeName,
      ServiceRequestScreen.routeName
    };

    if (specialRoutes.contains(currentRoute) || (currentRoute != AdminDashboardScreen.routeName && previousRoute == AdminDashboardScreen.routeName)) {
      NavigationHistoryObserver.instance.goToPreviousRoute();
      // } else if (NavigationHistoryObserver.instance.isStackHasProfileScreen && !MainAppController.find.isProfileScreen) {
      //   NavigationHistoryObserver.instance.goToPreviousRoute(popToProfile: true);
    } else {
      MainAppController.find.bottomNavIndex.value = 0;
      if (currentRoute != routeName) Get.offAllNamed(routeName);
    }
  }

  List<Widget>? resolveScreenActions() {
    if (MainAppController.find.isMarketScreen) {
      return [
        CustomButtons.icon(
          key: MarketController.find.searchIconKey,
          icon: Icon(MarketController.find.openSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined, color: kBlackColor),
          onPressed: () => MarketController.find.openSearchBar.value = !MarketController.find.openSearchBar.value,
        ),
        CustomButtons.icon(
          key: MarketController.find.advancedFilterKey,
          icon: Icon(Icons.filter_alt_outlined, color: kBlackColor),
          onPressed: () => Get.dialog(
            MoreFiltersPopup(
              updateFilter: (filter) => MarketController.find.filterModel = filter,
              clearFilter: () => MarketController.find.filterModel = FilterModel(),
              filter: MarketController.find.filterModel,
              isTasks: false,
            ),
          ),
        ),
      ];
    } else if (MainAppController.find.isChatScreen) {
      return [
        CustomButtons.icon(
          key: ChatController.find.searchIconKey,
          icon: Icon(ChatController.find.openSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined, color: kBlackColor),
          onPressed: () {
            ChatController.find.openSearchBar.value = !ChatController.find.openSearchBar.value;
            if (!ChatController.find.openSearchBar.value) {
              ChatController.find.searchDiscussionsController.clear();
              ChatController.find.searchChatBubbles('');
            }
          },
        ),
      ];
    } else if (MainAppController.find.isProfileScreen) {
      return [
        Obx(
          () {
            return MainAppController.find.showProfileCompletionIndicator.value && !(ProfileController.find.loggedInUser?.isProfileCompleted ?? true)
                ? ProfileCompletionIndicator(user: ProfileController.find.loggedInUser!)
                : const SizedBox.shrink();
          },
        ),
      ];
    }
    return null;
  }

  PreferredSizeWidget? resolveScreenAppBarBottom() {
    if (MainAppController.find.isMarketScreen) {
      return MarketController.find.openSearchBar.value
          ? AppBar(
              backgroundColor: kNeutralColor100,
              leading: const SizedBox(),
              flexibleSpace: CustomTextField(
                fieldController: MarketController.find.searchStoreController,
                hintText: 'search_store'.tr,
                suffixIcon: CustomButtons.icon(
                  icon: const Icon(Icons.search, color: kPrimaryColor),
                  onPressed: MarketController.find.searchStoreController.text.isNotEmpty
                      ? () {
                          MarketController.find.page = 0;
                          MarketController.find.fetchSearchedStores();
                        }
                      : () {},
                ),
                fillColor: Colors.white,
                onChanged: (value) => Helper.onSearchDebounce(
                  () {
                    MarketController.find.page = 0;
                    MarketController.find.fetchSearchedStores();
                  },
                ),
              ),
            )
          : null;
    } else if (MainAppController.find.isChatScreen) {
      return ChatController.find.openSearchBar.value
          ? AppBar(
              backgroundColor: kNeutralColor100,
              leading: const SizedBox(),
              flexibleSpace: CustomTextField(
                fieldController: ChatController.find.searchDiscussionsController,
                hintText: 'search_discussions'.tr,
                suffixIcon: CustomButtons.icon(
                  icon: const Icon(Icons.search, color: kPrimaryColor),
                  onPressed: ChatController.find.searchDiscussionsController.text.isNotEmpty
                      ? () {
                          ChatController.find.page = 0;
                          ChatController.find.searchChatBubbles(ChatController.find.searchDiscussionsController.text);
                        }
                      : () {},
                ),
                fillColor: Colors.white,
                onChanged: (value) => Helper.onSearchDebounce(() => ChatController.find.searchChatBubbles(value)),
                focusNode: ChatController.find.searchDiscussionsFocusNode,
              ),
            )
          : null;
    }
    return null;
  }
}
