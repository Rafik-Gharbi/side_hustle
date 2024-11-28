import 'package:get/get.dart';

import '../../../../../controllers/main_app_controller.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/feedback_dto.dart';
import '../../../../../models/user.dart';
import '../../../../../networking/api_base_helper.dart';

class FeedbacksController extends GetxController {
  RxBool isLoading = true.obs;
  List<FeedbackDTO> feedbackList = [];
  FeedbackDTO? highlightedFeedback;

  FeedbacksController() {
    _initSocket();
    Helper.waitAndExecute(
      () => MainAppController.find.socket != null,
      () => MainAppController.find.socket!.emit('getAdminFeedbacks', {'jwt': ApiBaseHelper.find.getToken()}),
    );
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminFeedbacks');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminFeedbacks');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminFeedbacks', (data) {
        feedbackList = (data?['feedbacks'] as List?)?.map((e) => FeedbackDTO.fromJson(e)).toList() ?? [];
        if (Get.arguments != null) highlightedFeedback = feedbackList.cast<FeedbackDTO?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
        if (highlightedFeedback != null) {
          Future.delayed(const Duration(milliseconds: 1600), () {
            highlightedFeedback = null;
            update();
          });
        }
        isLoading.value = false;
        update();
      });
    });
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);
}
