import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/shared_preferences_keys.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../models/contract.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';
import '../services/payment_service.dart';
import '../services/shared_preferences.dart';
import '../services/theme/theme.dart';
import '../services/tutorials/create_contract_tutorial.dart';
import '../views/profile/account/login_dialog.dart';
import '../views/home/home_controller.dart';
import '../widgets/coins_market.dart';
import '../widgets/custom_bottomsheet.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/main_screen_with_bottom_navigation.dart';
import 'form_validators.dart';
import 'helper.dart';

class Buildables {
  static Widget buildPhoneInput({
    String? initialNumber,
    required void Function(PhoneNumber?) onChanged,
    bool isRequired = true,
    PhoneController? controller,
    bool outlinedBorder = false,
  }) =>
      Theme(
        data: ThemeData(bottomSheetTheme: const BottomSheetThemeData(backgroundColor: kNeutralColor100)),
        child: Directionality(
          textDirection: TextDirection.ltr,
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
                padding: EdgeInsets.only(bottom: 0, right: 10, left: 15),
              ),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                errorStyle: AppFonts.x12Regular.copyWith(color: kErrorColor),
                contentPadding: outlinedBorder
                    ? const EdgeInsets.symmetric(horizontal: Paddings.large).copyWith(top: Paddings.extraLarge)
                    : const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                hintText: '${'phone'.tr} (${'required'.tr})',
                // label: enableFloatingLabel ? Text(hintText ?? '', style: hintTextStyle ?? AppFonts.x14Regular.copyWith(color: kNeutralColor)) : null,
                border: outlinedBorder
                    ? OutlineInputBorder(borderRadius: smallRadius, borderSide: const BorderSide(color: kNeutralLightColor))
                    : const UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
                enabledBorder: outlinedBorder
                    ? OutlineInputBorder(borderRadius: smallRadius, borderSide: const BorderSide(color: kNeutralLightColor))
                    : const UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
                focusedBorder: outlinedBorder
                    ? OutlineInputBorder(borderRadius: smallRadius, borderSide: const BorderSide(color: kNeutralLightColor))
                    : const UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
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
        ),
      );

  static Widget buildLoadingWidget({double? height}) =>
      SizedBox(height: height ?? Get.height * 0.9, child: Center(child: Lottie.asset(Assets.fetchingData, height: height != null ? height - 20 : 100)));

  static Widget buildLoginRequest({String? message, void Function()? onLogin}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
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

  static Widget lightDivider({EdgeInsets? padding, Color? color}) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Divider(thickness: 0.4, color: color ?? kNeutralColor),
      );

  static Widget buildProfileInfoRow(String label, String value, {Widget? extraWidget}) => SizedBox(
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
            if (extraWidget != null) extraWidget
          ],
        ),
      );

  static Widget verticalDivider({EdgeInsets? padding, bool expand = false, double? height, Color? color, double? thickness}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
        child: Container(
          decoration: BoxDecoration(color: color ?? kNeutralLightColor, borderRadius: regularRadius),
          width: thickness ?? 1,
          height: expand ? height ?? Get.height * 0.8 : 50,
        ),
      );

  static Future<void> requestBottomsheet({
    required TextEditingController noteController,
    required void Function() onSubmit,
    required int neededCoins,
    required RxBool isLoading,
    TextEditingController? proposedPriceController,
    TextEditingController? deliveryDateController,
    bool isTask = false,
  }) async {
    double height = proposedPriceController != null && deliveryDateController != null
        ? 480
        : (proposedPriceController != null || deliveryDateController != null)
            ? 420
            : 360;
    await CustomBottomsheet(
      height: height,
      title: isTask ? 'add_proposal'.tr : 'request_service'.tr,
      child: Column(
        children: [
          const SizedBox(height: Paddings.regular),
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
              textInputType: const TextInputType.numberWithOptions(decimal: true),
              hintText: 'propose_new_price'.tr,
            ),
          ],
          if (deliveryDateController != null) ...[
            const SizedBox(height: Paddings.regular),
            CustomTextField(
              fieldController: deliveryDateController,
              outlinedBorder: true,
              outlinedBorderColor: kNeutralColor,
              onTap: () => Helper.openDatePicker(
                isFutureDate: true,
                onConfirm: (date) => deliveryDateController.text = Helper.formatDate(date),
              ),
              hintText: 'delivery_date'.tr,
            ),
          ],
          const SizedBox(height: Paddings.exceptional),
          CustomButtons.elevatePrimary(
            title: isTask ? 'submit_proposal'.tr : 'submit_request'.tr,
            width: Get.width,
            loading: isLoading,
            onPressed: onSubmit,
            disabled: neededCoins <= 0 || neededCoins > (AuthenticationService.find.jwtUserData?.totalCoins ?? 0),
          ),
          const SizedBox(height: Paddings.small),
          Text(
            '${isTask ? 'task'.tr : 'service'.tr} ${'costs_coins_msg'.trParams({
                  'coins': neededCoins.toString(),
                  'baseCoins': (AuthenticationService.find.jwtUserData?.totalCoins ?? 0).toString()
                })}',
            style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
          ),
          const SizedBox(height: Paddings.extraLarge),
        ],
      ),
    ).showBottomSheet(isScrollControlled: true);
  }

  static Future<void> createContractBottomsheet({
    required Contract contract,
    required void Function(Contract) onSubmit,
    required BuildContext context,
    required RxBool isLoading,
    bool isTask = false,
  }) async {
    final GlobalKey<FormState> formKey = GlobalKey();
    final TextEditingController finalPriceController = TextEditingController(text: Helper.formatAmount(contract.finalPrice));
    final TextEditingController dueDateController = TextEditingController(text: contract.dueDate != null ? Helper.formatDate(contract.dueDate!) : '');
    final TextEditingController descriptionController = TextEditingController(text: isTask ? contract.task!.description : contract.service?.description ?? '');
    final TextEditingController delivrablesController = TextEditingController(text: isTask ? contract.task!.delivrables : contract.service?.included ?? '');
    RxBool hasOpenedTutorial = false.obs;
    final hasFinishedCreateContractTutorial = SharedPreferencesService.find.get(hasFinishedCreateContractTutorialKey) == 'true';
    if (!hasFinishedCreateContractTutorial && !hasOpenedTutorial.value && CreateContractTutorial.targets.isNotEmpty) {
      hasOpenedTutorial.value = true;
      MainScreenWithBottomNavigation.isOnTutorial.value = true;
      Future.delayed(
        Durations.extralong2,
        () => TutorialCoachMark(
          targets: CreateContractTutorial.targets,
          colorShadow: kNeutralOpacityColor,
          textSkip: 'skip'.tr,
          additionalWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
            child: Obx(
              () => CheckboxListTile(
                dense: true,
                checkColor: kNeutralColor100,
                contentPadding: EdgeInsets.zero,
                side: const BorderSide(color: kNeutralColor100),
                title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                value: CreateContractTutorial.notShowAgain.value,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) => CreateContractTutorial.notShowAgain.value = value ?? false,
              ),
            ),
          ),
          onSkip: () {
            if (CreateContractTutorial.notShowAgain.value) {
              SharedPreferencesService.find.add(hasFinishedCreateContractTutorialKey, 'true');
            }
            MainScreenWithBottomNavigation.isOnTutorial.value = false;
            hasOpenedTutorial.value = false;
            return true;
          },
          onFinish: () => SharedPreferencesService.find.add(hasFinishedCreateContractTutorialKey, 'true'),
        ).show(context: context),
      );
    }
    await CustomBottomsheet(
      height: 600,
      title: 'create_contract'.tr,
      child: Obx(
        () => PopScope(
          canPop: !hasOpenedTutorial.value,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: Paddings.regular),
                  Column(
                    key: CreateContractTutorial.contractFormKey,
                    children: [
                      CustomTextField(
                        fieldController: finalPriceController,
                        outlinedBorder: true,
                        isOptional: false,
                        outlinedBorderColor: kNeutralColor,
                        hintText: 'price'.tr,
                        validator: FormValidators.notEmptyOrNullFloatValidator,
                      ),
                      const SizedBox(height: Paddings.regular),
                      CustomTextField(
                        fieldController: dueDateController,
                        outlinedBorder: true,
                        isOptional: false,
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
                        isOptional: false,
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
                        isOptional: false,
                        outlinedBorderColor: kNeutralColor,
                        hintText: 'expected_delivrables'.tr,
                        validator: FormValidators.notEmptyOrNullValidator,
                      ),
                    ],
                  ),
                  const SizedBox(height: Paddings.exceptional),
                  CustomButtons.elevatePrimary(
                    title: 'create'.tr,
                    loading: isLoading,
                    width: Get.width,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        onSubmit(
                          Contract(
                            finalPrice: double.tryParse(finalPriceController.text) ?? 0,
                            dueDate: Helper.parseDisplayedDate(dueDateController.text),
                            description: descriptionController.text,
                            delivrables: delivrablesController.text,
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
    ).showBottomSheet(isScrollControlled: true);
  }

  static Widget buildTitle(String title, {void Function()? onSeeMore, Widget? overrideTitle}) => Padding(
        padding: const EdgeInsets.only(bottom: Paddings.regular),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            overrideTitle ?? Text(title, style: AppFonts.x16Bold),
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

  static Widget buildAvailableCoins({void Function()? onBackFromMarket, bool withBuyButton = true, GlobalKey? key}) => Padding(
        padding: const EdgeInsets.all(Paddings.large),
        child: DecoratedBox(
          key: key,
          decoration: BoxDecoration(borderRadius: smallRadius, color: kAccentColor),
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${'available'.tr}:', style: AppFonts.x16Bold.copyWith(color: kNeutralColor100)),
                    const SizedBox(width: Paddings.regular),
                    const Icon(Icons.paid_outlined, size: 22, color: kNeutralColor100),
                    const SizedBox(width: Paddings.regular),
                    Text(
                      '${AuthenticationService.find.jwtUserData!.totalCoins} ${'coins'.tr}',
                      style: AppFonts.x16Bold.copyWith(color: kNeutralColor100),
                    ),
                  ],
                ),
                Text(
                  '(${'base_coins'.tr}: ${AuthenticationService.find.jwtUserData!.availableCoins} + ${'purchased_coins'.tr}: ${AuthenticationService.find.jwtUserData!.availablePurchasedCoins})',
                  style: AppFonts.x12Regular.copyWith(color: kNeutralColor100),
                ),
                const SizedBox(height: Paddings.regular),
                if (withBuyButton)
                  InkWell(
                    onTap: MainAppController.find.isConnected ? () => Get.toNamed(CoinsMarket.routeName)?.then((value) => onBackFromMarket?.call()) : null,
                    child: Text(
                      'buy_more_coins'.tr,
                      style: AppFonts.x12Bold
                          .copyWith(decoration: TextDecoration.underline, decorationColor: kSelectedLightColor, color: kSelectedLightColor, decorationThickness: 0.6),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  static Widget buildCategoryIcon(String icon, {double size = 30, Color? color}) => CachedNetworkImage(
        imageUrl: icon,
        width: size,
        color: color ?? kBlackColor,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => const CircularProgressIndicator(color: kNeutralLightColor),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        // errorListener: (error) => LoggerService.logger?.e(error),
      );

  /// Should be called on a screen and not a dialog or a bottomsheet opened
  static Widget buildPaymentOptionsBottomsheet({
    required void Function() onSuccessPayment,
    required double totalPrice,
    String? contractId,
    String? taskId,
    String? serviceId,
    int? coinPackId,
  }) =>
      Material(
        color: kNeutralColor100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SizedBox(
          height: 270,
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: Column(
              children: [
                Text('payment_options'.tr, style: AppFonts.x16Bold.copyWith(color: kBlackColor)),
                const SizedBox(height: Paddings.regular),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                  dense: true,
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('flouci'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  subtitle: Text('flouci_option'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  leading: Image.asset(Assets.flouciIcon, width: 25, height: 25),
                  onTap: () async {
                    Helper.goBack();
                    final result = await PaymentService.find.initFlouciPayment(totalPrice, taskId: taskId, serviceId: serviceId, coinPackId: coinPackId, contractId: contractId);
                    if (result ?? false) {
                      Helper.snackBar(message: 'payment_successful'.tr);
                      onSuccessPayment.call();
                    }
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                  dense: true,
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('bank_card'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  subtitle: Text('bank_card_option'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  leading: const Icon(Icons.payment_outlined),
                  onTap: () async {
                    Helper.goBack();
                    final result = await PaymentService.find.payWithBankCard(totalPrice, taskId: taskId, serviceId: serviceId, coinPackId: coinPackId, contractId: contractId);
                    if (result) {
                      Helper.snackBar(message: 'payment_successful'.tr);
                      onSuccessPayment.call();
                    }
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                  dense: true,
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('pay_with_balance'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  subtitle: Text(
                    '${'balance_option'.tr}${Helper.formatAmount(AuthenticationService.find.jwtUserData?.balance ?? 0)} ${MainAppController.find.currency.value}',
                    style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                  ),
                  leading: const Icon(Icons.attach_money_outlined),
                  onTap: () async {
                    Helper.goBack();
                    final result = await PaymentService.find.payWithBalance(totalPrice, taskId: taskId, serviceId: serviceId, coinPackId: coinPackId, contractId: contractId);
                    if (result) {
                      Helper.snackBar(message: 'payment_successful'.tr);
                      onSuccessPayment.call();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );

  static Widget buildImagePickerTypeBottomsheet({required void Function(ImageSource) onSelectType}) => Material(
        color: kNeutralColor100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SizedBox(
          height: 190,
          child: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: Column(
              children: [
                Text('choose_source'.tr, style: AppFonts.x16Bold.copyWith(color: kBlackColor)),
                const SizedBox(height: Paddings.regular),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                  dense: true,
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('gallery'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  leading: const Icon(Icons.image_outlined),
                  onTap: () => onSelectType(ImageSource.gallery),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                  dense: true,
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('camera'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  leading: const Icon(Icons.camera_alt_outlined),
                  onTap: () => onSelectType(ImageSource.camera),
                ),
              ],
            ),
          ),
        ),
      );

  static Widget buildActionTile({
    Key? key,
    required String label,
    required IconData icon,
    required void Function() onTap,
    int actionRequired = 0,
    bool enabled = true,
  }) =>
      CustomButtons.text(
        key: key,
        disabled: !enabled,
        onPressed: onTap,
        child: ListTile(
          enabled: enabled,
          title: Text(label, style: AppFonts.x14Bold.copyWith(color: enabled ? kBlackColor : kDisabledColor)),
          contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
          leading: Badge(
            offset: const Offset(5, -5),
            largeSize: 18,
            isLabelVisible: actionRequired > 0,
            label: Text(
              actionRequired.toString(),
              style: AppFonts.x10Bold.copyWith(color: kNeutralColor100),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: kNeutralLightColor,
              child: Icon(icon, size: 24, color: enabled ? kPrimaryColor : kDisabledColor),
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      );

  static TargetFocus buildTargetFocus({required GlobalKey<State<StatefulWidget>> keyTarget, List<Widget>? topContent, List<Widget>? bottomContent, bool isCircle = false}) {
    return TargetFocus(
      keyTarget: keyTarget,
      identify: 'Target ${keyTarget.toString()}',
      shape: isCircle ? ShapeLightFocus.Circle : ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        if (topContent != null)
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: topContent,
            ),
          ),
        if (bottomContent != null)
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bottomContent,
            ),
          )
      ],
    );
  }
}
