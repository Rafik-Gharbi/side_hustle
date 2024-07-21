import 'package:get/get.dart';

import '../../models/user.dart';

class ChatController extends GetxController {
  List<User> discussionList = [];
  bool isLoading = true;

  ChatController() {
    init();
  }

  Future<void> init() async {
    // discussionList = await ReservationRepository.find.getUserTasksHistory();
    isLoading = false;
    update();
  }
}
