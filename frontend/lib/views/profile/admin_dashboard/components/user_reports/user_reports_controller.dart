import 'package:get/get.dart';

import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/report_dto.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/admin_repository.dart';

class UserReportsController extends GetxController {
  bool isLoading = true;
  List<ReportDTO> userReportList = [];
  ReportDTO? highlightedReport;

  UserReportsController() {
    _init();
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);

  Future<void> _init() async {
    userReportList = await AdminRepository.find.listUserReports() ?? [];
    if (Get.arguments != null) highlightedReport = userReportList.cast<ReportDTO?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    if (highlightedReport != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedReport = null;
        update();
      });
    }

    isLoading = false;
    update();
  }
}
