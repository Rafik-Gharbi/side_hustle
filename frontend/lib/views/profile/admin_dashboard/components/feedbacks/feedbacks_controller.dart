import 'package:get/get.dart';

import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/feedback_dto.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/admin_repository.dart';

class FeedbacksController extends GetxController {
  bool isLoading = true;
  List<FeedbackDTO> feedbackList = [];
  FeedbackDTO? highlightedFeedback;

  FeedbacksController() {
    _init();
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);

  Future<void> _init() async {
    feedbackList = await AdminRepository.find.listFeedbacks() ?? [];
    if (Get.arguments != null) highlightedFeedback = feedbackList.cast<FeedbackDTO?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    if (highlightedFeedback != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedFeedback = null;
        update();
      });
    }

    isLoading = false;
    update();
  }
}
