import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_text_field.dart';
import '../balance_controller.dart';

class DepositBottomsheet extends StatelessWidget {
  final DepositType type;
  const DepositBottomsheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isExpansionTileOpen = false;
    return GetBuilder<BalanceController>(
      builder: (controller) => StatefulBuilder(
        builder: (context, setState) {
          double bottomsheetHeight(RxBool error) => resolveDepositTypeHeight(isExpansionTileOpen, error.value, controller.hasValidatorErrorSlipDeposit.value);
          return Obx(
            () => AnimatedContainer(
              duration: Durations.short4,
              height: bottomsheetHeight(controller.hasValidatorError) > (Get.height - 100) ? Get.height - 100 : bottomsheetHeight(controller.hasValidatorError),
              child: Material(
                color: kNeutralColor100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: bottomsheetHeight(controller.hasValidatorError) > (Get.height - 100)
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: Paddings.extraLarge),
                          child: buildContent(controller, (value) => setState(() => isExpansionTileOpen = value), isExpansionTileOpen),
                        ),
                      )
                    : buildContent(controller, (value) => setState(() => isExpansionTileOpen = value), isExpansionTileOpen),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding buildContent(BalanceController controller, void Function(bool) toggleExpansionTile, bool isExpansionTileOpen) {
    return Padding(
      padding: const EdgeInsets.all(Paddings.large),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('deposit_money'.tr, style: AppFonts.x15Bold)),
            const SizedBox(height: Paddings.exceptional),
            Text('deposit_money_msg'.tr, style: AppFonts.x14Regular),
            const SizedBox(height: Paddings.regular),
            Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(resolveDepositTypeHowItWork(), style: AppFonts.x12Bold),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                initiallyExpanded: false,
                onExpansionChanged: (value) => toggleExpansionTile.call(value),
                children: [
                  Text(resolveDepositTypeMsg(), style: AppFonts.x12Regular),
                ],
              ),
            ),
            const SizedBox(height: Paddings.large),
            if (type == DepositType.installment) ...[
              Text('company_rib_msg'.tr, style: AppFonts.x14Bold),
              const SizedBox(height: Paddings.large),
            ],
            CustomTextField(
              hintText: 'amount_to_deposit'.tr,
              isOptional: false,
              fieldController: controller.amountController,
              textInputType: const TextInputType.numberWithOptions(decimal: true),
              validator: FormValidators.notEmptyOrNullFloatValidator,
            ),
            if (type == DepositType.installment)
              Obx(
                () => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: Paddings.large),
                        child: InkWell(
                          onTap: controller.addDepositSlipPicture,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: kNeutralLightColor,
                              borderRadius: smallRadius,
                              border: controller.hasValidatorErrorSlipDeposit.value ? regularErrorBorder : regularBorder,
                            ),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: smallRadius,
                                child: controller.depositSlip != null
                                    ? Image.file(File(controller.depositSlip!.path), height: 150, width: 150, fit: BoxFit.cover)
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.add_a_photo_outlined),
                                          const SizedBox(height: Paddings.regular),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                            child: Text('deposit_slip_picture'.tr, style: AppFonts.x12Regular, softWrap: true),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.hasValidatorErrorSlipDeposit.value)
                        Padding(
                          padding: const EdgeInsets.only(top: Paddings.small),
                          child: Text('deposit_slip_picture_required'.tr, style: AppFonts.x12Regular.copyWith(color: kErrorColor)),
                        )
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Paddings.exceptional),
            Center(
              child: CustomButtons.elevatePrimary(
                loading: controller.isLoading,
                width: 200,
                title: resolveDepositTypeBtnTitle(),
                onPressed: () => controller.requestDeposit(type),
              ),
            )
          ],
        ),
      ),
    );
  }

  String resolveDepositTypeHowItWork() {
    switch (type) {
      case DepositType.bankCard:
        return 'how_deposit_work_bank_card'.tr;
      case DepositType.installment:
        return 'how_deposit_work_bank_installment'.tr;
      default:
        return 'error_occurred'.tr;
    }
  }

  String resolveDepositTypeMsg() {
    switch (type) {
      case DepositType.bankCard:
        return 'how_deposit_work_bank_card_msg'.tr;
      case DepositType.installment:
        return 'how_deposit_work_bank_installment_msg'.tr;
      default:
        return 'error_occurred'.tr;
    }
  }

  String resolveDepositTypeBtnTitle() {
    switch (type) {
      case DepositType.bankCard:
        return 'deposit_money_upper'.tr;
      case DepositType.installment:
        return 'request_deposit'.tr;
      default:
        return 'error_occurred'.tr;
    }
  }

  double resolveDepositTypeHeight(bool isExpansionTileOpen, bool hasValidatorError, bool hasValidatorErrorSlipDeposit) {
    switch (type) {
      case DepositType.bankCard:
        return (isExpansionTileOpen ? 560 : 390) + (hasValidatorError ? 20 : 0);
      case DepositType.installment:
        return (isExpansionTileOpen ? 790 : 600) + (hasValidatorError ? 20 : 0) + (hasValidatorErrorSlipDeposit ? 20 : 0);
      default:
        return Get.height - 100;
    }
  }
}
