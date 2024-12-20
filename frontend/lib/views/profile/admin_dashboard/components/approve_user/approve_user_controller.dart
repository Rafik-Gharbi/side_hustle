import 'package:get/get.dart';

import '../../../../../controllers/main_app_controller.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/user_approve_dto.dart';
import '../../../../../models/user.dart';
import '../../../../../networking/api_base_helper.dart';
import '../../admin_dashboard_controller.dart';

class ApproveUserController extends GetxController {
  RxBool isLoading = true.obs;
  List<UserApproveDTO> userApproveList = [];
  UserApproveDTO? highlightedUserApprove;

  ApproveUserController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null && AdminDashboardController.find.isAdminSocketJoined.value, () {
      MainAppController.find.socket!.emit('getAdminApproveUsers', {'jwt': ApiBaseHelper.find.getToken()});
    });
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminApproveUsers');
    MainAppController.find.socket?.off('adminApproveStatus');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminApproveUsers');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminApproveUsers', (data) {
        userApproveList = (data?['users'] as List?)?.map((e) => UserApproveDTO.fromJson(e)).toList() ?? [];
        if (Get.arguments != null) {
          highlightedUserApprove = userApproveList.cast<UserApproveDTO?>().singleWhere((element) => element?.user?.id == Get.arguments, orElse: () => null);
        }
        if (highlightedUserApprove != null) {
          Future.delayed(const Duration(milliseconds: 1600), () {
            highlightedUserApprove = null;
            update();
          });
        }

        isLoading.value = false;
        update();
      });
      MainAppController.find.socket!.on(
        'adminApproveStatus',
        (data) => Helper.snackBar(message: data?['done'] == true ? 'user_updated_successfully'.tr : 'user_not_updated'.tr),
      );
    });
  }

  Future<void> approveUser(User? user) async {
    if (user == null) return;
    MainAppController.find.socket!.emit('acceptApproveUser', {
      'jwt': ApiBaseHelper.find.getToken(),
      'id': user.id!,
    });
  }

  Future<void> couldNotApprove(User? user) async {
    if (user == null) return;
    MainAppController.find.socket!.emit('rejectApproveUser', {
      'jwt': ApiBaseHelper.find.getToken(),
      'id': user.id!,
    });
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);
}
