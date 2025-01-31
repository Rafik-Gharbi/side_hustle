import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/profile/balance/balance_controller.dart';
import '../theme/theme.dart';

class BalanceTutorial {
  static RxBool notShowAgain = false.obs;

  static void showTutorial() {
    BalanceController.find.targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: BalanceController.find.balanceOverview,
          bottomContent: [
            const SizedBox(height: Paddings.exceptional),
            Text(
              'manage_wallet'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'manage_wallet_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'delegate_task'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'delegate_task_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: BalanceController.find.withdrawBtnKey,
          bottomContent: [
            Text(
              'withdraw_your_money'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'withdraw_your_money_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: BalanceController.find.depositBtnKey,
          bottomContent: [
            Text(
              'deposit_some_money'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'deposit_some_money_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
