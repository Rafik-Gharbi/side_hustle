import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../controllers/main_app_controller.dart';
import '../../models/notification.dart';
import '../../widgets/overflowed_text_with_tooltip.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '/notifications';
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<NotificationsController>(
        initState: (state) => Helper.waitAndExecute(
          () => state.controller != null,
          () {
            state.controller?.page = 0;
            state.controller?.fetchNotifications();
          },
        ),
        builder: (controller) => CustomScaffoldBottomNavigation(
          onBack: () => MainAppController.find.getNotSeenNotifications(),
          appBarTitle: 'Notifications',
          appBarActions: [
            CustomButtons.icon(
              icon: const Icon(Icons.mark_chat_read_outlined, size: 18),
              onPressed: controller.markAllAsRead,
            ),
          ],
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.notificationList.isEmpty
                ? const Center(child: Text('You have no notifications yet!', style: AppFonts.x14Regular))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.notificationList.length,
                      itemBuilder: (context, index) {
                        final notification = controller.notificationList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: 2),
                          child: ListTile(
                            onTap: () => controller.resolveNotificationAction(notification),
                            contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                            shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                            tileColor: notification.seen ? kNeutralLightOpacityColor : kPrimaryOpacityColor,
                            splashColor: notification.seen ? kPrimaryOpacityColor : kPrimaryDark,
                            title: Text(notification.title, style: AppFonts.x15Bold),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OverflowedTextWithTooltip(title: notification.body, style: AppFonts.x14Regular, maxLine: 2, expand: false),
                                if (notification.date != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: Paddings.small),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(Helper.formatDateWithTime(notification.date!), style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                    ),
                                  ),
                              ],
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: kPrimaryColor,
                              child: Icon(getNotificationTypeIcon(notification.type), color: kNeutralColor100),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  IconData getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.reservation:
        return Icons.sticky_note_2_outlined;
      case NotificationType.booking:
        return Icons.book_outlined;
      case NotificationType.chat:
        return Icons.chat_outlined;
      case NotificationType.newTask:
        return Icons.task_outlined;
      case NotificationType.verification:
        return Icons.verified_user_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}
