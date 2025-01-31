import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/assets.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/buildables.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../helpers/helper.dart';
import '../../../../models/governorate.dart';
import '../../../../models/user.dart';
import '../../../../services/authentication_service.dart';
import '../../../../services/theme/theme.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_field.dart';
import 'privacy_terms_dialog.dart';

class SignUpFields extends StatelessWidget {
  final double maxHeight;
  final User? user;
  final bool isBottomSheet;

  const SignUpFields({super.key, required this.maxHeight, this.user, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    final isEditProfile = user != null;
    final buildSignUpForm = GetBuilder<AuthenticationService>(
      builder: (controller) {
        Widget getActionButton() => isEditProfile
            ? CustomButtons.elevatePrimary(
                width: double.infinity,
                disabled: isEditProfile ? false : !controller.acceptedTermsPrivacy.value,
                onPressed: isEditProfile ? controller.updateUserData : controller.signUpUser,
                loading: isEditProfile ? controller.isUpdatingProfile : controller.isLoggingIn,
                title: isEditProfile ? 'update'.tr : 'create_account'.tr,
              )
            : Obx(
                () => CustomButtons.elevatePrimary(
                  width: double.infinity,
                  disabled: isEditProfile ? false : !controller.acceptedTermsPrivacy.value,
                  onPressed: isEditProfile ? controller.updateUserData : controller.signUpUser,
                  loading: isEditProfile ? controller.isUpdatingProfile : controller.isLoggingIn,
                  title: isEditProfile ? 'update'.tr : 'create_account'.tr,
                ),
              );
        return Form(
          key: controller.formSignupKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isBottomSheet) ...[
                if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
                if (isEditProfile) Center(child: Text('edit_profile'.tr, style: AppFonts.x24Bold)) else Text('welcome_dootify'.tr, style: AppFonts.x24Bold),
                const SizedBox(height: Paddings.exceptional),
              ] else
                const SizedBox(height: Paddings.regular),
              CustomTextField(
                hintText: 'full_name'.tr,
                fieldController: controller.nameController,
                outlinedBorder: true,
                isOptional: false,
                validator: FormValidators.notEmptyOrNullValidator,
              ),
              const SizedBox(height: Paddings.regular),
              CustomTextField(
                hintText: 'email'.tr,
                textInputType: TextInputType.emailAddress,
                fieldController: controller.emailController,
                outlinedBorder: true,
                isOptional: false,
                textCapitalization: TextCapitalization.none,
                validator: FormValidators.emailValidator,
              ),
              const SizedBox(height: Paddings.regular),
              if (!isEditProfile) ...[
                CustomTextField(
                  hintText: 'password'.tr,
                  fieldController: controller.passwordController,
                  outlinedBorder: true,
                  isOptional: false,
                  textCapitalization: TextCapitalization.none,
                  isPassword: true,
                  validator: FormValidators.notEmptyOrNullValidator,
                ),
                const SizedBox(height: Paddings.regular),
                CustomTextField(
                  hintText: 'confirm_password'.tr,
                  fieldController: controller.confirmPasswordController,
                  outlinedBorder: true,
                  isOptional: false,
                  textCapitalization: TextCapitalization.none,
                  isPassword: true,
                  validator: (value) => FormValidators.confirmPasswordValidator(value, controller.passwordController.text),
                ),
                const SizedBox(height: Paddings.regular),
              ],
              Buildables.buildPhoneInput(
                initialNumber: controller.phoneNumber,
                onChanged: (number) => controller.phoneNumber = number?.international,
                outlinedBorder: true,
                isRequired: controller.phoneNumber?.isNotEmpty ?? false,
              ),
              const SizedBox(height: Paddings.regular),
              CustomDropDownMenu<Governorate>(
                items: MainAppController.find.governorates,
                hint: 'select_governorate'.tr,
                maxWidth: true,
                isRequired: true,
                selectedItem: controller.governorate,
                dropDownWithDecoration: true,
                buttonHeight: 45,
                valueFrom: (governorate) => governorate.name,
                onChanged: (value) => controller.governorate = value,
                validator: (_) => FormValidators.notEmptyOrNullValidator(controller.governorate?.name),
              ),
              const SizedBox(height: Paddings.regular),
              CustomTextField(
                hintText: 'birthdate'.tr,
                outlinedBorder: true,
                isOptional: false,
                fieldController: controller.birthdateController,
                onTap: () => Helper.openDatePicker(currentTime: DateTime.now(), onConfirm: (p0) => controller.birthdateController.text = Helper.formatDate(p0)),
                readOnly: true,
              ),
              const SizedBox(height: Paddings.regular),
              CustomDropDownMenu<Gender>(
                items: Gender.values,
                hint: 'select_gender'.tr,
                isRequired: true,
                dropDownWithDecoration: true,
                maxWidth: true,
                selectedItem: controller.gender,
                valueFrom: (gender) => gender.value.tr,
                buttonHeight: 45,
                onChanged: (selected) => controller.gender = selected!,
              ),
              const SizedBox(height: Paddings.regular),
              CustomButtons.elevateSecondary(
                title: 'share_my_position'.tr,
                titleStyle: AppFonts.x14Regular,
                icon: Icon(controller.coordinates != null ? Icons.my_location_outlined : Icons.location_searching_outlined),
                width: double.infinity,
                onPressed: controller.getUserCoordinates,
                loading: controller.isGettingCoordinates,
              ),
              const SizedBox(height: Paddings.small),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                child: Text('share_my_position_msg'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
              ),
              if (!isEditProfile) ...[
                const SizedBox(height: Paddings.regular),
                CustomTextField(
                  hintText: 'referral_code'.tr,
                  fieldController: controller.referralCodeController,
                  isOptional: true,
                  outlinedBorder: true,
                ),
                const SizedBox(height: Paddings.small),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                  child: Text('provide_referral_code_msg'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                ),
                const SizedBox(height: Paddings.regular),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  dense: true,
                  title: RichText(
                    text: TextSpan(
                      text: 'by_using_you_agree'.tr,
                      style: AppFonts.x14Regular,
                      children: [
                        TextSpan(
                          text: 'terms_condition'.tr,
                          style: AppFonts.x14Regular.copyWith(color: kPrimaryColor),
                          recognizer: TapGestureRecognizer()..onTap = () => controller.openTerms(),
                        ),
                        TextSpan(text: ' ${'and'.tr} ', style: AppFonts.x14Regular),
                        TextSpan(
                          text: 'privacy_policy'.tr,
                          style: AppFonts.x14Regular.copyWith(color: kPrimaryColor),
                          recognizer: TapGestureRecognizer()..onTap = () => controller.openPrivacy(),
                        ),
                        const TextSpan(text: '.', style: AppFonts.x14Regular),
                      ],
                    ),
                  ),
                  leading: Obx(
                    () => Checkbox(
                      checkColor: kNeutralColor100,
                      value: controller.acceptedTermsPrivacy.value,
                      onChanged: (value) => controller.acceptedTermsPrivacy.value = !controller.acceptedTermsPrivacy.value,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: Paddings.exceptional),
              getActionButton(),
              if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
            ],
          ),
        );
      },
    );
    final buildOrDivider = Helper.isMobile
        ? Row(
            children: [
              const Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralColor), child: SizedBox(height: 1))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                child: Text('or'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
              ),
              const Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralColor), child: SizedBox(height: 1))),
            ],
          )
        : Column(
            children: [
              const Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralLightColor), child: SizedBox(width: 1))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text('or'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralLightColor)),
                ),
              ),
              const Expanded(child: DecoratedBox(decoration: BoxDecoration(color: kNeutralLightColor), child: SizedBox(width: 1))),
            ],
          );
    final buildSignUpWithSocial = GetBuilder<AuthenticationService>(
      builder: (controller) {
        void signUpSocial(void Function() signup) => controller.acceptedTermsPrivacy.value
            ? signup()
            : Get.dialog(
                const PrivacyTermsDialog(),
                barrierDismissible: false,
              ).then((_) => signup());
        return Column(
          children: [
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
            if (!Helper.isMobile) ...[
              Text('sign_with_socials'.tr, style: AppFonts.x15Bold),
              const SizedBox(height: Paddings.exceptional),
            ],
            CustomButtons.elevateSecondary(
              onPressed: () => Helper.snackBar(message: 'feature_not_available_yet'.tr), // signUpSocial(() => controller.facebookLogin(isSignUp: true)),
              borderSide: const BorderSide(color: kNeutralColor),
              icon: Image.asset(Assets.facebookIcon, width: 25),
              title: 'continue_facebook'.tr,
              loading: controller.isLoggingIn,
            ),
            const SizedBox(height: Paddings.large),
            CustomButtons.elevateSecondary(
              onPressed: () => signUpSocial(() => controller.signInWithGoogle(isSignUp: true)),
              buttonColor: kNeutralColor100,
              borderSide: const BorderSide(color: kNeutralColor),
              icon: Image.asset(Assets.googleIcon, width: 25),
              title: 'continue_google'.tr,
              loading: controller.isLoggingIn,
            ),
            if (Helper.isMobile) const SizedBox(height: Paddings.exceptional) else const Spacer(),
          ],
        );
      },
    );
    return isBottomSheet
        ? buildSignUpForm
        : Helper.isMobile
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
