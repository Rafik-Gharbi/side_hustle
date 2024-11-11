import 'package:get/get.dart';

class BalanceController extends GetxController {
  bool isLoading = true;
  List<dynamic> balanceHistory = [];

  BalanceController() {
    init();
  }

  Future<void> init() async {
    isLoading = false;
    update();
  }
}
