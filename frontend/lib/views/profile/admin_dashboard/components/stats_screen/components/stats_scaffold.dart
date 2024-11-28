import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../services/navigation_history_observer.dart';
import '../../../../../../services/theme/theme.dart';
import '../../../../../../widgets/custom_buttons.dart';

class StatsScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const StatsScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralLightColor,
      appBar: AppBar(
        backgroundColor: kNeutralColor100,
        title: Text(title, style: AppFonts.x15Bold),
        centerTitle: true,
        leading: CustomButtons.icon(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () {
            // final currentRoute = Get.currentRoute;
            // final previousRoute = NavigationHistoryObserver.instance.previousRouteHistory;
            // final specialRoutes = {
            //   TaskProposalScreen.routeName,
            //   MessagesScreen.routeName,
            //   CoinsMarket.routeName,
            //   RefereesScreen.routeName,
            //   UserReportsScreen.routeName,
            //   FeedbacksScreen.routeName,
            //   ApproveUserScreen.routeName,
            //   ManageBalanceScreen.routeName,
            //   ServiceRequestScreen.routeName
            // };

            // if (specialRoutes.contains(currentRoute) || (currentRoute != AdminDashboardScreen.routeName && previousRoute == AdminDashboardScreen.routeName)) {
            NavigationHistoryObserver.instance.goToPreviousRoute();
            // } else if (NavigationHistoryObserver.instance.isStackHasProfileScreen && currentRoute != ProfileScreen.routeName) {
            //   NavigationHistoryObserver.instance.goToPreviousRoute(popToProfile: true);
            // }
          },
        ),
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kNeutralLightColor, kNeutralColor100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: body,
        ),
      ),
    );
  }
}
