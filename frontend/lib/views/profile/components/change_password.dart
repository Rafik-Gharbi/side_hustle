import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/form_validators.dart';
import '../../../models/user.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_text_field.dart';

class ChangePasswordBottomsheet extends StatelessWidget {
  final User user;
  const ChangePasswordBottomsheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final confirmPasswordController = TextEditingController();
    return DecoratedBox(
      decoration: BoxDecoration(color: kNeutralColor100, borderRadius: regularRadius),
      child: SizedBox(
        width: 450,
        height: 470,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Paddings.exceptional),
                  child: Center(child: Text('change_password'.tr, style: AppFonts.x18Bold)),
                ),
                const Spacer(),
                if (user.password != null)
                  CustomTextField(
                    hintText: 'current_password'.tr,
                    fieldController: AuthenticationService.find.currentPasswordController,
                    validator: FormValidators.notEmptyOrNullValidator,
                    enableFloatingLabel: true,
                    isPassword: true,
                    textAlign: TextAlign.start,
                  ),
                const SizedBox(height: Paddings.large),
                CustomTextField(
                  hintText: 'new_password'.tr,
                  fieldController: AuthenticationService.find.newPasswordController,
                  validator: (value) => FormValidators.passwordValidator(value, currentPassword: AuthenticationService.find.currentPasswordController.text),
                  enableFloatingLabel: true,
                  isPassword: true,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: Paddings.large),
                CustomTextField(
                  hintText: 'confirm_password'.tr,
                  fieldController: confirmPasswordController,
                  validator: (value) => FormValidators.confirmPasswordValidator(value, AuthenticationService.find.newPasswordController.text),
                  enableFloatingLabel: true,
                  isPassword: true,
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
                Center(
                  child: CustomButtons.elevatePrimary(
                    title: 'save'.tr,
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
                    onPressed: () => AuthenticationService.find.changePassword(formKey),
                  ),
                ),
                const SizedBox(height: Paddings.exceptional),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
