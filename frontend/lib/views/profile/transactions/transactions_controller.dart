import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/shared_preferences_keys.dart';
import '../../../helpers/helper.dart';
import '../../../models/coin_pack_purchase.dart';
import '../../../models/transaction.dart';
import '../../../repositories/transaction_repository.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/tutorials/transactions_tutorial.dart';
import 'transactions_screen.dart';

class TransactionsController extends GetxController {
  /// Not permanent, use with caution!
  static TransactionsController get find => Get.find<TransactionsController>();
  RxBool isLoading = true.obs;
  List<Transaction> transactions = [];
  List<CoinPackPurchase> availableCoinPacks = [];
  List<TargetFocus> targets = [];
  GlobalKey firstTransactionsKey = GlobalKey();
  GlobalKey coinsOverview = GlobalKey();

  TransactionsController() {
    init();
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value && transactions.isNotEmpty, () {
      if (!(SharedPreferencesService.find.get(hasFinishedTransactionsTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => Get.currentRoute == TransactionsScreen.routeName, () {
          TransactionsTutorial.showTutorial();
          update();
        });
      }
    });
  }

  Future<void> init() async {
    final (transactionList, coinPackList) = await TransactionRepository.find.listTransactionsAndCoinPacks();
    transactions = transactionList ?? [];
    availableCoinPacks = coinPackList ?? [];
    transactions.sort((a, b) => a.createdAt.isBefore(b.createdAt)
        ? 1
        : a.createdAt.isAfter(b.createdAt)
            ? -1
            : 0);
    availableCoinPacks.sort((a, b) => a.createdAt.isBefore(b.createdAt)
        ? 1
        : a.createdAt.isAfter(b.createdAt)
            ? -1
            : 0);
    isLoading.value = false;
    update();
  }
}
