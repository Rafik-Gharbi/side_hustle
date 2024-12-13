import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/user.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../boost/list_boost/list_boost_screen.dart';
import '../../store/service_history/service_history_screen.dart';
import '../account/components/signup_fields.dart';
import '../admin_dashboard/admin_dashboard_screen.dart';
import '../balance/balance_screen.dart';
import '../favorite/favorite_screen.dart';
import '../../home/home_controller.dart';
import '../../store/my_store/my_store_screen.dart';
import '../../task/task_history/task_history_screen.dart';
import '../../task/task_request/task_request_screen.dart';
import '../referral/referral_screen.dart';
import '../transactions/transactions_screen.dart';
import '../verify_user/verify_user_screen.dart';
import 'components/change_password.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => HoldInSafeArea(
        child: GetBuilder<AuthenticationService>(
          builder: (authService) => GetBuilder<ProfileController>(
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
                appBarTitle: 'profile'.tr,
                body: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kNeutralLightColor, kNeutralColor100],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SizedBox(
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Paddings.extraLarge),
                      child: LoadingRequest(
                        isLoading: controller.isLoading,
                        child: SingleChildScrollView(
                          child: SharedPreferencesService.find.isReady.value && authService.jwtUserData == null
                              ? SizedBox(height: Get.height - 300, child: Buildables.buildLoginRequest(onLogin: controller.init))
                              : controller.loggedInUser == null
                                  ? Buildables.buildLoadingWidget()
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Buildables.userImage(onEdit: controller.uploadFilePicture),
                                            if (controller.profilePicture != null && controller.isUpdatingProfile)
                                              const Positioned.fill(child: Center(child: CircularProgressIndicator(color: kNeutralColor100)))
                                          ],
                                        ),
                                        const SizedBox(height: Paddings.large),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(controller.loggedInUser!.name ?? 'someone'.tr, style: AppFonts.x16Bold),
                                            const SizedBox(width: Paddings.small),
                                            if (controller.loggedInUser?.isVerified == VerifyIdentityStatus.verified)
                                              Padding(
                                                padding: const EdgeInsets.only(right: Paddings.small),
                                                child: Tooltip(message: 'verified_user'.tr, child: const Icon(Icons.verified_outlined, size: 18)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: Paddings.small),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.pin_drop_outlined, size: 14),
                                            const SizedBox(width: Paddings.regular),
                                            Text(controller.loggedInUser!.governorate?.name ?? 'city'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                          ],
                                        ),
                                        const SizedBox(height: Paddings.small),
                                        InkWell(
                                          onTap: () => Get.toNamed(TransactionsScreen.routeName)?.then((value) => controller.update()),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.small),
                                            child: DecoratedBox(
                                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kAccentColor))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.paid_outlined, size: 18, color: kAccentColor),
                                                  const SizedBox(width: Paddings.regular),
                                                  Text(
                                                    '${AuthenticationService.find.jwtUserData!.totalCoins} ${'coins'.tr}',
                                                    style: AppFonts.x14Regular.copyWith(color: kAccentColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: Paddings.small),
                                        InkWell(
                                          onTap: () => Get.toNamed(BalanceScreen.routeName, arguments: controller.loggedInUser)?.then((value) => controller.update()),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.small),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kPrimaryDark))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${'my_balance'.tr}: ${Helper.formatAmount(controller.loggedInUser!.balance)} ${MainAppController.find.currency.value}',
                                                    style: AppFonts.x14Regular.copyWith(color: kPrimaryDark),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: Paddings.exceptional),
                                        DecoratedBox(
                                          decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                                          child: SizedBox(
                                            width: Get.width,
                                            child: Padding(
                                              padding: const EdgeInsets.all(Paddings.large),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(Paddings.large),
                                                    child: Column(
                                                      children: [
                                                        Buildables.buildProfileInfoRow(
                                                          'email'.tr,
                                                          controller.loggedInUser?.email ?? 'not_provided'.tr,
                                                          extraWidget: (controller.loggedInUser?.isMailVerified ?? false) == false
                                                              ? InkWell(
                                                                  onTap: () => Helper.mobileEmailVerification(controller.loggedInUser!.email),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                                                                    child: Text(
                                                                      '(${'verify'.tr})',
                                                                      style: AppFonts.x11Bold.copyWith(
                                                                        color: kErrorColor,
                                                                        decoration: TextDecoration.underline,
                                                                        decorationColor: kErrorColor,
                                                                        height: 1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : null,
                                                        ),
                                                        Buildables.lightDivider(),
                                                        Buildables.buildProfileInfoRow(
                                                          'birthdate'.tr,
                                                          controller.loggedInUser?.birthdate != null ? Helper.formatDate(controller.loggedInUser!.birthdate!) : 'not_provided'.tr,
                                                        ),
                                                        Buildables.lightDivider(),
                                                        Buildables.buildProfileInfoRow('gender'.tr, controller.loggedInUser?.gender?.value.tr ?? 'not_provided'.tr),
                                                        Buildables.lightDivider(),
                                                        Buildables.buildProfileInfoRow(
                                                          'phone'.tr,
                                                          controller.loggedInUser?.phone != null ? formatNumberSync(controller.loggedInUser!.phone!) : 'not_provided'.tr,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: Paddings.large),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                                                    child: Column(
                                                      children: [
                                                        if (AuthenticationService.find.jwtUserData?.role == Role.admin)
                                                          Buildables.buildActionTile(
                                                            actionRequired: controller.adminDashboardActionRequired,
                                                            label: 'admin_dashboard'.tr,
                                                            icon: Icons.dashboard_outlined,
                                                            onTap: () => Get.toNamed(AdminDashboardScreen.routeName)?.then((value) => controller.init()),
                                                          ),
                                                        Buildables.buildActionTile(
                                                          label: 'edit_profile'.tr,
                                                          icon: Icons.edit_outlined,
                                                          onTap: () {
                                                            AuthenticationService.find.loadUserData(controller.loggedInUser);
                                                            Get.bottomSheet(
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: Paddings.exceptional * 3),
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                                                  child: Material(
                                                                    child: DecoratedBox(
                                                                      decoration: const BoxDecoration(color: kNeutralColor100),
                                                                      child: SignUpFields(maxHeight: Get.height * 0.7, user: controller.loggedInUser),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              isScrollControlled: true,
                                                            ).then((_) => controller.init());
                                                          },
                                                        ),
                                                        if (AuthenticationService.find.jwtUserData?.isVerified != VerifyIdentityStatus.verified)
                                                          Buildables.buildActionTile(
                                                            actionRequired: AuthenticationService.find.jwtUserData?.isVerified == VerifyIdentityStatus.pending ? 0 : 1,
                                                            label: 'verify_profile'.tr,
                                                            icon: Icons.verified_outlined,
                                                            onTap: () => Get.toNamed(VerifyUserScreen.routeName),
                                                          ),
                                                        Buildables.buildActionTile(
                                                          label: 'change_password'.tr,
                                                          icon: Icons.password_outlined,
                                                          onTap: () {
                                                            Get.bottomSheet(
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: Paddings.exceptional * 3),
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                                                  child: Material(
                                                                    child: ChangePasswordBottomsheet(user: controller.loggedInUser!),
                                                                  ),
                                                                ),
                                                              ),
                                                              isScrollControlled: true,
                                                            ).then((_) => controller.init());
                                                          },
                                                        ),
                                                        Buildables.buildActionTile(
                                                          label: 'my_bookmarks'.tr,
                                                          icon: Icons.bookmark_add_outlined,
                                                          onTap: () => Get.toNamed(FavoriteScreen.routeName),
                                                        ),
                                                        Buildables.buildActionTile(
                                                          actionRequired: controller.subscribedCategories.isEmpty ? 1 : 0,
                                                          label: 'subscribe_categories'.tr,
                                                          icon: Icons.loyalty_outlined,
                                                          onTap: controller.manageCategoriesSubscription,
                                                        ),
                                                        Buildables.buildActionTile(
                                                          actionRequired: controller.myRequestActionRequired,
                                                          label: 'my_request'.tr,
                                                          icon: Icons.campaign_outlined,
                                                          onTap: () => Get.toNamed(TaskRequestScreen.routeName),
                                                        ),
                                                        Buildables.buildActionTile(
                                                          actionRequired: controller.taskHistoryActionRequired,
                                                          label: 'tasks_history'.tr,
                                                          icon: Icons.history_outlined,
                                                          onTap: () => Get.toNamed(TaskHistoryScreen.routeName),
                                                        ),
                                                        Buildables.buildActionTile(
                                                          actionRequired: controller.serviceHistoryActionRequired,
                                                          label: 'booked_services'.tr,
                                                          icon: Icons.library_books_outlined,
                                                          onTap: () => Get.toNamed(ServiceHistoryScreen.routeName),
                                                        ),
                                                        Buildables.buildActionTile(
                                                          actionRequired: controller.myStoreActionRequired,
                                                          label: 'my_store'.tr,
                                                          icon: Icons.store_outlined,
                                                          onTap: () => Get.toNamed(MyStoreScreen.routeName),
                                                        ),
                                                        if (controller.userHasBoosts)
                                                          Buildables.buildActionTile(
                                                            label: 'my_boosts'.tr,
                                                            icon: Icons.rocket_launch_outlined,
                                                            onTap: () => Get.toNamed(ListBoostScreen.routeName),
                                                          ),
                                                        Buildables.buildActionTile(
                                                          label: 'refer_friend'.tr,
                                                          icon: Icons.group_add_outlined,
                                                          onTap: () => Get.toNamed(ReferralScreen.routeName),
                                                        ),
                                                        Buildables.buildActionTile(
                                                          label: 'logout'.tr,
                                                          icon: Icons.logout_outlined,
                                                          onTap: () => Helper.openConfirmationDialog(
                                                            content: 'logout_msg'.tr,
                                                            onConfirm: AuthenticationService.find.logout,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
}
