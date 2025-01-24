import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/sizes.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../models/user.dart';
import '../../../../services/authentication_service.dart';
import '../../../../widgets/custom_bottomsheet.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_text_field.dart';

class ChangePasswordBottomsheet extends StatelessWidget {
  final User user;
  const ChangePasswordBottomsheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final confirmPasswordController = TextEditingController();
    return CustomBottomsheet(
      title: 'change_password'.tr,
      height: 530,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Paddings.regular),
            if (user.password != null)
              CustomTextField(
                hintText: 'current_password'.tr,
                fieldController: AuthenticationService.find.currentPasswordController,
                validator: FormValidators.notEmptyOrNullValidator,
                enableFloatingLabel: true,
                isPassword: true,
                isOptional: false,
                outlinedBorder: true,
                textAlign: TextAlign.start,
              ),
            const SizedBox(height: Paddings.large),
            CustomTextField(
              hintText: 'new_password'.tr,
              fieldController: AuthenticationService.find.newPasswordController,
              validator: (value) => FormValidators.passwordValidator(value, currentPassword: AuthenticationService.find.currentPasswordController.text),
              enableFloatingLabel: true,
              isPassword: true,
              isOptional: false,
              outlinedBorder: true,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: Paddings.large),
            CustomTextField(
              hintText: 'confirm_password'.tr,
              fieldController: confirmPasswordController,
              validator: (value) => FormValidators.confirmPasswordValidator(value, AuthenticationService.find.newPasswordController.text),
              enableFloatingLabel: true,
              isPassword: true,
              isOptional: false,
              outlinedBorder: true,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: Paddings.exceptional),
            Center(
              child: CustomButtons.elevatePrimary(
                title: 'save'.tr,
                loading: AuthenticationService.find.isLoading,
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
                onPressed: () => AuthenticationService.find.changePassword(formKey),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
          ],
        ),
      ),
    );
  }
}
