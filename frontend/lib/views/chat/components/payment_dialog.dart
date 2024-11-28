import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/contract.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';

class PaymentDialog extends StatelessWidget {
  final Contract contract;
  final int? discussionId;

  const PaymentDialog({super.key, required this.contract, this.discussionId});

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
          Text('proceed_with_payment'.tr, style: AppFonts.x16Bold),
          const SizedBox(height: Paddings.regular),
          Divider(color: kNeutralLightColor),
          const SizedBox(height: Paddings.regular),
          Text('payment_msg'.tr, style: AppFonts.x14Regular, textAlign: TextAlign.justify),
          const SizedBox(height: Paddings.large),
          Text('${'amount_to_pay'.tr}:', style: AppFonts.x14Bold),
          const SizedBox(height: Paddings.small),
          Table(
            children: [
              TableRow(
                children: [
                  Text('${'task_price'.tr}:', style: AppFonts.x14Regular),
                  Text('${Helper.formatAmount(contract.finalPrice)} ${MainAppController.find.currency.value}', style: AppFonts.x14Regular),
                ],
              ),
              TableRow(
                children: [
                  Text('${'service_fees'.tr} (10%):', style: AppFonts.x14Regular),
                  Text('${Helper.formatAmount(contract.finalPrice * 0.1)} ${MainAppController.find.currency.value}', style: AppFonts.x14Regular),
                ],
              ),
              TableRow(
                children: [
                  Text('${'total_amount'.tr}:', style: AppFonts.x14Bold),
                  Text('${Helper.formatAmount(contract.finalPrice + contract.finalPrice * 0.1)} ${MainAppController.find.currency.value}', style: AppFonts.x14Bold),
                ],
              ),
            ],
          ),
          const SizedBox(height: Paddings.large),
          Divider(color: kNeutralLightColor),
          const SizedBox(height: Paddings.regular),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButtons.elevateSecondary(
                onPressed: () => Helper.snackBar(message: 'bank_card_not_supported_yet'.tr), // TODO add bank card payment
                title: 'bank_card'.tr,
                titleStyle: AppFonts.x14Bold,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
              ),
              CustomButtons.elevatePrimary(
                onPressed: () async {
                  if ((AuthenticationService.find.jwtUserData?.balance ?? 0) < contract.finalPrice) {
                    Helper.snackBar(message: 'not_enough_balance'.tr);
                    return;
                  }
                  MainAppController.find.socket!.emit('payContract', {'contractId': contract.id, 'discussionId': discussionId});
                  Helper.goBack();
                },
                title: 'pay_with_balance'.tr,
                titleStyle: AppFonts.x14Bold.copyWith(color: kPrimaryColor),
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
              ),
            ],
          ),
          const SizedBox(height: Paddings.small),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Available balance: ${Helper.formatAmount(AuthenticationService.find.jwtUserData?.balance ?? 0)} ${MainAppController.find.currency.value}',
              style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
            ),
          ),
        ],
      ),
    );
  }
}
