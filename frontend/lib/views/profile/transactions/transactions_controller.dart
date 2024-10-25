import 'package:get/get.dart';

import '../../../models/coin_pack_purchase.dart';
import '../../../models/transaction.dart';
import '../../../repositories/transaction_repository.dart';

class TransactionsController extends GetxController {
  bool isLoading = true;
  List<Transaction> transactions = [];
  List<CoinPackPurchase> availableCoinPacks = [];

  TransactionsController() {
    init();
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
    isLoading = false;
    update();
  }
}
