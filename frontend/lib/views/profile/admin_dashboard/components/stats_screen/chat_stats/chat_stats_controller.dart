import 'package:get/get.dart';

import '../../../../../../controllers/main_app_controller.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/dto/discussion_dto.dart';
import '../../../../../../networking/api_base_helper.dart';
import '../../../admin_dashboard_controller.dart';
import '../components/pie_chart.dart';

class ChatStatsController extends GetxController {
  bool isLoading = true;
  Map<DateTime, double> discussionsPerDayData = {};
  List<PieChartModel> discussionsPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ChatStatsController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      MainAppController.find.socket!.emit('getAdminChatStatsData', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminChatStatsData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminChatStatsData', (data) async {
        final discussionsList = (data?['chatStats']?['discussionsList'] as List?)?.map((e) => DiscussionDTO.fromJson(e)).toList() ?? [];
        if (discussionsList.isNotEmpty) _initChartPerDayData(discussionsList);
        AdminDashboardController.totalDiscussions.value = discussionsList.length;
        AdminDashboardController.activeDiscussions.value = data?['chatStats']?['activeCount'] ?? 0;
        isLoading = false;
        update();
      });
    });
  }

  void _initChartPerDayData(List<DiscussionDTO> discussionList) {
    discussionsPerDayData.clear();
    for (final discussion in discussionList) {
      DateTime date = discussion.lastMessageDate!.normalize();
      if (discussionsPerDayData.containsKey(date)) {
        discussionsPerDayData[date] = discussionsPerDayData[date]! + 1;
      } else {
        discussionsPerDayData.putIfAbsent(date, () => 1);
      }
    }
    discussionsPerDayData = Helper.sortByDateDesc(discussionsPerDayData);
  }
}
