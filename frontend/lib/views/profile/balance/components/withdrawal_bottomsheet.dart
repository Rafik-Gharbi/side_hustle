import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_text_field.dart';
import '../balance_controller.dart';

class WithdrawalBottomsheet extends StatelessWidget {
  const WithdrawalBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    bool isExpansionTileOpen = false;
    return GetBuilder<BalanceController>(
      builder: (controller) => StatefulBuilder(
        builder: (context, setState) => AnimatedContainer(
          duration: Durations.short4,
          height: (isExpansionTileOpen ? 550 : 445) + (controller.hasValidatorError ? 20 : 0),
          child: Material(
            color: kNeutralColor100,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('withdraw_earnings'.tr, style: AppFonts.x15Bold)),
                    const SizedBox(height: Paddings.exceptional),
                    Theme(
                      data: ThemeData(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text('how_it_work'.tr, style: AppFonts.x12Bold),
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                        initiallyExpanded: false,
                        onExpansionChanged: (value) => setState(() => isExpansionTileOpen = value),
                        children: [
                          Text('how_it_work_msg'.tr, style: AppFonts.x12Regular),
                          const SizedBox(height: Paddings.extraLarge),
                        ],
                      ),
                    ),
                    const SizedBox(height: Paddings.regular),
                    Text('${'requirements'.tr}:', style: AppFonts.x14Bold),
                    SizedBox(
                      height: 30,
                      child: ListTile(
                        title: Text('requirement_bank_number'.tr, style: AppFonts.x12Regular),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: controller.hasBankNumber ? const Icon(Icons.done, color: kConfirmedColor) : const Icon(Icons.close, color: kErrorColor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: ListTile(
                        title: Text('requirement_reach_100'.trParams({'currency': MainAppController.find.currency.value}), style: AppFonts.x12Regular),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: controller.loggedUser.balance >= 100 ? const Icon(Icons.done, color: kConfirmedColor) : const Icon(Icons.close, color: kErrorColor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: ListTile(
                        title: Text('requirement_withdraw_count'.trParams({'count': controller.withdrawalsCount.toString()}), style: AppFonts.x12Regular),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: controller.withdrawalsCount < 3 ? const Icon(Icons.done, color: kConfirmedColor) : const Icon(Icons.close, color: kErrorColor),
                      ),
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    CustomTextField(
                      hintText: 'amount_to_withdraw'.tr,
                      isOptional: false,
                      fieldController: controller.amountController,
                      textInputType: const TextInputType.numberWithOptions(decimal: true),
                      validator: FormValidators.notEmptyOrNullFloatValidator,
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    Center(
                      child: CustomButtons.elevatePrimary(
                        loading: controller.isLoading,
                        width: 200,
                        title: 'request_withdraw'.tr,
                        disabled: !controller.couldRequestWithdrawal,
                        onPressed: controller.requestWithdrawal,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
