import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/balance_transaction.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class BalanceRepository extends GetxService {
  static BalanceRepository get find => Get.find<BalanceRepository>();

  Future<bool> requestWithdrawal({required double amount}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/balance/request-withdrawal', body: {'amount': amount}, sendToken: true);
      return result['done'];
    } catch (e) {
      LoggerService.logger?.e('Error occured in requestWithdrawal:\n$e');
    }
    return false;
  }

  Future<bool> requestDeposit({required String type, required double amount, XFile? depositSlip}) async {
    try {
      Map<String, dynamic> data = {'type': type, 'amount': amount};
      if (depositSlip != null) data.putIfAbsent('depositSlip', () => depositSlip.name);
      final result = await ApiBaseHelper().request(
        RequestType.post,
        '/balance/request-deposit',
        body: data,
        files: depositSlip != null ? [depositSlip] : null,
        sendToken: true,
      );
      return result['done'];
    } catch (e) {
      LoggerService.logger?.e('Error occured in requestDeposit:\n$e');
    }
    return false;
  }

  Future<(List<BalanceTransaction>?, int)> getBalanceTransactions() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/balance/transactions', sendToken: true);
      return (
        result?['transactions'] != null ? (result['transactions'] as List).map((e) => BalanceTransaction.fromJson(e)).toList() : null,
        result?['withdrawalCount'] as int? ?? 0
      );
    } catch (e) {
      LoggerService.logger?.e('Error occured in getBalanceTransactions:\n$e');
    }
    return (null, 0);
  }
}
