import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../models/contract.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';
import '../services/theme/theme.dart';
import '../views/profile/account/login_dialog.dart';
import '../views/home/home_controller.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_text_field.dart';
import 'form_validators.dart';
import 'helper.dart';

class Buildables {
  static Widget buildPhoneInput({
    String? initialNumber,
    required void Function(PhoneNumber?) onChanged,
    bool isRequired = true,
    PhoneController? controller,
  }) =>
      Theme(
        data: ThemeData(bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kNeutralColor100)),
        child: Container(
          margin: const EdgeInsets.only(top: Paddings.small),
          child: PhoneFormField(
            controller: controller ?? PhoneController(initialValue: PhoneNumber.parse(initialNumber ?? defaultPrefix)),
            validator: PhoneValidator.compose([PhoneValidator.required(Get.context!), PhoneValidator.validMobile(Get.context!)]),
            countrySelectorNavigator: const CountrySelectorNavigator.modalBottomSheet(),
            enabled: true,
            isCountrySelectionEnabled: true,
            isCountryButtonPersistent: true,
            style: AppFonts.x14Regular,
            countryButtonStyle: const CountryButtonStyle(
              showDialCode: true,
              showIsoCode: true,
              showFlag: true,
              flagSize: 16,
              textStyle: AppFonts.x14Regular,
              padding: EdgeInsets.only(bottom: 8, right: 10, left: 15),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
              alignLabelWithHint: true,
              errorStyle: AppFonts.x12Regular.copyWith(color: kErrorColor),
              border: UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
              floatingLabelStyle: AppFonts.x14Regular.copyWith(height: 0.2),
              hintStyle: AppFonts.x14Regular.copyWith(color: kNeutralColor.withAlpha(150)),
            ),
            onChanged: (phoneNumber) {
              if (phoneNumber.international.isNotEmpty) {
                onChanged.call(phoneNumber);
                Helper.selectedIsoCode = phoneNumber.isoCode.toString();
                Helper.phonePrefix = phoneNumber.countryCode;
              }
            },
          ),
        ),
      );

  static Widget buildLoadingWidget({double? height}) =>
      SizedBox(height: height ?? Get.height * 0.9, child: Center(child: Lottie.asset(Assets.fetchingData, height: height != null ? height - 20 : 100)));

  static Widget buildLoginRequest({String? message, void Function()? onLogin}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text(message ?? 'login_profile_msg'.tr)),
          CustomButtons.text(
            title: 'login'.tr,
            titleStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor),
            onPressed: () => Get.bottomSheet(const LoginDialog(), isScrollControlled: true).then((value) {
              AuthenticationService.find.currentState = LoginWidgetState.login;
              AuthenticationService.find.clearFormFields();
              HomeController.find.update();
              onLogin?.call();
            }),
          ),
        ],
      );

  static Widget userImage({double? size = 100, User? providedUser, void Function()? onEdit}) {
    final user = providedUser ?? AuthenticationService.find.jwtUserData;
    Widget buildPicture({double fontSize = 24}) => Stack(
          children: [
            Badge(
              isLabelVisible: false, // isAvatarIcon && AuthenticationService.find.notSeenMessages.value != 0,
              // label: Text(AuthenticationService.find.notSeenMessages.value.toString(), style: AppFonts.x10Regular.copyWith(color: kNeutralColor100)),
              child: ClipRRect(
                borderRadius: circularRadius,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: kPrimaryColor),
                    child: user?.picture != null
                        ? Image.network(
                            user!.picture!,
                            fit: BoxFit.cover,
                            width: size,
                            height: size,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(Helper.getNameInitials(user.name), style: AppFonts.x24Bold.copyWith(fontSize: fontSize)),
                            ),
                          )
                        : Center(child: Text(Helper.getNameInitials(user?.name), style: AppFonts.x24Bold.copyWith(fontSize: fontSize))),
                  ),
                ),
              ),
            ),
            if (onEdit != null)
              Positioned(
                bottom: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: kNeutralColor100,
                  child: CustomButtons.icon(icon: const Icon(Icons.camera_alt_outlined, size: 14), onPressed: onEdit),
                ),
              ),
          ],
        );
    return CircleAvatar(radius: size! / 2, backgroundColor: kPrimaryColor, child: buildPicture(fontSize: size * 0.3));
  }

  static Widget lightDivider({EdgeInsets? padding}) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Divider(thickness: 0.4, color: kNeutralColor),
      );

  static Widget buildProfileInfoRow(String label, String value) => SizedBox(
        height: 30,
        child: Row(
          children: [
            Text(label, style: AppFonts.x14Bold),
            Expanded(
              child: Align(
                alignment: Helper.isArabic ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  textDirection: TextDirection.ltr,
                  value,
                  style: AppFonts.x14Regular,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      );

  static Widget lightVerticalDivider({EdgeInsets? padding, bool expand = false, double? height}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
        child: Container(color: kNeutralLightColor, width: 1, height: expand ? height ?? Get.height * 0.8 : 50),
      );

  static Future<void> requestBottomsheet({
    required TextEditingController noteController,
    TextEditingController? proposedPriceController,
    TextEditingController? deliveryDateController,
    required void Function() onSubmit,
    bool isTask = false,
  }) async {
    double height = proposedPriceController != null && deliveryDateController != null
        ? 450
        : (proposedPriceController != null || deliveryDateController != null)
            ? 390
            : 330;
    await Get.bottomSheet(
      SizedBox(
        height: height,
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: Column(
              children: [
                const SizedBox(height: Paddings.regular),
                Center(child: Text(isTask ? 'add_proposal'.tr : 'request_service'.tr, style: AppFonts.x16Bold)),
                const SizedBox(height: Paddings.exceptional),
                CustomTextField(
                  fieldController: noteController,
                  isTextArea: true,
                  outlinedBorder: true,
                  outlinedBorderColor: kNeutralColor,
                  hintText: isTask ? 'add_note_task_owner'.tr : 'add_note_store_owner'.tr,
                ),
                if (proposedPriceController != null) ...[
                  const SizedBox(height: Paddings.regular),
                  CustomTextField(
                    fieldController: proposedPriceController,
                    outlinedBorder: true,
                    outlinedBorderColor: kNeutralColor,
                    hintText: 'propose_new_price'.tr,
                  ),
                ],
                if (proposedPriceController != null) ...[
                  const SizedBox(height: Paddings.regular),
                  CustomTextField(
                    fieldController: deliveryDateController,
                    outlinedBorder: true,
                    outlinedBorderColor: kNeutralColor,
                    onTap: () => Helper.openDatePicker(
                      isFutureDate: true,
                      onConfirm: (date) => deliveryDateController!.text = Helper.formatDate(date),
                    ),
                    hintText: 'delivery_date'.tr,
                  ),
                ],
                const SizedBox(height: Paddings.exceptional),
                CustomButtons.elevatePrimary(
                  title: isTask ? 'submit_proposal'.tr : 'submit_request'.tr,
                  width: Get.width,
                  onPressed: onSubmit,
                )
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Future<void> createContractBottomsheet({
    required Contract contract,
    required void Function(Contract) onSubmit,
    bool isTask = false,
  }) async {
    final GlobalKey<FormState> formKey = GlobalKey();
    final TextEditingController finalPriceController = TextEditingController(text: Helper.formatAmount(contract.finalPrice));
    final TextEditingController dueDateController = TextEditingController(text: contract.dueDate != null ? Helper.formatDate(contract.dueDate!) : '');
    final TextEditingController descriptionController = TextEditingController(text: isTask ? contract.task!.description : contract.service!.description);
    final TextEditingController delivrablesController = TextEditingController(text: isTask ? contract.task!.delivrables : contract.service!.included);
    await Get.bottomSheet(
      SizedBox(
        height: 600,
        child: Material(
          color: kNeutralColor100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: Paddings.regular),
                    Center(child: Text('create_contract'.tr, style: AppFonts.x16Bold)),
                    const SizedBox(height: Paddings.exceptional),
                    CustomTextField(
                      fieldController: finalPriceController,
                      outlinedBorder: true,
                      outlinedBorderColor: kNeutralColor,
                      hintText: 'price'.tr,
                      validator: FormValidators.notEmptyOrNullFloatValidator,
                    ),
                    const SizedBox(height: Paddings.regular),
                    CustomTextField(
                      fieldController: dueDateController,
                      outlinedBorder: true,
                      outlinedBorderColor: kNeutralColor,
                      onTap: () => Helper.openDatePicker(
                        isFutureDate: true,
                        onConfirm: (date) => dueDateController.text = Helper.formatDate(date),
                      ),
                      hintText: 'delivery_date'.tr,
                      validator: FormValidators.notEmptyOrNullValidator,
                    ),
                    const SizedBox(height: Paddings.regular),
                    CustomTextField(
                      fieldController: descriptionController,
                      outlinedBorder: true,
                      isTextArea: true,
                      outlinedBorderColor: kNeutralColor,
                      hintText: 'description'.tr,
                      validator: FormValidators.notEmptyOrNullValidator,
                    ),
                    const SizedBox(height: Paddings.regular),
                    CustomTextField(
                      fieldController: delivrablesController,
                      outlinedBorder: true,
                      isTextArea: true,
                      outlinedBorderColor: kNeutralColor,
                      hintText: 'expected_delivrables'.tr,
                      validator: FormValidators.notEmptyOrNullValidator,
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    CustomButtons.elevatePrimary(
                      title: isTask ? 'submit_proposal'.tr : 'submit_request'.tr,
                      width: Get.width,
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          onSubmit(
                            Contract(
                              finalPrice: double.tryParse(finalPriceController.text) ?? 0,
                              dueDate: Helper.parseDisplayedDate(dueDateController.text),
                              task: contract.task,
                              service: contract.service,
                              createdAt: DateTime.now(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Widget buildTitle(String title, {void Function()? onSeeMore}) => Padding(
        padding: const EdgeInsets.only(bottom: Paddings.regular),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppFonts.x16Bold),
            if (onSeeMore != null)
              Padding(
                padding: const EdgeInsets.only(left: Paddings.regular),
                child: CustomButtons.text(
                  title: 'see_more'.tr,
                  titleStyle: AppFonts.x11Bold.copyWith(color: kAccentColor),
                  onPressed: onSeeMore,
                ),
              ),
          ],
        ),
      );
}
