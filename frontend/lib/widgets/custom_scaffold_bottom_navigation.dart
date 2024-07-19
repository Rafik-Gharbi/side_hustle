import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../services/authentication_service.dart';
import '../services/navigation_history_observer.dart';
import '../views/add_task/add_task_bottomsheet.dart';
import '../views/home/home_screen.dart';
import '../views/profile/profile_screen.dart';
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
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: Get.currentRoute != HomeScreen.routeName && !noAppBar
            ? AppBar(
                title: Text(appBarTitle ?? ''),
                backgroundColor: appBarColor ?? backgroundColor ?? kNeutralColor100,
                actions: appBarActions,
                centerTitle: true,
                bottom: appBarBottom,
                leading: CustomButtons.icon(
                  icon: const Icon(Icons.chevron_left, size: 28),
                  onPressed: () {
                    onBack?.call();
                    if (NavigationHistoryObserver.instance.previousRoute == ProfileScreen.routeName) {
                      Get.back();
                    } else {
                      MainAppController.find.bottomNavIndex.value = 0;
                      if (Get.currentRoute != HomeScreen.routeName) Get.offAllNamed(HomeScreen.routeName);
                    }
                  },
                ),
              )
            : null,
        body: body,
        floatingActionButton: FloatingActionButton(
          onPressed: () => AuthenticationService.find.isUserLoggedIn.value
              ? Get.bottomSheet(const AddTaskBottomsheet(), isScrollControlled: true)
              : Helper.snackBar(message: 'login_add_task_msg'.tr),
          mini: true,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: kNeutralColor100),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Obx(
          () => AnimatedBottomNavigationBar(
            icons: const [Icons.home_outlined, Icons.store_outlined, Icons.chat_outlined, Icons.person_outlined],
            activeIndex: MainAppController.find.bottomNavIndex.value,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            borderColor: kNeutralLightColor,
            splashColor: kPrimaryColor,
            onTap: (index) => MainAppController.find.bottomNavIndex.value = index,
            activeColor: kPrimaryColor,
          ),
        ),
      );
}
