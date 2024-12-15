import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../services/navigation_history_observer.dart';
import '../services/theme/theme.dart';
import '../views/profile/admin_dashboard/admin_dashboard_screen.dart';
import '../views/profile/admin_dashboard/components/approve_user/approve_user_screen.dart';
import '../views/profile/admin_dashboard/components/feedbacks/feedbacks_screen.dart';
import '../views/profile/admin_dashboard/components/manage_balance/manage_balance_screen.dart';
import '../views/profile/admin_dashboard/components/user_reports/user_reports_screen.dart';
import '../views/profile/referral/components/referees_screen.dart';
import '../views/store/service_request/service_request_screen.dart';
import '../views/task/add_task/add_task_bottomsheet.dart';
import '../views/chat/chat_screen.dart';
import '../views/chat/components/messages_screen.dart';
import '../views/home/home_screen.dart';
import '../views/store/market/market_screen.dart';
import '../views/profile/profile_screen/profile_screen.dart';
import '../views/task/task_proposal/task_proposal_screen.dart';
import 'coins_market.dart';
import 'custom_buttons.dart';

class CustomScaffoldBottomNavigation extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBarBottom;
  final String? appBarTitle;
  final Color? backgroundColor;
  final Color? appBarColor;
  final List<Widget>? appBarActions;
  final bool noAppBar;
  final void Function()? onBack;
  final bool hideBottomNavigation;

  const CustomScaffoldBottomNavigation({
    super.key,
    required this.body,
    this.appBarTitle,
    this.backgroundColor,
    this.appBarColor,
    this.appBarActions,
    this.appBarBottom,
    this.onBack,
    this.noAppBar = false,
    this.hideBottomNavigation = false,
  });

  bool get isNotMainRoute =>
      Get.currentRoute != HomeScreen.routeName &&
      Get.currentRoute != ProfileScreen.routeName &&
      Get.currentRoute != MarketScreen.routeName &&
      Get.currentRoute != ChatScreen.routeName;

  @override
  Widget build(BuildContext context) {
    bool showConnectivityMsg = true;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: Get.currentRoute != HomeScreen.routeName && !noAppBar
          ? AppBar(
              title: Text(appBarTitle ?? ''),
              backgroundColor: appBarColor ?? backgroundColor ?? kNeutralColor100,
              actions: appBarActions,
              centerTitle: true,
              bottom: appBarBottom,
              leading: isNotMainRoute
                  ? CustomButtons.icon(
                      icon: const Icon(Icons.chevron_left, size: 28),
                      onPressed: () => onBackButtonPressed(),
                    )
                  : const SizedBox(),
            )
          : null,
      body: StatefulBuilder(
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
                                icon: const Icon(Icons.close, color: kNeutralColor100),
                                onPressed: () => setState(() => showConnectivityMsg = false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: hideBottomNavigation
          ? null
          : FloatingActionButton(
              onPressed: () => Helper.verifyUser(
                isVerified: true,
                loginErrorMsg: 'login_add_task_msg'.tr,
                () => Get.bottomSheet(const AddTaskBottomsheet(), isScrollControlled: true),
              ),
              mini: true,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: kNeutralColor100),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: hideBottomNavigation
          ? null
          : Obx(
              () => AnimatedBottomNavigationBar(
                builder: (widget, index, isActive) {
                  widget = Icon((widget as Icon).icon, color: isActive ? kPrimaryColor : kBlackColor);
                  return index == 2 // Chat
                      ? Obx(
                          () => Badge(
                            offset: const Offset(-28, 8),
                            isLabelVisible: MainAppController.find.notSeenMessages.value > 0,
                            label: Text(
                              MainAppController.find.notSeenMessages.value.toString(),
                              style: AppFonts.x10Bold.copyWith(color: kNeutralColor100),
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
                                  style: AppFonts.x10Bold.copyWith(color: kNeutralColor100),
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
    } else if (NavigationHistoryObserver.instance.isStackHasProfileScreen && currentRoute != ProfileScreen.routeName) {
      NavigationHistoryObserver.instance.goToPreviousRoute(popToProfile: true);
    } else {
      MainAppController.find.bottomNavIndex.value = 0;
      if (currentRoute != HomeScreen.routeName) Get.offAllNamed(HomeScreen.routeName);
    }
  }
}
