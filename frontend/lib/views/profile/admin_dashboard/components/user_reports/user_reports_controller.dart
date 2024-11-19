import 'package:get/get.dart';

import '../../../../../controllers/main_app_controller.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/report_dto.dart';
import '../../../../../models/user.dart';
import '../../../../../networking/api_base_helper.dart';

class UserReportsController extends GetxController {
  RxBool isLoading = true.obs;
  List<ReportDTO> userReportList = [];
  ReportDTO? highlightedReport;

  UserReportsController() {
    _initSocket();
    Helper.waitAndExecute(
      () => MainAppController.find.socket != null,
      () => MainAppController.find.socket!.emit('getAdminReport', {'jwt': ApiBaseHelper.find.getToken()}),
    );
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminReport');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminReport', (data) {
        userReportList = (data?['reports'] as List?)?.map((e) => ReportDTO.fromJson(e)).toList() ?? [];
        if (Get.arguments != null) highlightedReport = userReportList.cast<ReportDTO?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
        if (highlightedReport != null) {
          Future.delayed(const Duration(milliseconds: 1600), () {
            highlightedReport = null;
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
