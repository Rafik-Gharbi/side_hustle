import 'package:get/get.dart';

import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/user.dart';
import '../../../../../../repositories/admin_repository.dart';

class UserStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> usersPerDayData = {};
  int totalUsers = 100;
  int activeUsers = 30;
  int verifiedUsers = 45;

  UserStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (userList, activeCount) = await AdminRepository.find.getUserStatsData();
    if (userList != null) _initUsersPerDayData(userList);
    totalUsers = userList?.length ?? 0;
    activeUsers = activeCount ?? 0;
    verifiedUsers = userList?.where((element) => element.isVerified == VerifyIdentityStatus.verified).length ?? 0;
    isLoading = false;
    update();
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
