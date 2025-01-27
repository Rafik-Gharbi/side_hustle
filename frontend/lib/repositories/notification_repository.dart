import 'package:get/get.dart';

import '../constants/constants.dart';
import '../models/notification.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class NotificationRepository extends GetxService {
  static NotificationRepository get find => Get.find<NotificationRepository>();

  Future<bool> markAsReadNotification({required String idNotification}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/notification/mark-read', body: {'idNotification': idNotification}, sendToken: true);
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in markAsReadNotification:\n$e');
    }
    return false;
  }

  Future<int> getNotSeenNotificationsCount() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/notification/count', sendToken: true);
      return result?['count'] ?? 0;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getNotSeenNotificationsCount:\n$e');
    }
    return 0;
  }

  Future<List<NotificationModel>?> getNotifications({int page = 0, int limit = kLoadMoreLimit}) async {
    try {
      List<NotificationModel>? notifications;
      final result = await ApiBaseHelper().request(RequestType.get, '/notification/list?pageQuery=$page&limitQuery=$limit', sendToken: true);
      notifications = (result?['notificationList'] as List?)?.map((e) => NotificationModel.fromJson(e)).toList();
      return notifications;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getNotifications:\n$e');
    }
    return null;
  }

  Future<bool> markAsReadAllNotification({required List<NotificationModel> notifications}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/notification/mark-read-all', body: notifications.map((e) => e.toJson()).toList(), sendToken: true);
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in markAsReadAllNotification:\n$e');
    }
    return false;
  }

  testNotification() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/notification/test', sendToken: true);
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in testNotification:\n$e');
    }
    return false;
  }
}
