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
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../boost/list_boost/list_boost_screen.dart';
import '../../store/service_history/service_history_screen.dart';
import '../account/components/signup_fields.dart';
import '../approve_user/approve_user_screen.dart';
import '../favorite/favorite_screen.dart';
import '../../home/home_controller.dart';
import '../../store/my_store/my_store_screen.dart';
import '../../task/task_history/task_history_screen.dart';
import '../../task/task_request/task_request_screen.dart';
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
              onPopInvoked: (didPop) => didPop
                  ? Future.delayed(const Duration(milliseconds: 200), () {
                      MainAppController.find.bottomNavIndex.value = 0;
                      HomeController.find.update();
                    })
                  : null,
              child: CustomScaffoldBottomNavigation(
                backgroundColor: kNeutralColor100,
                appBarColor: kNeutralLightColor,
                appBarTitle: 'Profile',
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
                          child: SharedPreferencesService.find.isReady && authService.jwtUserData == null
                              ? Buildables.buildLoginRequest(onLogin: controller.init)
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
                                            Text(controller.loggedInUser!.name ?? 'Someone', style: AppFonts.x16Bold),
                                            if (controller.loggedInUser?.isVerified == VerifyIdentityStatus.verified)
                                              const Padding(
                                                padding: EdgeInsets.only(right: Paddings.small),
                                                child: Tooltip(message: 'Verified user', child: Icon(Icons.verified_outlined, size: 18)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: Paddings.small),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.pin_drop_outlined, size: 14),
                                            const SizedBox(width: Paddings.regular),
                                            Text(controller.loggedInUser!.governorate?.name ?? 'City', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                          ],
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
                                                        Buildables.buildProfileInfoRow('email'.tr, controller.loggedInUser?.email ?? 'not_provided'.tr),
                                                        Buildables.lightDivider(),
                                                        Buildables.buildProfileInfoRow(
                                                          'birthdate'.tr,
                                                          controller.loggedInUser?.birthdate != null ? Helper.formatDate(controller.loggedInUser!.birthdate!) : 'not_provided'.tr,
                                                        ),
                                                        Buildables.lightDivider(),
                                                        Buildables.buildProfileInfoRow('gender'.tr, controller.loggedInUser?.gender?.value ?? 'not_provided'.tr),
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
                                                        buildActionTile(
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
                                                          buildActionTile(
                                                            actionRequired: AuthenticationService.find.jwtUserData?.isVerified == VerifyIdentityStatus.pending ? 0 : 1,
                                                            label: 'verify_profile'.tr,
                                                            icon: Icons.verified_outlined,
                                                            onTap: () => Get.toNamed(VerifyUserScreen.routeName),
                                                          ),
                                                        buildActionTile(
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
                                                        buildActionTile(
                                                          label: 'my_bookmarks'.tr,
                                                          icon: Icons.bookmark_add_outlined,
                                                          onTap: () => Get.toNamed(FavoriteScreen.routeName),
                                                        ),
                                                        buildActionTile(
                                                          actionRequired: controller.subscribedCategories.isEmpty ? 1 : 0,
                                                          label: 'subscribe_categories'.tr,
                                                          icon: Icons.loyalty_outlined,
                                                          onTap: controller.manageCategoriesSubscription,
                                                        ),
                                                        if (AuthenticationService.find.jwtUserData?.role != Role.seeker)
                                                          buildActionTile(
                                                            actionRequired: controller.myRequestActionRequired,
                                                            label: 'my_request'.tr,
                                                            icon: Icons.campaign_outlined,
                                                            onTap: () => Get.toNamed(TaskRequestScreen.routeName),
                                                          ),
                                                        buildActionTile(
                                                          actionRequired: controller.taskHistoryActionRequired,
                                                          label: 'tasks_history'.tr,
                                                          icon: Icons.history_outlined,
                                                          onTap: () => Get.toNamed(TaskHistoryScreen.routeName),
                                                        ),
                                                        buildActionTile(
                                                          actionRequired: controller.serviceHistoryActionRequired,
                                                          label: 'booked_services'.tr,
                                                          icon: Icons.library_books_outlined,
                                                          onTap: () => Get.toNamed(ServiceHistoryScreen.routeName),
                                                        ),
                                                        buildActionTile(
                                                          actionRequired: controller.myStoreActionRequired,
                                                          label: 'my_store'.tr,
                                                          icon: Icons.store_outlined,
                                                          onTap: () => Get.toNamed(MyStoreScreen.routeName),
                                                        ),
                                                        if (AuthenticationService.find.jwtUserData?.role == Role.admin)
                                                          buildActionTile(
                                                            actionRequired: controller.approveUsersActionRequired,
                                                            label: 'approve_users'.tr,
                                                            icon: Icons.verified_user_outlined,
                                                            onTap: () => Get.toNamed(ApproveUserScreen.routeName),
                                                          ),
                                                        if (controller.userHasBoosts)
                                                          buildActionTile(
                                                            label: 'my_boosts'.tr,
                                                            icon: Icons.rocket_launch_outlined,
                                                            onTap: () => Get.toNamed(ListBoostScreen.routeName),
                                                          ),
                                                        buildActionTile(
                                                          label: 'logout'.tr,
                                                          icon: Icons.logout_outlined,
                                                          onTap: () => Helper.openConfirmationDialog(
                                                            title: 'Are you sure you want to logout?',
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
