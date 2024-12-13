import 'package:get/get.dart';

import '../../../../../controllers/main_app_controller.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/support_ticket.dart';
import '../../../../../models/user.dart';
import '../../../../../networking/api_base_helper.dart';

class SupportController extends GetxController {
  RxBool isLoading = true.obs;
  List<SupportTicket> ticketList = [];
  SupportTicket? highlightedTicket;

  SupportController() {
    _initSocket();
    Helper.waitAndExecute(
      () => MainAppController.find.socket != null,
      () => MainAppController.find.socket!.emit('getAdminSupport', {'jwt': ApiBaseHelper.find.getToken()}),
    );
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminSupport');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminSupport');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminSupport', (data) {
        ticketList = (data?['tickets'] as List?)?.map((e) => SupportTicket.fromJson(e)).toList() ?? [];
        if (Get.arguments != null) highlightedTicket = ticketList.cast<SupportTicket?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
        if (highlightedTicket != null) {
          Future.delayed(const Duration(milliseconds: 1600), () {
            highlightedTicket = null;
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
