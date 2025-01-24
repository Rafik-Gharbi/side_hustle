import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/assets.dart';
import '../../../../helpers/buildables.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../helpers/helper.dart';
import '../../../../services/authentication_service.dart';
import '../../../../services/theme/theme.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_text_field.dart';

class SignInFields extends StatelessWidget {
  const SignInFields({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<AuthenticationService>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
            Text('welcome_dootify'.tr, style: AppFonts.x24Bold),
            const SizedBox(height: Paddings.large),
            if (controller.isPhoneInput)
              Buildables.buildPhoneInput(
                initialNumber: controller.phoneNumber,
                outlinedBorder: true,
                onChanged: (number) => controller.phoneNumber = number?.international,
              )
            else
              CustomTextField(
                hintText: 'email'.tr,
                outlinedBorder: true,
                isOptional: false,
                textInputType: TextInputType.emailAddress,
                fieldController: controller.emailController,
                validator: FormValidators.emailValidator,
                textCapitalization: TextCapitalization.none,
              ),
            const SizedBox(height: Paddings.regular),
            CustomTextField(
              hintText: 'password'.tr,
              isOptional: false,
              fieldController: controller.passwordController,
              textCapitalization: TextCapitalization.none,
              isPassword: true,
              outlinedBorder: true,
              validator: FormValidators.notEmptyOrNullValidator,
            ),
            const SizedBox(height: Paddings.small),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtons.text(
                  onPressed: () => controller.currentState = LoginWidgetState.forgotPassword,
                  title: 'forgot_password'.tr,
                  titleStyle: AppFonts.x12Regular,
                ),
              ],
            ),
            const SizedBox(height: Paddings.exceptional),
            CustomButtons.elevatePrimary(
              width: double.infinity,
              onPressed: controller.classicLogin,
              loading: controller.isLoggingIn,
              title: 'continue'.tr,
            ),
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Expanded(child: Container(height: 1, color: kNeutralLightOpacityColor)),
                  Text('  ${'or'.tr}  ', style: AppFonts.x12Regular),
                  Expanded(child: Container(height: 1, color: kNeutralLightOpacityColor)),
                ],
              ),
            ),
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
            CustomButtons.elevateSecondary(
              onPressed: () => Helper.snackBar(message: 'feature_not_available_yet'.tr), // controller.facebookLogin,
              borderSide: const BorderSide(color: kNeutralColor),
              icon: Image.asset(Assets.facebookIcon, width: 25),
              title: 'continue_facebook'.tr,
              loading: controller.isLoggingIn,
            ),
            const SizedBox(height: Paddings.large),
            CustomButtons.elevateSecondary(
              onPressed: controller.signInWithGoogle,
              buttonColor: kNeutralColor100,
              borderSide: const BorderSide(color: kNeutralColor),
              icon: Image.asset(Assets.googleIcon, width: 25),
              title: 'continue_google'.tr,
              loading: controller.isLoggingIn,
            ),
            const SizedBox(height: Paddings.large),
            CustomButtons.elevateSecondary(
              onPressed: () => controller.isPhoneInput = !controller.isPhoneInput,
              buttonColor: kNeutralColor100,
              borderSide: const BorderSide(color: kNeutralColor, width: 0.7),
              icon: Icon(controller.isPhoneInput ? Icons.email_outlined : Icons.phone_outlined, color: kBlackColor.withOpacity(.9)),
              title: '${'continue_with'.tr} ${controller.isPhoneInput ? 'email'.tr : 'phone'.tr}',
            ),
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
          ],
        ),
      );
}
