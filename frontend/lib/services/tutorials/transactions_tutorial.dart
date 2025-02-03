import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/profile/transactions/transactions_controller.dart';
import '../theme/theme.dart';

class TransactionsTutorial {
  static RxBool notShowAgain = false.obs;

  static void showTutorial() {
    if (TransactionsController.find.targets.isNotEmpty) TransactionsController.find.targets.clear();
    TransactionsController.find.targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: TransactionsController.find.coinsOverview,
          bottomContent: [
            Text(
              'track_coins'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'track_coins_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'low_coins'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'low_coins_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'purchase_coins'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'purchase_coins_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: TransactionsController.find.firstTransactionsKey,
          bottomContent: [
            Text(
              'first_coin_transaction'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'first_coin_transaction_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
