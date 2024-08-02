import 'package:get/get.dart';

import '../../../helpers/helper.dart';
import '../../../models/dto/user_approve_dto.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';

class ApproveUserController extends GetxController {
  bool isLoading = true;
  List<UserApproveDTO> userApproveList = [];

  ApproveUserController() {
    _init();
  }

  Future<void> approveUser(User? user) async {
    if (user == null) return;
    final result = await UserRepository.find.approveUser(user);
    if (result) {
      Helper.snackBar(message: 'User approved successfully');
      userApproveList.removeWhere((element) => element.user?.id == user.id);
      update();
    } else {
      Helper.snackBar(message: 'User not approved');
    }
  }

  Future<void> couldNotApprove(User? user) async {
    if (user == null) return;
    final result = await UserRepository.find.notApprovableUser(user);
    if (result) {
      Helper.snackBar(message: 'User rejected successfully');
      userApproveList.removeWhere((element) => element.user?.id == user.id);
      update();
    } else {
      Helper.snackBar(message: 'User has not been rejected');
    }
  }

  void callUser(User? user) =>
      user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'Could not call, phone number not available');

  Future<void> _init() async {
    userApproveList = await UserRepository.find.listUsersApprove() ?? [];
    isLoading = false;
    update();
  }
}
