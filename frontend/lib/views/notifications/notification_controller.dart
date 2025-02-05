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
import '../profile/admin_dashboard/admin_dashboard_screen.dart';
import '../profile/admin_dashboard/components/approve_user/approve_user_screen.dart';
import '../profile/balance/balance_screen.dart';
import '../profile/profile_screen/profile_controller.dart';
import '../profile/transactions/transactions_screen.dart';
import '../review/add_review/add_review_bottomsheet.dart';
import '../store/my_store/my_store_screen.dart';
import '../task/my_offers/my_offers_screen.dart';
import '../task/task_list/task_list_screen.dart';
import '../task/my_request/my_request_screen.dart';

class NotificationsController extends GetxController {
  static NotificationsController get find => Get.find<NotificationsController>();
  final ScrollController scrollController = ScrollController();
  List<NotificationModel> notificationList = [];
  RxBool isLoading = true.obs;
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
      isLoading.value = false;
    } else {
      notificationList.addAll(list);
      isLoadingMore.value = false;
    }
    update();
  }

  void markAllAsRead() {
    if (notificationList.any((element) => !element.seen)) {
      Helper.openConfirmationDialog(
        content: 'mark_notifications_read'.tr,
        onConfirm: () async {
          await NotificationRepository.find.markAsReadAllNotification(notifications: notificationList.where((element) => !element.seen).toList()).then((value) => _refreshScreen());
          await MainAppController.find.getNotSeenNotifications();
          _refreshScreen();
        },
      );
    }
  }

  Future<void> resolveNotificationAction(NotificationModel notification) async {
    _markAsRead(notification);
    final decodedAction = notification.action != null ? jsonDecode(notification.action!) : null;
    switch (notification.type) {
      case NotificationType.chat:
        // TODO add a reminder if a first chat stays more than 24 hours without an answer
        MainAppController.find.manageNavigation(screenIndex: 2);
        break;
      case NotificationType.balance:
        Future.delayed(const Duration(milliseconds: 600), () {
          Get.toNamed(BalanceScreen.routeName, arguments: ProfileController.find.loggedInUser);
        });
        MainAppController.find.manageNavigation(screenIndex: 3);
        break;
      case NotificationType.rewards:
        if (decodedAction?['coinPack'] != null) {
          Future.delayed(const Duration(milliseconds: 600), () {
            Get.toNamed(TransactionsScreen.routeName, arguments: decodedAction?['coinPack']);
          });
        }
        MainAppController.find.manageNavigation(screenIndex: 3);
        break;
      case NotificationType.booking:
        Future.delayed(const Duration(milliseconds: 600), () {
          if (decodedAction?['isOwner'] != null && (decodedAction?['isOwner'] as bool)) {
            Get.toNamed(MyStoreScreen.routeName, arguments: {'serviceId': decodedAction?['serviceId']});
          } else {
            Get.toNamed(MyRequestScreen.routeName, arguments: {'bookingId': decodedAction?['bookingId']});
          }
        });
        MainAppController.find.manageNavigation(screenIndex: 3);
        break;
      case NotificationType.newTask:
        Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(taskId: decodedAction?['taskId']));
        break;
      case NotificationType.reservation:
        Future.delayed(const Duration(milliseconds: 600), () {
          if (decodedAction?['isOwner'] != null && (decodedAction?['isOwner'] as bool)) {
            Get.toNamed(MyRequestScreen.routeName, arguments: {'taskId': decodedAction?['taskId']});
          } else {
            Get.toNamed(MyOffersScreen.routeName, arguments: decodedAction?['reservationId']);
          }
        });
        MainAppController.find.manageNavigation(screenIndex: 3);
        break;
      case NotificationType.verification:
        if (AuthenticationService.find.jwtUserData?.id == decodedAction?['userId']) {
          if (decodedAction?['Approved'] != null && (decodedAction?['Approved'] as bool)) {
            AuthenticationService.find.jwtUserData?.isVerified = VerifyIdentityStatus.verified;
          } else if (decodedAction?['Approved'] != null && !(decodedAction?['Approved'] as bool)) {
            AuthenticationService.find.jwtUserData?.isVerified = VerifyIdentityStatus.none;
          }
        }
        if (decodedAction?['isAdmin'] != null && (decodedAction?['isAdmin'] as bool)) {
          Future.delayed(const Duration(milliseconds: 600), () {
            Future.delayed(const Duration(milliseconds: 600), () {
              Get.toNamed(ApproveUserScreen.routeName, arguments: decodedAction?['userId']);
            });
            Get.toNamed(AdminDashboardScreen.routeName);
          });
        }
        MainAppController.find.manageNavigation(screenIndex: 3);
        break;
      case NotificationType.review:
        if (decodedAction?['userId'] != null) {
          // TODO add more details about the task/service for reminding the user (decodedAction?['serviceId'], decodedAction?['taskId'])
          Get.bottomSheet(AddReviewBottomsheet(user: decodedAction?['userId']), isScrollControlled: true);
        }
        break;
      case NotificationType.others:
        break;
    }
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    fetchNotifications().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }

  Future<void> _refreshScreen() async {
    page = 0;
    await fetchNotifications();
  }

  void _markAsRead(NotificationModel notification) {
    if (!notification.seen && notification.id.isNotEmpty) {
      NotificationRepository.find.markAsReadNotification(idNotification: notification.id).then((value) async {
        await _refreshScreen();
        await MainAppController.find.getNotSeenNotifications();
        update();
      });
    }
  }

  void testNotification() {
    NotificationRepository.find.testNotification().then((value) => _refreshScreen());
  }
}
