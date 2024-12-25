import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/colors.dart';
import '../helpers/helper.dart';
import '../repositories/payment_repository.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/hold_in_safe_area.dart';
import 'authentication_service.dart';

class PaymentService extends GetxService {
  static PaymentService get find => Get.find<PaymentService>();
  WebViewController? _webViewController;

  /// Use [contractId] for tasks and services payment
  /// Use [taskId] or [serviceId] for boost budget payment
  /// Use [coinPackId] for pack coins purchase
  /// Please note providing none of these will result an exception
  Future<bool?> initFlouciPayment(double totalPrice, {String? contractId, String? taskId, String? serviceId, int? coinPackId}) async {
    assert(
      taskId != null || serviceId != null || coinPackId != null || contractId != null,
      'Payment should refer to an object (taskId, serviceId, coinPackId, or reservationId)',
    );
    final (paymentId, paymentLink) = await PaymentRepository.find.initFlouciPayment(
      totalPrice: totalPrice,
      contractId: contractId,
      taskId: taskId,
      serviceId: serviceId,
      coinPackId: coinPackId,
    );
    if (paymentLink != null && paymentId != null) {
      void backToInitialRoute(String currentRoute) => Navigator.of(Get.context!).popUntil((route) => route.settings.name == currentRoute);
      final currentRoute = Get.currentRoute;
      bool isPaymentAccepted = false;
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..enableZoom(false)
        ..setNavigationDelegate(
          NavigationDelegate(
            onHttpError: (HttpResponseError error) => backToInitialRoute(currentRoute),
            onWebResourceError: (WebResourceError error) => backToInitialRoute(currentRoute),
            onNavigationRequest: (NavigationRequest request) async {
              if (request.url.contains('payment/verify')) {
                isPaymentAccepted = (await PaymentRepository.find.verifyFlouciPayment(paymentId: paymentId)) ?? false;
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(paymentLink));
      await Get.to(
        () => HoldInSafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kNeutralColor100,
              leading: CustomButtons.icon(
                icon: const Icon(Icons.chevron_left, size: 28),
                onPressed: () => backToInitialRoute(currentRoute),
              ),
            ),
            body: WebViewWidget(controller: _webViewController!),
          ),
        ),
      );
      return isPaymentAccepted;
    } else {
      Helper.snackBar(message: 'error_occurred'.tr);
      return false;
    }
  }

  Future<bool> payWithBankCard(double totalPrice, {String? contractId, String? taskId, String? serviceId, int? coinPackId}) async {
    // TODO add bank card payment
    Helper.snackBar(message: 'bank_card_not_supported_yet'.tr);
    return false;
  }

  Future<bool> payWithBalance(double totalPrice, {String? contractId, String? taskId, String? serviceId, int? coinPackId}) async {
    if ((AuthenticationService.find.jwtUserData?.balance ?? 0) < totalPrice) {
      Helper.snackBar(message: 'not_enough_balance'.tr);
      return false;
    }
    final result = await PaymentRepository.find.payWithBalance(
      totalPrice: totalPrice,
      contractId: contractId,
      taskId: taskId,
      serviceId: serviceId,
      coinPackId: coinPackId,
    );
    return result;
  }
}
