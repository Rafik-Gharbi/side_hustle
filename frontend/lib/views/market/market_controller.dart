import 'package:get/get.dart';

import '../../models/user.dart';

class MarketController extends GetxController {
  List<User> discussionList = [];
  bool isLoading = true;

  MarketController() {
    init();
  }

  Future<void> init() async {
    // discussionList = await ReservationRepository.find.getUserTasksHistory();
    isLoading = false;
    update();
  }
}
