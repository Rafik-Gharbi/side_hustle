import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../helpers/helper.dart';
import '../../../models/balance_transaction.dart';
import '../../../models/user.dart';
import '../../../repositories/balance_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/tutorials/balance_tutorial.dart';
import 'balance_screen.dart';
import 'components/withdrawal_dialog.dart';

enum DepositType { bankCard, installment }

class BalanceController extends GetxController {
  /// Not permanent, use with caution!
  static BalanceController get find => Get.find<BalanceController>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bankNumberController = TextEditingController();
  RxBool isLoading = true.obs;
  int withdrawalsCount = 0;
  bool get hasBankNumber => loggedUser.bankNumber != null;
  late User loggedUser;
  RxBool hasValidatorError = false.obs;
  RxBool hasValidatorErrorSlipDeposit = false.obs;
  XFile? depositSlip;
  List<BalanceTransaction> balanceTransactions = [];
  RxBool isBankNumberConfiscated = false.obs;
  List<TargetFocus> targets = [];
  GlobalKey withdrawBtnKey = GlobalKey();
  GlobalKey depositBtnKey = GlobalKey();
  GlobalKey balanceOverview = GlobalKey();

  static final BalanceController _singleton = BalanceController._internal();

  factory BalanceController() => _singleton;

  BalanceController._internal() {
    loggedUser = AuthenticationService.find.jwtUserData!;
    init();
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedBalanceTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => Get.currentRoute == BalanceScreen.routeName && Get.isRegistered<BalanceController>(), () {
          BalanceTutorial.showTutorial();
          update();
        });
      }
    });
  }

  bool get couldRequestWithdrawal => hasBankNumber && withdrawalsCount < 3 && loggedUser.balance >= 100;

  Future<void> init() async {
    final (result, count) = await BalanceRepository.find.getBalanceTransactions();
    balanceTransactions = result ?? [];
    withdrawalsCount = count;
    if (loggedUser.bankNumber != null) isBankNumberConfiscated.value = true;
    isLoading.value = false;
    update();
  }

  Future<void> requestWithdrawal() async {
    if (formKey.currentState?.validate() ?? false) {
      Get.back(); // close bottomsheet
      hasValidatorError.value = false;
      final amount = double.parse(amountController.text);
      Future.delayed(
        Durations.medium1,
        () => Get.dialog(
          WithdrawalDialog(
            amount: amount,
            isLoading: isLoading,
            onWithdraw: () async {
              isLoading.value = true;
              final result = await BalanceRepository.find.requestWithdrawal(amount: amount - amount * serviceFees);
              if (result) {
                Helper.snackBar(message: 'withdrawal_requested_success');
              } else {
                Helper.snackBar(message: 'withdrawal_request_failed');
              }
              isLoading.value = false;
              init();
              clearWithdrawalFields();
            },
          ),
        ),
      );
    } else {
      hasValidatorError.value = true;
    }
  }

  Future<void> requestDeposit(DepositType type) async {
    if ((formKey.currentState?.validate() ?? false) && (type == DepositType.installment ? depositSlip != null : true)) {
      isLoading.value = true;
      if (type == DepositType.bankCard) {
        Helper.snackBar(message: 'bank_card_not_supported_yet'.tr);
        isLoading.value = false;
        return;
      }
      Get.back(); // close bottomsheet
      hasValidatorError.value = false;
      hasValidatorErrorSlipDeposit.value = false;
      final result = await BalanceRepository.find.requestDeposit(type: type.name, amount: double.parse(amountController.text), depositSlip: depositSlip);
      isLoading.value = false;
      if (result) {
        Helper.snackBar(message: 'deposit_requested_success');
      } else {
        Helper.snackBar(message: 'deposit_request_failed');
      }
      init();
    } else {
      if (type == DepositType.installment ? depositSlip == null : false) hasValidatorErrorSlipDeposit.value = true;
      hasValidatorError.value = true;
    }
  }

  Future<void> upsertBankNumber() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      Get.back(); // close bottomsheet
      hasValidatorError.value = false;
      loggedUser.bankNumber = bankNumberController.text;
      final result = await UserRepository.find.updateUser(loggedUser);
      isLoading.value = false;
      if (result != null) {
        loggedUser = result;
      } else {
        Helper.snackBar(message: 'error_occurred'.tr);
      }
      update();
    } else {
      hasValidatorError.value = true;
    }
  }

  Future<void> addDepositSlipPicture() async {
    try {
      XFile? image = await Helper.pickImage();
      if (image != null) {
        depositSlip = image;
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in addServicePictures:\n$e');
    }
  }

  void clearDepositFields() {
    hasValidatorError.value = false;
    hasValidatorErrorSlipDeposit.value = false;
    amountController.text = '';
    depositSlip = null;
  }

  void clearWithdrawalFields() {
    hasValidatorError.value = false;
    amountController.text = '';
  }
}
