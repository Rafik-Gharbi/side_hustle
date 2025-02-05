import 'package:get/get.dart';

import '../helpers/helper.dart';
import '../networking/api_base_helper.dart';
import '../services/authentication_service.dart';
import '../services/logging/logger_service.dart';

class PaymentRepository extends GetxService {
  static PaymentRepository get find => Get.find<PaymentRepository>();

  /// paymentId, paymentLink
  Future<(String?, String?)> initFlouciPayment({
    required double totalPrice,
    String? contractId,
    String? taskId,
    String? serviceId,
    int? coinPackId,
  }) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        '/payment/flouci',
        sendToken: true,
        body: {
          'contractId': contractId,
          'taskId': taskId,
          'serviceId': serviceId,
          'totalPrice': totalPrice,
          'coinPackId': coinPackId,
          'paymentType': 'flouci',
        },
      );
      if (result['success'] != null && (result['success'] as bool)) {
        return (result['paymentId'] as String?, result['link'] as String?);
      }
      return (null, null);
    } catch (e) {
      if (e.toString().contains('missing_element')) {
        Helper.snackBar(message: 'missing_element'.tr);
      } else if (e.toString().contains('user_not_found')) {
        Helper.snackBar(message: 'user_not_found'.tr);
      } else if (e.toString().contains('contract_not_found')) {
        Helper.snackBar(message: 'contract_not_found'.tr);
      } else if (e.toString().contains('task_not_found')) {
        Helper.snackBar(message: 'task_not_found'.tr);
      } else if (e.toString().contains('service_not_found')) {
        Helper.snackBar(message: 'service_not_found'.tr);
      } else if (e.toString().contains('coin_pack_not_found')) {
        Helper.snackBar(message: 'coin_pack_not_found'.tr);
      } else {
        Helper.snackBar(message: 'error_occurred'.tr);
      }
      LoggerService.logger?.e('Error occured in initFlouciPayment:\n$e');
    }
    return (null, null);
  }

  Future<bool?> verifyFlouciPayment({required String paymentId}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/payment/verify/$paymentId', sendToken: true);
      return result['done'] != null && (result['done'] as bool);
    } catch (e) {
      if (e.toString().contains('missing_element')) {
        Helper.snackBar(message: 'missing_element'.tr);
      } else if (e.toString().contains('payment_not_found')) {
        Helper.snackBar(message: 'payment_not_found'.tr);
      } else if (e.toString().contains('not_allowed')) {
        Helper.snackBar(message: 'not_allowed'.tr);
      } else {
        Helper.snackBar(message: 'error_occurred'.tr);
      }
      LoggerService.logger?.e('Error occured in verifyFlouciPayment:\n$e');
    }
    return null;
  }

  Future<bool> payWithBalance({required double totalPrice, String? contractId, String? taskId, String? serviceId, int? coinPackId}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.post,
        '/payment/balance',
        sendToken: true,
        body: {
          'contractId': contractId,
          'taskId': taskId,
          'serviceId': serviceId,
          'totalPrice': totalPrice,
          'coinPackId': coinPackId,
          'paymentType': 'balance',
        },
      );
      if ((result?['done'] ?? false) == true) {
        AuthenticationService.find.initiateCurrentUser(result['token'], silent: true);
        return true;
      }
      return false;
    } catch (e) {
      if (e.toString().contains('missing_element')) {
        Helper.snackBar(message: 'missing_element'.tr);
      } else if (e.toString().contains('user_not_found')) {
        Helper.snackBar(message: 'user_not_found'.tr);
      } else if (e.toString().contains('contract_not_found')) {
        Helper.snackBar(message: 'contract_not_found'.tr);
      } else if (e.toString().contains('task_not_found')) {
        Helper.snackBar(message: 'task_not_found'.tr);
      } else if (e.toString().contains('service_not_found')) {
        Helper.snackBar(message: 'service_not_found'.tr);
      } else if (e.toString().contains('coin_pack_not_found')) {
        Helper.snackBar(message: 'coin_pack_not_found'.tr);
      } else if (e.toString().contains('not_enough_balance')) {
        Helper.snackBar(message: 'not_enough_balance'.tr);
      } else {
        Helper.snackBar(message: 'error_occurred'.tr);
      }
      LoggerService.logger?.e('Error occured in payWithBalance:\n$e');
    }
    return false;
  }
}
