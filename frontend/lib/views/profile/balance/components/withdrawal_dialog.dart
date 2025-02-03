import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/helper.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_buttons.dart';

class WithdrawalDialog extends StatelessWidget {
  final double amount;
  final RxBool isLoading;
  final void Function() onWithdraw;

  const WithdrawalDialog({super.key, required this.amount, required this.onWithdraw, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(RadiusSize.regular))),
      backgroundColor: kNeutralColor100,
      insetPadding: const EdgeInsets.all(Paddings.exceptional),
      elevation: 0,
      titlePadding: const EdgeInsets.all(Paddings.large),
      contentPadding: const EdgeInsets.all(Paddings.large),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Paddings.regular),
          Text('proceed_with_withdrawal'.tr, style: AppFonts.x16Bold),
          const SizedBox(height: Paddings.regular),
          Divider(color: kNeutralLightColor),
          const SizedBox(height: Paddings.regular),
          Text('withdrawal_msg'.tr, style: AppFonts.x14Regular, textAlign: TextAlign.justify),
          const SizedBox(height: Paddings.large),
          Text('${'amount_to_withdraw'.tr}:', style: AppFonts.x14Bold),
          const SizedBox(height: Paddings.small),
          Table(
            children: [
              TableRow(
                children: [
                  Text('${'requested_amount'.tr}:', style: AppFonts.x14Regular),
                  Text('${Helper.formatAmount(amount)} ${MainAppController.find.currency.value}', style: AppFonts.x14Regular),
                ],
              ),
              TableRow(
                children: [
                  Text('${'service_fees'.tr} (${Helper.formatAmount(serviceFees * 100)}%):', style: AppFonts.x14Regular),
                  Text('${Helper.formatAmount(amount * serviceFees)} ${MainAppController.find.currency.value}', style: AppFonts.x14Regular),
                ],
              ),
              TableRow(
                children: [
                  Text('${'total_amount'.tr}:', style: AppFonts.x14Bold),
                  Text('${Helper.formatAmount(amount - amount * serviceFees)} ${MainAppController.find.currency.value}', style: AppFonts.x14Bold),
                ],
              ),
            ],
          ),
          const SizedBox(height: Paddings.large),
          Divider(color: kNeutralLightColor),
          const SizedBox(height: Paddings.regular),
          Center(
            child: CustomButtons.elevatePrimary(
              title: 'withdraw'.tr,
              loading: isLoading,
              width: 150,
              onPressed: () {
                Helper.goBack();
                onWithdraw.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}
