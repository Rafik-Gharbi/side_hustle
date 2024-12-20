import 'package:get/get.dart';

import '../../../../../controllers/main_app_controller.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/balance_transaction.dart';
import '../../../../../models/user.dart';
import '../../../../../networking/api_base_helper.dart';

class ManageBalanceController extends GetxController {
  RxBool isLoading = true.obs;
  List<BalanceTransaction> balanceTransactionList = [];
  BalanceTransaction? highlightedBalanceTransaction;

  ManageBalanceController() {
    _initSocket();
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () => MainAppController.find.socket!.emit('getAdminBalance', {'jwt': ApiBaseHelper.find.getToken()}));
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminBalance');
    MainAppController.find.socket?.off('adminBalanceStatus');
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminBalance');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminBalance', (data) {
        balanceTransactionList = (data?['transactions'] as List?)?.map((e) => BalanceTransaction.fromJson(e)).toList() ?? [];
        if (Get.arguments != null) {
          highlightedBalanceTransaction = balanceTransactionList.cast<BalanceTransaction?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
        }
        if (highlightedBalanceTransaction != null) {
          Future.delayed(const Duration(milliseconds: 1600), () {
            highlightedBalanceTransaction = null;
            update();
          });
        }
        isLoading.value = false;
        update();
      });
      MainAppController.find.socket!.on(
        'adminBalanceStatus',
        (data) => Helper.snackBar(message: data?['done'] == true ? 'balance_updated_successfully'.tr : 'balance_update_failed'.tr),
      );
    });
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);

  Future<void> rejectBalanceRequest(BalanceTransaction balanceTransaction) async {
    if (balanceTransaction.id == null) return;
    // TODO add resons too choose from with optionally providing a note to get dilivered to the user
    MainAppController.find.socket!.emit('rejectBalanceRequest', {
      'jwt': ApiBaseHelper.find.getToken(),
      'id': balanceTransaction.id!,
      'status': BalanceTransactionStatus.failed.name,
    });
  }

  Future<void> acceptBalanceRequest(BalanceTransaction balanceTransaction) async {
    if (balanceTransaction.id == null) return;
    MainAppController.find.socket!.emit('acceptBalanceRequest', {
      'jwt': ApiBaseHelper.find.getToken(),
      'id': balanceTransaction.id!,
      'status': BalanceTransactionStatus.completed.name,
    });
  }
}
