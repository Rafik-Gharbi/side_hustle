import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';
import '../services/theme/theme.dart';
import '../views/account/login_dialog.dart';
import '../views/home/home_controller.dart';
import '../widgets/custom_buttons.dart';
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
            title: 'Login',
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
              // TODO add user verified badge
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
    return CircleAvatar(radius: size! / 2, backgroundColor: kPrimaryColor, child: buildPicture());
  }

  static Widget lightDivider() => Divider(thickness: 0.4, color: kNeutralColor);
}
