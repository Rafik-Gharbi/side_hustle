import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/reservation.dart';
import '../../../models/user.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../chat/components/messages_screen.dart';
import '../../review/all_reviews.dart';
import '../../review/rating_overview.dart';
import 'user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = '/user-profile';
  final User? user;
  final Reservation? reservation;
  final RequestStatus requestStatus;
  final void Function()? onReject;
  final void Function()? onAccept;
  final void Function()? onMarkDone;
  final bool isService;
  final RxBool? isLoading;

  const UserProfileScreen({
    super.key,
    this.user,
    this.reservation,
    this.onReject,
    this.onAccept,
    this.onMarkDone,
    this.requestStatus = RequestStatus.finished,
    this.isService = false,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) => GetBuilder<UserProfileController>(
        init: UserProfileController(user),
        tag: 'user-profile-${user?.id}',
        autoRemove: false,
        builder: (controller) => AnimatedContainer(
          duration: Durations.medium1,
          height: controller.showAllReviews ? Get.height * 0.9 : 550,
          child: HoldInSafeArea(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kNeutralLightColor, kNeutralColor100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (controller.showAllReviews)
                          CustomButtons.icon(icon: const Icon(Icons.chevron_left_outlined), onPressed: () => controller.showAllReviews = false)
                        else
                          CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: () => Helper.goBack()),
                        Text(controller.showAllReviews ? 'all_reviews'.tr : 'profile'.tr, style: AppFonts.x15Bold),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: Get.height,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                        child: LoadingRequest(
                          child: SingleChildScrollView(
                            child: controller.user == null
                                ? Buildables.buildLoadingWidget()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: Paddings.extraLarge),
                                      Buildables.userImage(),
                                      const SizedBox(height: Paddings.large),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(controller.user!.name ?? 'someone'.tr, style: AppFonts.x16Bold),
                                          const SizedBox(width: Paddings.small),
                                          Tooltip(message: 'verified_user'.tr, child: const Icon(Icons.verified_outlined, size: 18)),
                                        ],
                                      ),
                                      const SizedBox(height: Paddings.small),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.pin_drop_outlined, size: 14),
                                          const SizedBox(width: Paddings.regular),
                                          Text(controller.user!.governorate?.name ?? 'city'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                        ],
                                      ),
                                      const SizedBox(height: Paddings.exceptional),
                                      if (controller.showAllReviews)
                                        AllReviews(reviews: controller.userReviews)
                                      else
                                        RatingOverview(
                                          onShowAllReviews: () => controller.showAllReviews = true,
                                          rating: controller.user?.rating ?? 0,
                                          reviews: controller.userReviews,
                                        ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onReject != null && onAccept != null && requestStatus == RequestStatus.pending)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                      child: Row(
                        children: [
                          CustomButtons.elevateSecondary(
                            loading: isLoading,
                            title: 'reject'.tr,
                            width: (Get.width - 40) / 2,
                            onPressed: () => onReject!.call(),
                          ),
                          const SizedBox(width: Paddings.regular),
                          CustomButtons.elevatePrimary(
                            loading: isLoading,
                            title: 'accept'.tr,
                            width: (Get.width - 40) / 2,
                            onPressed: () => onAccept!.call(),
                          ),
                        ],
                      ),
                    ),
                  if (requestStatus == RequestStatus.pending && reservation != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_outlined),
                        CustomButtons.text(
                          title: '${'chat_with'.tr} ${user?.name ?? 'user'.tr}',
                          titleStyle: AppFonts.x14Regular,
                          onPressed: () => Get.toNamed(MessagesScreen.routeName, arguments: reservation),
                        ),
                      ],
                    )
                  else if (requestStatus == RequestStatus.confirmed && reservation != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtons.elevateSecondary(
                          title: '${'chat_with'.tr} ${user?.name ?? 'user'.tr}',
                          titleStyle: AppFonts.x14Regular,
                          icon: const Icon(Icons.chat_outlined),
                          width: Get.width - 40,
                          onPressed: () => Get.toNamed(MessagesScreen.routeName, arguments: reservation),
                        ),
                        if (onMarkDone != null) ...[
                          const SizedBox(height: Paddings.regular),
                          if (!isService)
                            CustomButtons.elevatePrimary(
                              loading: isLoading,
                              title: 'mark_task_done'.tr,
                              titleStyle: AppFonts.x14Regular,
                              icon: Icon(Icons.done, color: kNeutralColor100),
                              width: Get.width - 40,
                              onPressed: onMarkDone!,
                            ),
                        ],
                      ],
                    ),
                  const SizedBox(height: Paddings.extraLarge * 2),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildProfileInfoRow(String label, String value) => SizedBox(
        height: 30,
        child: Row(
          children: [
            Text(label, style: AppFonts.x14Bold),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: AppFonts.x14Regular,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      );
}
