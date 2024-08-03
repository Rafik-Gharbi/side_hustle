import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/user.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../chat/components/messages_screen.dart';
import 'user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = '/user-profile';
  final User? user;
  final RequestStatus requestStatus;
  final void Function()? onReject;
  final void Function()? onAccept;
  final void Function()? onMarkDone;
  final bool isService;

  const UserProfileScreen({
    super.key,
    this.user,
    this.onReject,
    this.onAccept,
    this.onMarkDone,
    this.requestStatus = RequestStatus.finished,
    this.isService = false,
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
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.large).copyWith(top: Paddings.extraLarge),
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
                if (onReject != null && onAccept != null && requestStatus == RequestStatus.pending)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
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
                if (requestStatus == RequestStatus.pending)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_outlined),
                      CustomButtons.text(
                        title: 'Chat with ${user?.name ?? 'User'}',
                        titleStyle: AppFonts.x14Regular,
                        onPressed: () => Get.toNamed(MessagesScreen.routeName, arguments: user),
                      ),
                    ],
                  )
                else if (requestStatus == RequestStatus.confirmed && onMarkDone != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtons.elevateSecondary(
                        title: 'Chat with ${user?.name ?? 'User'}',
                        titleStyle: AppFonts.x14Regular,
                        icon: const Icon(Icons.chat_outlined),
                        width: Get.width - 40,
                        onPressed: () => Get.toNamed(MessagesScreen.routeName, arguments: user),
                      ),
                      const SizedBox(height: Paddings.regular),
                      if (!isService)
                        CustomButtons.elevatePrimary(
                          title: 'Mark task as done',
                          titleStyle: AppFonts.x14Regular,
                          icon: const Icon(Icons.done, color: kNeutralColor100),
                          width: Get.width - 40,
                          onPressed: onMarkDone!,
                        ),
                    ],
                  ),
                const SizedBox(height: Paddings.extraLarge * 2),
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
