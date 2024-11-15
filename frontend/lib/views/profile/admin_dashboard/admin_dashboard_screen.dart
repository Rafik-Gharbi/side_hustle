import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import 'components/approve_user/approve_user_screen.dart';
import '../../home/home_controller.dart';
import 'admin_dashboard_controller.dart';
import 'components/feedbacks/feedbacks_screen.dart';
import 'components/manage_balance/manage_balance_screen.dart';
import 'components/stats_screen/balance_stats/balance_stats_screen.dart';
import 'components/stats_screen/category_stats/category_stats_screen.dart';
import 'components/stats_screen/chat_stats/chat_stats_screen.dart';
import 'components/stats_screen/coins_stats/coins_stats_screen.dart';
import 'components/stats_screen/contract_stats/contract_stats_screen.dart';
import 'components/stats_screen/favorite_stats/favorite_stats_screen.dart';
import 'components/stats_screen/feedbacks_stats/feedbacks_stats_screen.dart';
import 'components/stats_screen/governorate_stats/governorate_stats_screen.dart';
import 'components/stats_screen/referrals_stats/referrals_stats_screen.dart';
import 'components/stats_screen/report_stats/report_stats_screen.dart';
import 'components/stats_screen/review_stats/review_stats_screen.dart';
import 'components/stats_screen/store_stats/store_stats_screen.dart';
import 'components/stats_screen/task_stats/task_stats_screen.dart';
import 'components/stats_screen/user_stats/user_stats_screen.dart';
import 'components/user_reports/user_reports_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  static const String routeName = '/admin-dashboard';

  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => HoldInSafeArea(
        child: GetBuilder<AuthenticationService>(
          builder: (authService) => GetBuilder<AdminDashboardController>(
            autoRemove: false,
            initState: (state) => Helper.waitAndExecute(() => state.controller != null, () => state.controller!.init()),
            builder: (controller) => PopScope(
              onPopInvokedWithResult: (didPop, result) => didPop
                  ? Future.delayed(const Duration(milliseconds: 200), () {
                      MainAppController.find.bottomNavIndex.value = 0;
                      HomeController.find.update();
                    })
                  : null,
              child: CustomScaffoldBottomNavigation(
                backgroundColor: kNeutralColor100,
                appBarColor: kNeutralLightColor,
                appBarTitle: 'admin_dashboard'.tr,
                body: DecoratedBox(
                  decoration: BoxDecoration(color: kNeutralOpacityColor),
                  child: SizedBox(
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Paddings.extraLarge),
                      child: LoadingRequest(
                        isLoading: controller.isLoading,
                        child: SingleChildScrollView(
                          child: SharedPreferencesService.find.isReady && authService.jwtUserData == null
                              ? SizedBox(height: Get.height - 300, child: Buildables.buildLoginRequest(onLogin: controller.init))
                              : Column(
                                  children: [
                                    GridView.extent(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      maxCrossAxisExtent: 200.0,
                                      mainAxisSpacing: Paddings.regular,
                                      crossAxisSpacing: Paddings.regular,
                                      padding: const EdgeInsets.all(Paddings.large),
                                      children: [
                                        {'user': () => Get.toNamed(AdminDashboardScreen.routeName + UserStatsScreen.routeName)},
                                        {'balance': () => Get.toNamed(AdminDashboardScreen.routeName + BalanceStatsScreen.routeName)},
                                        {'contract': () => Get.toNamed(AdminDashboardScreen.routeName + ContractStatsScreen.routeName)},
                                        {'task': () => Get.toNamed(AdminDashboardScreen.routeName + TaskStatsScreen.routeName)},
                                        {'store': () => Get.toNamed(AdminDashboardScreen.routeName + StoreStatsScreen.routeName)},
                                        {'feedbacks': () => Get.toNamed(AdminDashboardScreen.routeName + FeedbacksStatsScreen.routeName)},
                                        {'report': () => Get.toNamed(AdminDashboardScreen.routeName + ReportStatsScreen.routeName)},
                                        {'category': () => Get.toNamed(AdminDashboardScreen.routeName + CategoryStatsScreen.routeName)},
                                        {'chat': () => Get.toNamed(AdminDashboardScreen.routeName + ChatStatsScreen.routeName)},
                                        {'coins': () => Get.toNamed(AdminDashboardScreen.routeName + CoinsStatsScreen.routeName)},
                                        {'favorite': () => Get.toNamed(AdminDashboardScreen.routeName + FavoriteStatsScreen.routeName)},
                                        {'governorate': () => Get.toNamed(AdminDashboardScreen.routeName + GovernorateStatsScreen.routeName)},
                                        {'referrals': () => Get.toNamed(AdminDashboardScreen.routeName + ReferralsStatsScreen.routeName)},
                                        {'review': () => Get.toNamed(AdminDashboardScreen.routeName + ReviewStatsScreen.routeName)},
                                      ]
                                          .map(
                                            (e) => InkWell(
                                              onTap: e.values.first,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(color: kNeutralColor100, borderRadius: regularRadius),
                                                child: Center(child: Text(e.keys.first.tr)),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    DecoratedBox(
                                      decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: Paddings.extraLarge, horizontal: Paddings.exceptional),
                                        child: SizedBox(
                                          width: Get.width,
                                          child: Column(
                                            children: [
                                              buildActionTile(
                                                actionRequired: controller.approveUsersActionRequired,
                                                label: 'approve_users'.tr,
                                                icon: Icons.verified_user_outlined,
                                                onTap: () => Get.toNamed(ApproveUserScreen.routeName),
                                              ),
                                              buildActionTile(
                                                actionRequired: controller.manageBalanceActionRequired,
                                                label: 'manage_balance'.tr,
                                                icon: Icons.attach_money_outlined,
                                                onTap: () => Get.toNamed(ManageBalanceScreen.routeName),
                                              ),
                                              buildActionTile(
                                                actionRequired: controller.reportsActionRequired,
                                                label: 'reports'.tr,
                                                icon: Icons.report_outlined,
                                                onTap: () => Get.toNamed(UserReportsScreen.routeName),
                                              ),
                                              buildActionTile(
                                                actionRequired: controller.feedbacksActionRequired,
                                                label: 'feedbacks'.tr,
                                                icon: Icons.feedback_outlined,
                                                onTap: () => Get.toNamed(FeedbacksScreen.routeName),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildActionTile({required String label, required IconData icon, required void Function() onTap, int actionRequired = 0}) => Badge(
        offset: const Offset(-45, 19),
        largeSize: 18,
        isLabelVisible: actionRequired > 0,
        label: Text(
          actionRequired.toString(),
          style: AppFonts.x10Bold.copyWith(color: kNeutralColor100),
        ),
        child: CustomButtons.text(
          onPressed: onTap,
          child: ListTile(
            title: Text(label, style: AppFonts.x14Bold),
            contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
            leading: CircleAvatar(radius: 20, backgroundColor: kNeutralLightColor, child: Icon(icon, size: 24)),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ),
      );
}
