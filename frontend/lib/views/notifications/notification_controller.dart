import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../networking/api_base_helper.dart';
import '../../helpers/helper.dart';
import '../../models/notification.dart';
import '../../repositories/notification_repository.dart';

class NotificationsController extends GetxController {
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
    if (page > 1) isLoadingMore.value = true;
    notificationList = await NotificationRepository.find.getNotifications(page: ++page) ?? [];
    if ((notificationList.isEmpty) || notificationList.length < kLoadMoreLimit) isEndList = true;
    if (page == 1) {
      isLoading = false;
    } else {
      isLoadingMore.value = false;
    }
    update();
  }

  Future<void> _loadMore() async {
    if (isEndList || ApiBaseHelper.find.blockRequest) return;
    ApiBaseHelper.find.blockRequest = true;
    fetchNotifications().then((value) => Future.delayed(Durations.long1, () => ApiBaseHelper.find.blockRequest = false));
  }

  void markAllAsRead() {
    if (notificationList.any((element) => !element.seen)) {
      Helper.openConfirmationDialog(
        title: 'Are you sure you want to mark all notifications as read?',
        onConfirm: () =>
            NotificationRepository.find.markAsReadAllNotification(notifications: notificationList.where((element) => !element.seen).toList()).then((value) => refreshScreen()),
      );
    }
  }

  void markAsRead(NotificationModel notification) {
    if (!notification.seen) {
      NotificationRepository.find.markAsReadNotification(idNotification: notification.id).then((value) => refreshScreen());
    }
  }

  void refreshScreen() {
    page = 0;
    fetchNotifications();
  }
}
