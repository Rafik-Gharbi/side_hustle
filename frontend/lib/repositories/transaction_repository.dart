import 'package:get/get.dart';

import '../helpers/helper.dart';
import '../models/coin_pack.dart';
import '../models/coin_pack_purchase.dart';
import '../models/transaction.dart';
import '../networking/api_base_helper.dart';
import '../services/authentication_service.dart';
import '../services/logging/logger_service.dart';

class TransactionRepository extends GetxService {
  static TransactionRepository get find => Get.find<TransactionRepository>();

  Future<(List<Transaction>?, List<CoinPackPurchase>?)> listTransactionsAndCoinPacks() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/transaction/list', sendToken: true);
      final transactions = (result?['transactions'] as List?)?.map((e) => Transaction.fromJson(e)).toList();
      final coinPacks = result?['coinPacks'] != null ? (result['coinPacks'] as List).map((e) => CoinPackPurchase.fromJson(e)).toList() : null;
      return (transactions, coinPacks);
    } catch (e) {
      LoggerService.logger?.e('Error occured in listTransaction:\n$e');
    }
    return (null, null);
  }

  Future<bool> buyCoinPack(CoinPack pack) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/transaction/buy-coins/${pack.id}', sendToken: true);
      if ((result?['done'] ?? false) == true) {
        AuthenticationService.find.initiateCurrentUser(result['token'], silent: true);
        Helper.snackBar(title: 'success'.tr, message: 'bought_x_coins'.trParams({'coins': pack.totalCoins.toString()}));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in buyCoinPack:\n$e');
    }
    return false;
  }
}
