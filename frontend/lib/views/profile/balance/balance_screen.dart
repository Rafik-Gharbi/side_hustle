import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/balance_transaction_card.dart';
import '../../../widgets/custom_button_with_overlay.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import 'balance_controller.dart';
import 'components/add_bank_number_bottomsheet.dart';
import 'components/deposit_bottomsheet.dart';
import 'components/withdrawal_bottomsheet.dart';

class BalanceScreen extends StatelessWidget {
  static const String routeName = '/my-balance';
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasFinishedBalanceTutorial = SharedPreferencesService.find.get(hasFinishedBalanceTutorialKey) == 'true';
    bool hasOpenedTutorial = false;
    return HoldInSafeArea(
      child: GetBuilder<BalanceController>(
        initState: (state) {
          FirebaseAnalytics.instance.logScreenView(screenName: 'BalanceScreen');
          Helper.waitAndExecute(() => state.controller != null && !(state.controller?.isLoading.value ?? true), () {
            if (!hasFinishedBalanceTutorial && Get.currentRoute == routeName && !hasOpenedTutorial && state.controller!.targets.isNotEmpty) {
              hasOpenedTutorial = true;
              TutorialCoachMark(
                targets: state.controller!.targets,
                colorShadow: kNeutralOpacityColor,
                hideSkip: true,
                onFinish: () => SharedPreferencesService.find.add(hasFinishedBalanceTutorialKey, 'true'),
              ).show(context: context);
            }
          });
        },
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'my_balance'.tr,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [kNeutralColor, kNeutralColor100], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.only(top: Paddings.extraLarge),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.extraLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                key: controller.balanceOverview,
                                padding: const EdgeInsets.all(Paddings.regular),
                                child: Column(
                                  children: [
                                    Text('account_balance'.tr, style: AppFonts.x16Regular.copyWith(color: kNeutralColor100)),
                                    Text(
                                      '${Helper.formatAmount(controller.loggedUser.balance)} ${MainAppController.find.currency.value}',
                                      style: AppFonts.x24Bold.copyWith(color: kNeutralColor100),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Paddings.regular),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButtons.icon(
                                    disabled: !MainAppController.find.isConnected,
                                    key: controller.withdrawBtnKey,
                                    onPressed: () => Get.bottomSheet(const WithdrawalBottomsheet(), isScrollControlled: true),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: kAccentColor.withOpacity(0.9), borderRadius: circularRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Paddings.regular),
                                        child: SizedBox(
                                          width: 120,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(Assets.withdrawMoneyIcon, width: 20, color: kNeutralColor100),
                                              const SizedBox(width: Paddings.regular),
                                              Text('withdraw'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor100)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomButtonWithOverlay(
                                    disabled: !MainAppController.find.isConnected,
                                    buttonWidth: 140,
                                    button: DecoratedBox(
                                      key: controller.depositBtnKey,
                                      decoration: BoxDecoration(color: kAccentColor.withOpacity(0.9), borderRadius: circularRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Paddings.regular),
                                        child: SizedBox(
                                          width: 120,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                Assets.depositMoneyIcon,
                                                width: 20,
                                                color: kNeutralColor100,
                                              ),
                                              const SizedBox(width: Paddings.regular),
                                              Text('deposit'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor100)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    menu: DecoratedBox(
                                      decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralColor100),
                                      child: SizedBox(
                                        width: 180,
                                        height: 120,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                              title: Text('bank_card'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                              leading: const Icon(Icons.payment_outlined),
                                              onTap: () {
                                                Helper.goBack();
                                                Get.bottomSheet(const DepositBottomsheet(type: DepositType.bankCard), isScrollControlled: true)
                                                    .then((value) => controller.clearDepositFields());
                                              },
                                            ),
                                            ListTile(
                                              shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                              title: Text('installment'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                              leading: const Icon(Icons.attach_money_outlined),
                                              onTap: () async {
                                                Helper.goBack();
                                                Get.bottomSheet(const DepositBottomsheet(type: DepositType.installment), isScrollControlled: true)
                                                    .then((value) => controller.clearDepositFields());
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    offset: const Offset(-20, 50),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Paddings.regular),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => Text(
                                      '${'bank_number'.tr}: ${controller.isBankNumberConfiscated.value ? '**** **** **** ${controller.loggedUser.bankNumber!.substring(16)}' : controller.loggedUser.bankNumber ?? 'not_provided'.tr}',
                                      style: AppFonts.x14Regular.copyWith(color: kNeutralColor100),
                                    ),
                                  ),
                                  const SizedBox(width: Paddings.small),
                                  if (controller.loggedUser.bankNumber != null)
                                    InkWell(
                                      onTap: () => controller.isBankNumberConfiscated.value = !controller.isBankNumberConfiscated.value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                                        child: Icon(
                                          controller.isBankNumberConfiscated.value ? Icons.visibility : Icons.visibility_off,
                                          color: kAccentColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  InkWell(
                                    onTap: MainAppController.find.isConnected
                                        ? () => Get.bottomSheet(AddBankNumberBottomsheet(bankNumber: controller.loggedUser.bankNumber), isScrollControlled: true)
                                            .then((value) => controller.bankNumberController.text = '')
                                        : null,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                                      child: Text(
                                        controller.loggedUser.bankNumber == null ? '(${'add'.tr})' : '(${'edit'.tr})',
                                        style: AppFonts.x11Bold.copyWith(
                                          color: controller.loggedUser.bankNumber == null ? kErrorLightColor : kSelectedDarkColor,
                                          decoration: TextDecoration.underline,
                                          decorationColor: controller.loggedUser.bankNumber == null ? kErrorLightColor : kSelectedDarkColor,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Paddings.regular),
                      LoadingRequest(
                        isLoading: controller.isLoading,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                          child: SizedBox(
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.all(Paddings.extraLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('balance_history'.tr, style: AppFonts.x15Bold),
                                  if (controller.balanceTransactions.isEmpty)
                                    SizedBox(height: Get.height - 495, child: Center(child: Text('no_history_yet'.tr, style: AppFonts.x14Regular)))
                                  else
                                    ...List.generate(
                                      controller.balanceTransactions.length,
                                      (index) => BalanceTransactionCard(transaction: controller.balanceTransactions[index]),
                                    ),
                                  if (controller.balanceTransactions.length < 5) SizedBox(height: Get.height - 495 - controller.balanceTransactions.length * 70)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.balanceTransactions.isNotEmpty && controller.balanceTransactions.length >= 5) const SizedBox(height: Paddings.large),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
