import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_text_field.dart';
import '../balance_controller.dart';

class AddBankNumberBottomsheet extends StatelessWidget {
  final String? bankNumber;
  const AddBankNumberBottomsheet({super.key, this.bankNumber});

  @override
  Widget build(BuildContext context) {
    final isEdit = bankNumber != null;
    return GetBuilder<BalanceController>(
      builder: (controller) {
        if (isEdit) controller.bankNumberController.text = bankNumber!;
        return Obx(
          () => AnimatedContainer(
            duration: Durations.short4,
            height: 350 + (controller.hasValidatorError.value ? 20 : 0),
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
                      Center(child: Text(isEdit ? 'edit_bank_card'.tr : 'add_bank_card'.tr, style: AppFonts.x15Bold)),
                      const SizedBox(height: Paddings.exceptional),
                      Text('${'bank_number_validation'.tr}:', style: AppFonts.x14Regular),
                      const SizedBox(height: Paddings.exceptional),
                      CustomTextField(
                        hintText: 'bank_number_lower'.tr,
                        isOptional: false,
                        fieldController: controller.bankNumberController,
                        textInputType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => FormValidators.exactNumberOfIntValidator(value, 20, isNumber: true),
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Center(
                        child: CustomButtons.elevatePrimary(
                          loading: controller.isLoading,
                          width: 200,
                          title: isEdit ? 'edit_bank_card'.tr : 'add_bank_card'.tr,
                          onPressed: controller.upsertBankNumber,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
