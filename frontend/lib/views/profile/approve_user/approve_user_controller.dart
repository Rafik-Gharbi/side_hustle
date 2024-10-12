import 'package:get/get.dart';

import '../../../helpers/helper.dart';
import '../../../models/dto/user_approve_dto.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';

class ApproveUserController extends GetxController {
  bool isLoading = true;
  List<UserApproveDTO> userApproveList = [];
  UserApproveDTO? highlightedUserApprove;

  ApproveUserController() {
    _init();
  }

  Future<void> approveUser(User? user) async {
    if (user == null) return;
    final result = await UserRepository.find.approveUser(user);
    if (result) {
      Helper.snackBar(message: 'user_approved_successfully'.tr);
      userApproveList.removeWhere((element) => element.user?.id == user.id);
      update();
    } else {
      Helper.snackBar(message: 'user_not_approved'.tr);
    }
  }

  Future<void> couldNotApprove(User? user) async {
    if (user == null) return;
    final result = await UserRepository.find.notApprovableUser(user);
    if (result) {
      Helper.snackBar(message: 'user_rejected_successfully'.tr);
      userApproveList.removeWhere((element) => element.user?.id == user.id);
      update();
    } else {
      Helper.snackBar(message: 'user_not_rejected'.tr);
    }
  }

  void callUser(User? user) =>
      user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);

  Future<void> _init() async {
    userApproveList = await UserRepository.find.listUsersApprove() ?? [];
    if (Get.arguments != null) highlightedUserApprove = userApproveList.cast<UserApproveDTO?>().singleWhere((element) => element?.user?.id == Get.arguments, orElse: () => null);
    if (highlightedUserApprove != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedUserApprove = null;
        update();
      });
    }

    isLoading = false;
    update();
  }
}
