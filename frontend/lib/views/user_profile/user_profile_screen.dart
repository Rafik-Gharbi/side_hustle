import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../models/reservation.dart';
import '../../models/user.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import 'user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = '/user-profile';
  final User? user;
  final ReservationStatus reservationStatus;
  final void Function()? onReject;
  final void Function()? onAccept;

  const UserProfileScreen({
    super.key,
    this.user,
    this.onReject,
    this.onAccept,
    this.reservationStatus = ReservationStatus.finished,
  });

  @override
  Widget build(BuildContext context) => HoldInSafeArea(
        child: GetBuilder<UserProfileController>(
          init: UserProfileController(user),
          tag: 'user-profile-${user?.id}',
          autoRemove: false,
          builder: (controller) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kNeutralLightColor, kNeutralColor100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Paddings.extraLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: Get.back),
                      Text('profile'.tr, style: AppFonts.x15Bold),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: Get.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Paddings.extraLarge),
                      child: LoadingRequest(
                        child: SingleChildScrollView(
                          child: controller.user == null
                              ? Buildables.buildLoadingWidget()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Buildables.userImage(),
                                    const SizedBox(height: Paddings.large),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(controller.user!.name ?? 'Someone', style: AppFonts.x16Bold),
                                        const SizedBox(width: Paddings.small),
                                        const Tooltip(message: 'Verified user', child: Icon(Icons.verified_outlined, size: 18)),
                                      ],
                                    ),
                                    const SizedBox(height: Paddings.small),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.pin_drop_outlined, size: 14),
                                        const SizedBox(width: Paddings.regular),
                                        Text(controller.user!.governorate?.name ?? 'City', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                      ],
                                    ),
                                    const SizedBox(height: Paddings.exceptional),
                                    // TODO add user's review (expandable that shows more details like quality of service, fees of service, punctuality, politeness, and a note)
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (onReject != null && onAccept != null && reservationStatus == ReservationStatus.pending)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.large).copyWith(bottom: Paddings.extraLarge * 2, top: Paddings.regular),
                    child: Row(
                      children: [
                        CustomButtons.elevateSecondary(
                          title: 'Reject',
                          width: (Get.width - 40) / 2,
                          onPressed: () => onReject!.call(),
                        ),
                        const SizedBox(width: Paddings.regular),
                        CustomButtons.elevatePrimary(
                          title: 'Accept',
                          width: (Get.width - 40) / 2,
                          onPressed: () => onAccept!.call(),
                        ),
                      ],
                    ),
                  ),
              ],
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
