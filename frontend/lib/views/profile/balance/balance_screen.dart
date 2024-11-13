import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/balance_transaction.dart';
import '../../../models/user.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_button_with_overlay.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import 'balance_controller.dart';
import 'components/add_bank_number_bottomsheet.dart';
import 'components/deposit_bottomsheet.dart';
import 'components/withdrawal_bottomsheet.dart';

class BalanceScreen extends StatelessWidget {
  static const String routeName = '/my-balance';
  final User loggedUser;
  const BalanceScreen({super.key, required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<BalanceController>(
        init: BalanceController(loggedUser),
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'my_balance'.tr,
          body: DecoratedBox(
            decoration: BoxDecoration(
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
                              Text('account_balance'.tr, style: AppFonts.x16Regular.copyWith(color: kNeutralColor100)),
                              Text(
                                '${Helper.formatAmount(controller.loggedUser.balance)} ${MainAppController.find.currency.value}',
                                style: AppFonts.x24Bold.copyWith(color: kNeutralColor100),
                              ),
                              const SizedBox(height: Paddings.extraLarge),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButtons.icon(
                                    onPressed: () => Get.bottomSheet(const WithdrawalBottomsheet(), isScrollControlled: true).then((value) => controller.clearWithdrawalFields()),
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
                                              Text('widhdraw'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor100)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomButtonWithOverlay(
                                    buttonWidth: 140,
                                    button: DecoratedBox(
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
                                  // TODO confiscate the bank number and add see option
                                  Text(
                                    '${'bank_number'.tr}: ${controller.loggedUser.bankNumber ?? 'not_provided'.tr}',
                                    style: AppFonts.x14Regular.copyWith(color: kNeutralColor100),
                                  ),
                                  InkWell(
                                    onTap: () => Get.bottomSheet(AddBankNumberBottomsheet(bankNumber: controller.loggedUser.bankNumber), isScrollControlled: true)
                                        .then((value) => controller.bankNumberController.text = ''),
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
                                      (index) {
                                        final transaction = controller.balanceTransactions[index];
                                        final isDeposit = transaction.type == BalanceTransactionType.deposit; // TODO does system type is income?
                                        return ListTile(
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(transaction.type?.name.tr ?? 'NA', style: AppFonts.x14Regular),
                                                  if (transaction.type == BalanceTransactionType.deposit)
                                                    Text(' (${transaction.depositType?.name.tr ?? 'NA'})', style: AppFonts.x14Regular),
                                                ],
                                              ),
                                              Text(
                                                '${isDeposit ? '+' : '-'} ${Helper.formatAmount(transaction.amount ?? 0)} ${MainAppController.find.currency.value}',
                                                style: AppFonts.x16Bold.copyWith(color: isDeposit ? kConfirmedColor : kErrorColor),
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(transaction.status?.name.tr ?? 'NA', style: AppFonts.x12Regular),
                                              Text(transaction.createdAt != null ? Helper.formatDateWithTime(transaction.createdAt!) : 'NA', style: AppFonts.x12Regular),
                                            ],
                                          ),
                                        );
                                      },
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
