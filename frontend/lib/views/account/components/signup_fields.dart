import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/form_validators.dart';
import '../../../helpers/helper.dart';
import '../../../models/governorate.dart';
import '../../../models/user.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../widgets/coordinates_picker.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class SignUpFields extends StatelessWidget {
  final double maxHeight;
  final User? user;

  const SignUpFields({super.key, required this.maxHeight, this.user});

  @override
  Widget build(BuildContext context) {
    final isEditProfile = user != null;
    final buildSignUpForm = GetBuilder<AuthenticationService>(
      builder: (controller) => Form(
        key: controller.formSignupKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
            if (isEditProfile) Center(child: Text('edit_profile'.tr, style: AppFonts.x24Bold)) else Text('welcome_side_hustle'.tr, style: AppFonts.x24Bold),
            const SizedBox(height: Paddings.exceptional),
            CustomTextField(
              hintText: 'full_name'.tr,
              fieldController: controller.nameController,
              validator: FormValidators.notEmptyOrNullValidator,
              isOptional: false,
            ),
            const SizedBox(height: Paddings.regular),
            CustomTextField(
              hintText: 'email'.tr,
              fieldController: controller.emailController,
              textCapitalization: TextCapitalization.none,
              validator: FormValidators.emailValidator,
              isOptional: false,
            ),
            const SizedBox(height: Paddings.regular),
            if (!isEditProfile) ...[
              CustomTextField(
                hintText: 'password'.tr,
                fieldController: controller.passwordController,
                textCapitalization: TextCapitalization.none,
                isPassword: true,
                validator: FormValidators.notEmptyOrNullValidator,
              ),
              const SizedBox(height: Paddings.regular),
              CustomTextField(
                hintText: 'confirm_password'.tr,
                fieldController: controller.confirmPasswordController,
                textCapitalization: TextCapitalization.none,
                isPassword: true,
                validator: (value) => FormValidators.confirmPasswordValidator(value, controller.passwordController.text),
              ),
              const SizedBox(height: Paddings.regular),
            ],
            Buildables.buildPhoneInput(
              initialNumber: controller.phoneNumber,
              onChanged: (number) => controller.phoneNumber = number?.international,
              isRequired: controller.phoneNumber?.isNotEmpty ?? false,
            ),
            const SizedBox(height: Paddings.small),
            if (!isEditProfile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                child: Text('verify_number_msg'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
              ),
            const SizedBox(height: Paddings.regular),
            CustomDropDownMenu<Governorate>(
              items: MainAppController.find.governorates,
              hint: 'Select a governorate',
              maxWidth: true,
              selectedItem: controller.governorate,
              buttonHeight: 45,
              valueFrom: (governorate) => governorate.name,
              onChanged: (value) => controller.governorate = value,
              validator: (_) => FormValidators.notEmptyOrNullValidator(controller.governorate?.name),
            ),
            const SizedBox(height: Paddings.regular),
            CustomTextField(
              hintText: 'birthdate'.tr,
              fieldController: controller.birthdateController,
              onTap: () => Helper.openDatePicker(currentTime: DateTime.now(), onConfirm: (p0) => controller.birthdateController.text = Helper.formatDate(p0)),
              readOnly: true,
            ),
            const SizedBox(height: Paddings.regular),
            CustomDropDownMenu(
              items: Gender.values.map((e) => e.value).toList(),
              hint: 'Select a gender',
              maxWidth: true,
              selectedItem: controller.gender?.value,
              buttonHeight: 45,
              onChanged: (value) => controller.gender = Gender.fromString(value!),
            ),
            const SizedBox(height: Paddings.regular),
            CoordinatesPicker(
              onSubmit: (coordinates) => controller.coordinates = coordinates,
              keepPrivacy: (privacy) => controller.keepPrivacy = privacy,
              withPicker: false,
              currentKeepPrivacy: user?.keepPrivacy,
              currentPosition: user?.coordinates,
            ),
            const SizedBox(height: Paddings.exceptional),
            CustomButtons.elevatePrimary(
              width: double.infinity,
              onPressed: isEditProfile ? controller.updateUserData : controller.signUpUser,
              loading: controller.isLoggingIn,
              title: isEditProfile ? 'edit_profile'.tr : 'create_account'.tr,
            ),
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
          ],
        ),
      ),
    );
    final buildOrDivider = Helper.isMobile
        ? Row(
            children: [
              Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralColor), child: const SizedBox(height: 1))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                child: Text('or'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
              ),
              Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralColor), child: const SizedBox(height: 1))),
            ],
          )
        : Column(
            children: [
              Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralLightColor), child: const SizedBox(width: 1))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text('or'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralLightColor)),
                ),
              ),
              Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralLightColor), child: const SizedBox(width: 1))),
            ],
          );
    final buildSignUpWithSocial = GetBuilder<AuthenticationService>(
      builder: (controller) => Column(
        children: [
          if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
          if (!Helper.isMobile) ...[
            const Text('Sign up with socials', style: AppFonts.x15Bold),
            const SizedBox(height: Paddings.exceptional),
          ],
          CustomButtons.elevateSecondary(
            onPressed: () => controller.facebookLogin(isSignUp: true),
            borderSide: BorderSide(color: kNeutralColor),
            icon: Icon(Icons.facebook_rounded, color: kBlackColor.withOpacity(.9)),
            title: 'continue_facebook'.tr,
          ),
          const SizedBox(height: Paddings.large),
          CustomButtons.elevateSecondary(
            onPressed: () => controller.signInWithGoogle(isSignUp: true),
            buttonColor: kNeutralColor100,
            borderSide: BorderSide(color: kNeutralColor),
            icon: Icon(Icons.g_mobiledata_outlined, color: kBlackColor.withOpacity(.9)),
            title: 'continue_google'.tr,
          ),
          if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
        ],
      ),
    );
    return Helper.isMobile
        ? SizedBox(
            height: maxHeight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
              child: Column(
                children: [
                  buildSignUpForm,
                  if (!isEditProfile) ...[
                    Padding(padding: const EdgeInsets.symmetric(vertical: Paddings.small), child: buildOrDivider),
                    buildSignUpWithSocial,
                  ],
                ],
              ),
            ),
          )
        : Row(
            children: [
              Expanded(flex: 5, child: buildSignUpForm),
              if (!isEditProfile) ...[
                Padding(padding: const EdgeInsets.symmetric(horizontal: Paddings.large), child: buildOrDivider),
                Expanded(flex: 3, child: buildSignUpWithSocial),
              ],
            ],
          );
  }
}
