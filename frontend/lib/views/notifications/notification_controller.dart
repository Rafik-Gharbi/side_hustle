import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../networking/api_base_helper.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/helper.dart';
import '../../models/notification.dart';
import '../../models/user.dart';
import '../../repositories/notification_repository.dart';
import '../../services/authentication_service.dart';
import '../profile/approve_user/approve_user_screen.dart';
import '../profile/profile_screen/profile_screen.dart';
import '../store/my_store/my_store_screen.dart';
import '../store/service_history/service_history_screen.dart';
import '../task/task_history/task_history_screen.dart';
import '../task/task_list/task_list_screen.dart';
import '../task/task_request/task_request_screen.dart';

class NotificationsController extends GetxController {
  static NotificationsController get find => Get.find<NotificationsController>();
  final ScrollController scrollController = ScrollController();
  List<NotificationModel> notificationList = [];
  bool isLoading = true;
  bool isEndList = false;
  RxBool isLoadingMore = false.obs;
  int page = 0;

  NotificationsController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
  }

  Future<void> fetchNotifications() async {
    if (page > 0) isLoadingMore.value = true;
    final list = await NotificationRepository.find.getNotifications(page: ++page) ?? [];
    if ((list.isEmpty) || list.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      notificationList = list;
      isLoading = false;
    } else {
      notificationList.addAll(list);
      isLoadingMore.value = false;
    }
    update();
  }

  void markAllAsRead() {
    if (notificationList.any((element) => !element.seen)) {
      Helper.openConfirmationDialog(
        title: 'Are you sure you want to mark all notifications as read?',
        onConfirm: () async {
          await NotificationRepository.find.markAsReadAllNotification(notifications: notificationList.where((element) => !element.seen).toList()).then((value) => _refreshScreen());
          MainAppController.find.getNotSeenNotifications();
        },
      );
    }
  }

  Future<void> resolveNotificationAction(NotificationModel notification) async {
    _markAsRead(notification);
    if (notification.action != null) {
      final decodedAction = jsonDecode(notification.action!);
      switch (notification.type) {
        case NotificationType.chat:
          // TODO add a reminder if a first chat stays more than 24 hours without an answer
          break;
        case NotificationType.booking:
          Future.delayed(const Duration(milliseconds: 600), () {
            if (decodedAction['isOwner'] != null && (decodedAction['isOwner'] as bool)) {
              Get.toNamed(MyStoreScreen.routeName, arguments: decodedAction['serviceId']);
            } else {
              Get.toNamed(ServiceHistoryScreen.routeName, arguments: decodedAction['bookingId']);
            }
          });
          MainAppController.find.manageNavigation(ProfileScreen.routeName);
          break;
        case NotificationType.newTask:
          Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(taskId: decodedAction['taskId']));
          break;
        case NotificationType.reservation:
          Future.delayed(const Duration(milliseconds: 600), () {
            if (decodedAction['isOwner'] != null && (decodedAction['isOwner'] as bool)) {
              Get.toNamed(TaskRequestScreen.routeName, arguments: decodedAction['taskId']);
            } else {
              Get.toNamed(TaskHistoryScreen.routeName, arguments: decodedAction['reservationId']);
            }
          });
          MainAppController.find.manageNavigation(ProfileScreen.routeName);
          break;
        case NotificationType.verification:
          Future.delayed(const Duration(milliseconds: 600), () {
            if (decodedAction['isAdmin'] != null && (decodedAction['isAdmin'] as bool)) {
              Get.toNamed(ApproveUserScreen.routeName, arguments: decodedAction['userId']);
            } else {
              if (AuthenticationService.find.jwtUserData?.id == decodedAction['userId']) {
                if (decodedAction['Approved'] != null && (decodedAction['Approved'] as bool)) {
                  AuthenticationService.find.jwtUserData?.isVerified = VerifyIdentityStatus.verified;
                } else if (decodedAction['Approved'] != null && !(decodedAction['Approved'] as bool)) {
                  AuthenticationService.find.jwtUserData?.isVerified = VerifyIdentityStatus.none;
                }
                Get.toNamed(ProfileScreen.routeName);
              }
            }
          });
          MainAppController.find.manageNavigation(ProfileScreen.routeName);
          break;
        case NotificationType.others:
          break;
      }
    }
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    fetchNotifications().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }

  void _refreshScreen() {
    page = 0;
    fetchNotifications();
  }

  void _markAsRead(NotificationModel notification) {
    if (!notification.seen) {
      NotificationRepository.find.markAsReadNotification(idNotification: notification.id).then((value) {
        _refreshScreen();
        MainAppController.find.getNotSeenNotifications();
      });
    }
  }
}
