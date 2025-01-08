import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../../helpers/helper.dart';
import '../../../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../../../models/balance_transaction.dart';
import '../../../models/user.dart';
import '../../../repositories/balance_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/logger_service.dart';

enum DepositType { bankCard, installment }

class BalanceController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bankNumberController = TextEditingController();
  RxBool isLoading = true.obs;
  int withdrawalsCount = 0;
  bool get hasBankNumber => loggedUser.bankNumber != null;
  User loggedUser;
  bool _hasValidatorError = false;
  bool _hasValidatorErrorSlipDeposit = false;
  XFile? depositSlip;
  List<BalanceTransaction> balanceTransactions = [];
  RxBool isBankNumberConfiscated = false.obs;

  bool get hasValidatorErrorSlipDeposit => _hasValidatorErrorSlipDeposit;

  set hasValidatorErrorSlipDeposit(bool value) {
    _hasValidatorErrorSlipDeposit = value;
    update();
  }

  bool get hasValidatorError => _hasValidatorError;

  set hasValidatorError(bool value) {
    _hasValidatorError = value;
    update();
  }

  BalanceController(this.loggedUser) {
    init();
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
      hasValidatorError = false;
      final result = await BalanceRepository.find.requestWithdrawal(amount: double.parse(amountController.text));
      if (result) {
        Helper.snackBar(message: 'withdrawal_requested_success');
      } else {
        Helper.snackBar(message: 'withdrawal_request_failed');
      }
      init();
    } else {
      hasValidatorError = true;
    }
  }

  Future<void> requestDeposit(DepositType type) async {
    if ((formKey.currentState?.validate() ?? false) && (type == DepositType.installment ? depositSlip != null : true)) {
      if (type == DepositType.bankCard) {
        Helper.snackBar(message: 'bank_card_not_supported_yet'.tr);
        return;
      }
      Get.back(); // close bottomsheet
      hasValidatorError = false;
      hasValidatorErrorSlipDeposit = false;
      final result = await BalanceRepository.find.requestDeposit(type: type.name, amount: double.parse(amountController.text), depositSlip: depositSlip);
      if (result) {
        Helper.snackBar(message: 'deposit_requested_success');
      } else {
        Helper.snackBar(message: 'deposit_request_failed');
      }
      init();
    } else {
      if (type == DepositType.installment ? depositSlip == null : false) hasValidatorErrorSlipDeposit = true;
      hasValidatorError = true;
    }
  }

  Future<void> upsertBankNumber() async {
    if (formKey.currentState?.validate() ?? false) {
      Get.back(); // close bottomsheet
      hasValidatorError = false;
      loggedUser.bankNumber = bankNumberController.text;
      final result = await UserRepository.find.updateUser(loggedUser);
      if (result != null) {
        loggedUser = result;
      } else {
        Helper.snackBar(message: 'error_occurred'.tr);
      }
      update();
    } else {
      hasValidatorError = true;
    }
  }

  Future<void> addDepositSlipPicture() async {
    try {
      XFile? image;
      final pickerPlatform = ImagePickerPlatform.getPlatformPicker();
      if (foundation.kIsWeb) {
        image = await pickerPlatform.getImageFromSource(source: ImageSource.gallery);
      } else {
        image = await pickerPlatform.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        depositSlip = image;
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in addServicePictures:\n$e');
    }
  }

  void clearDepositFields() {
    hasValidatorError = false;
    hasValidatorErrorSlipDeposit = false;
    amountController.text = '';
    depositSlip = null;
  }

  void clearWithdrawalFields() {
    hasValidatorError = false;
    amountController.text = '';
  }
}
