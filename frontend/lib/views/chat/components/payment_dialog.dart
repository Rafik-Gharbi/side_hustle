import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/contract.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';

class ContractPaymentDialog extends StatelessWidget {
  final Contract contract;
  final int? discussionId;

  const ContractPaymentDialog({super.key, required this.contract, this.discussionId});

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
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
                  Text('${'service_fees'.tr} (${Helper.formatAmount(serviceFees * 100)}%):', style: AppFonts.x14Regular),
                  Text('${Helper.formatAmount(contract.finalPrice * serviceFees)} ${MainAppController.find.currency.value}', style: AppFonts.x14Regular),
                ],
              ),
              TableRow(
                children: [
                  Text('${'total_amount'.tr}:', style: AppFonts.x14Bold),
                  Text('${Helper.formatAmount(contract.finalPrice + contract.finalPrice * serviceFees)} ${MainAppController.find.currency.value}', style: AppFonts.x14Bold),
                ],
              ),
            ],
          ),
          const SizedBox(height: Paddings.large),
          Divider(color: kNeutralLightColor),
          const SizedBox(height: Paddings.regular),
          Center(
            child: CustomButtons.elevatePrimary(
              title: 'pay_contract'.tr,
              loading: isLoading,
              width: 150,
              disabled: !contract.isSigned,
              onPressed: () {
                Helper.goBack();
                Get.bottomSheet(
                  isScrollControlled: true,
                  Buildables.buildPaymentOptionsBottomsheet(
                    totalPrice: contract.finalPrice,
                    contractId: contract.id,
                    onSuccessPayment: () {
                      MainAppController.find.socket!.emit('payContract', {'contractId': contract.id, 'discussionId': discussionId});
                    },
                  ),
                ).then((_) => isLoading.value = false);
              },
            ),
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
