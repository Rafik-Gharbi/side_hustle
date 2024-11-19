import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/user.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';

class UserStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> usersPerDayData = {};

  UserStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminUserStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminUserStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminUserStatsData', (data) async {
        final userList = (data?['userStats']?['users'] as List?)?.map((e) => User.fromJson(e)).toList() ?? [];
        if (userList.isNotEmpty) _initUsersPerDayData(userList);
        AdminDashboardController.totalUsers.value = userList.length;
        AdminDashboardController.activeUsers.value = data?['userStats']?['activeCount'] ?? 0;
        AdminDashboardController.verifiedUsers.value = userList.where((element) => element.isVerified == VerifyIdentityStatus.verified).length;
        isLoading = false;
        update();
      });
    });
  }

  void _initUsersPerDayData(List<User> userList) {
    usersPerDayData.clear();
    for (final user in userList) {
      DateTime date = user.createdAt!.normalize();
      if (usersPerDayData.containsKey(date)) {
        usersPerDayData[date] = usersPerDayData[date]! + 1;
      } else {
        usersPerDayData.putIfAbsent(date, () => 1);
      }
    }
    usersPerDayData = Helper.sortByDateDesc(usersPerDayData);
  }
}
