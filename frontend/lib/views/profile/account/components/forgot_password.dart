import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../helpers/form_validators.dart';
import '../../../../services/authentication_service.dart';
import '../../../../services/theme/theme.dart';
import '../../../../constants/assets.dart';
import '../../../../constants/sizes.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_text_field.dart';

class ForgotPassword extends StatelessWidget {
  static const routeName = 'forgot-password';

  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<AuthenticationService>(
        builder: (controller) => Form(
          key: controller.formSignupKey,
          child: Obx(
            () => controller.screenState.value == ForgotPasswordStep.sendEmail
                ? Column(
                    children: [
                      const SizedBox(height: Paddings.exceptional),
                      Center(child: Lottie.asset(Assets.forgotPasswordAnimation, height: 200)),
                      const SizedBox(height: Paddings.exceptional * 2),
                      Text('send_verification_msg'.tr, style: AppFonts.x14Regular),
                      const SizedBox(height: Paddings.large),
                      CustomTextField(
                        key: UniqueKey(),
                        fieldController: controller.emailController,
                        hintText: 'email'.tr,
                        isOptional: false,
                        textInputType: TextInputType.emailAddress,
                        validator: FormValidators.emailValidator,
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      CustomButtons.elevatePrimary(
                        loading: controller.sendingEmail,
                        title: !controller.firstMailSent ? 'send_verification'.tr : 'send_verification_again'.tr,
                        width: double.infinity,
                        onPressed: controller.sendVerificationKey,
                      ),
                      const SizedBox(height: Paddings.regular),
                      CustomButtons.elevateSecondary(
                        title: 'cancel'.tr,
                        width: double.infinity,
                        onPressed: () => controller.currentState = LoginWidgetState.login,
                      ),
                      const SizedBox(height: Paddings.exceptional),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                        child: Center(child: Lottie.asset(Assets.emailVerify, height: 200, fit: BoxFit.contain)),
                      ),
                      Center(child: Text('forgot_pass_msg'.tr, style: AppFonts.x14Regular)),
                      const SizedBox(height: Paddings.large),
                      CustomTextField(
                        fieldController: controller.validationKeyController,
                        hintText: 'verification_key'.tr,
                        isOptional: false,
                        validator: FormValidators.notEmptyOrNullValidator,
                        isPassword: true,
                      ),
                      CustomTextField(
                        fieldController: controller.passwordController,
                        hintText: 'new_password'.tr,
                        isOptional: false,
                        isPassword: true,
                        validator: FormValidators.passwordValidator,
                      ),
                      CustomTextField(
                        key: UniqueKey(),
                        fieldController: controller.confirmPasswordController,
                        hintText: 'confirm_password'.tr,
                        isOptional: false,
                        isPassword: true,
                        validator: (v) => FormValidators.confirmPasswordValidator(v, controller.passwordController.text),
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      CustomButtons.elevatePrimary(
                        title: 'change_password'.tr,
                        width: double.infinity,
                        loading: controller.isLoading,
                        onPressed: controller.forgotPassword,
                      ),
                      const SizedBox(height: Paddings.regular),
                      CustomButtons.elevateSecondary(
                        title: 'cancel'.tr,
                        width: double.infinity,
                        onPressed: () => controller.screenState.value = ForgotPasswordStep.sendEmail,
                      ),
                      const SizedBox(height: Paddings.exceptional),
                    ],
                  ),
          ),
        ),
      );
}
