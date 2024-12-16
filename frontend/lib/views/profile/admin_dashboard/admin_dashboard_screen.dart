import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import 'components/approve_user/approve_user_screen.dart';
import 'admin_dashboard_controller.dart';
import 'components/feedbacks/feedbacks_screen.dart';
import 'components/manage_balance/manage_balance_screen.dart';
import 'components/support_system/support_screen.dart';
import 'components/user_reports/user_reports_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  static const String routeName = '/admin-dashboard';

  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => HoldInSafeArea(
        child: GetBuilder<AuthenticationService>(
          builder: (authService) => GetBuilder<AdminDashboardController>(
            initState: (state) => Helper.waitAndExecute(() => state.controller != null, () => state.controller!.init()),
            autoRemove: false,
            builder: (controller) => CustomScaffoldBottomNavigation(
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
                        child: Column(
                          children: [
                            GridView.extent(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: Paddings.regular,
                              crossAxisSpacing: Paddings.regular,
                              padding: const EdgeInsets.all(Paddings.large),
                              children: controller.statsMenuButtons
                                  .map(
                                    (e) => InkWell(
                                      onTap: e.onTap,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: kNeutralColor100, borderRadius: regularRadius),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (e.icon != null) ...[
                                              Icon(e.icon, size: 32),
                                              const SizedBox(height: Paddings.regular),
                                            ],
                                            Text(e.label.tr, style: AppFonts.x15Bold),
                                            if (e.carousel != null) e.carousel!.call(e.label)
                                          ],
                                        ),
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
                                      Buildables.buildActionTile(
                                        actionRequired: controller.approveUsersActionRequired.value,
                                        label: 'approve_users'.tr,
                                        icon: Icons.verified_user_outlined,
                                        onTap: () => Get.toNamed(ApproveUserScreen.routeName)?.then((value) => controller.init()),
                                      ),
                                      Buildables.buildActionTile(
                                        actionRequired: controller.manageBalanceActionRequired.value,
                                        label: 'manage_balance'.tr,
                                        icon: Icons.attach_money_outlined,
                                        onTap: () => Get.toNamed(ManageBalanceScreen.routeName)?.then((value) => controller.init()),
                                      ),
                                      Buildables.buildActionTile(
                                        actionRequired: controller.reportsActionRequired.value,
                                        label: 'reports'.tr,
                                        icon: Icons.report_outlined,
                                        onTap: () => Get.toNamed(UserReportsScreen.routeName)?.then((value) => controller.init()),
                                      ),
                                      Buildables.buildActionTile(
                                        actionRequired: controller.feedbacksActionRequired.value,
                                        label: 'feedbacks'.tr,
                                        icon: Icons.feedback_outlined,
                                        onTap: () => Get.toNamed(FeedbacksScreen.routeName)?.then((value) => controller.init()),
                                      ),
                                      Buildables.buildActionTile(
                                        actionRequired: controller.supportActionRequired.value,
                                        label: 'support_system'.tr,
                                        icon: Icons.support_outlined,
                                        onTap: () => Get.toNamed(SupportScreen.routeName)?.then((value) => controller.init()),
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
      );
}
