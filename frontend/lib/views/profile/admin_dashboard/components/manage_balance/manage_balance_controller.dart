import 'package:get/get.dart';

import '../../../../../helpers/helper.dart';
import '../../../../../models/balance_transaction.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/admin_repository.dart';

class ManageBalanceController extends GetxController {
  bool isLoading = true;
  List<BalanceTransaction> balanceTransactionList = [];
  BalanceTransaction? highlightedBalanceTransaction;

  ManageBalanceController() {
    _init();
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);

  Future<void> _init() async {
    balanceTransactionList = await AdminRepository.find.listBalanceTransactions() ?? [];
    if (Get.arguments != null) {
      highlightedBalanceTransaction = balanceTransactionList.cast<BalanceTransaction?>().singleWhere((element) => element?.id == Get.arguments, orElse: () => null);
    }
    if (highlightedBalanceTransaction != null) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        highlightedBalanceTransaction = null;
        update();
      });
    }

    isLoading = false;
    update();
  }

  Future<void> rejectBalanceRequest(BalanceTransaction balanceTransaction) async {
    if (balanceTransaction.id == null) return;
    // TODO add resons too choose from with optionally providing a note to get dilivered to the user 
    final result = await AdminRepository.find.updateBalanceTransactionStatus(balanceTransaction.id!, BalanceTransactionStatus.failed);
    if (result) {
      Helper.snackBar(message: 'balance_rejected_successfully'.tr);
    } else {
      Helper.snackBar(message: 'balance_reject_failed'.tr);
    }
  }

  Future<void> acceptBalanceRequest(BalanceTransaction balanceTransaction) async {
    if (balanceTransaction.id == null) return;
    final result = await AdminRepository.find.updateBalanceTransactionStatus(balanceTransaction.id!, BalanceTransactionStatus.completed);
    if (result) {
      Helper.snackBar(message: 'balance_accepted_successfully'.tr);
    } else {
      Helper.snackBar(message: 'balance_accept_failed'.tr);
    }
  }
}
