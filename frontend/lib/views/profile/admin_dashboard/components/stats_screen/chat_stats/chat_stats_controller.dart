import 'package:get/get.dart';

import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../models/dto/discussion_dto.dart';
import '../../../../../../repositories/admin_repository.dart';
import '../components/pie_chart.dart';

class ChatStatsController extends GetxController {
  bool isLoading = true;
  int totalDiscussions = 0;
  int activeDiscussions = 0;
  Map<DateTime, double> discussionsPerDayData = {};
  List<PieChartModel> discussionsPerCategoryData = [];
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    update();
  }

  ChatStatsController() {
    _init();
  }

  Future<void> _init() async {
    final (discussionsList, activeCount) = await AdminRepository.find.getChatStatsData();
    if (discussionsList != null) {
      _initChartPerDayData(discussionsList);
    }
    totalDiscussions = discussionsList?.length ?? 0;
    activeDiscussions = activeCount ?? 0;
    isLoading = false;
    update();
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
