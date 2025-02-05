import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/form_validators.dart';
import '../services/theme/theme.dart';
import 'custom_text_field.dart';

class PhoneOTPDialog extends StatelessWidget {
  final String phone;
  final bool isEmail;
  const PhoneOTPDialog({super.key, required this.phone, this.isEmail = false});

  @override
  Widget build(BuildContext context) => GetPlatform.isMobile
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
          child: buildContent(),
        )
      : AlertDialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: GetPlatform.isMobile ? EdgeInsets.zero : null,
          alignment: Alignment.bottomCenter,
          scrollable: true,
          content: buildContent(),
        );

  Align buildContent() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Paddings.exceptional),
        child: DecoratedBox(
          decoration: BoxDecoration(color: kNeutralColor100, borderRadius: regularRadius),
          child: SizedBox(
            width: GetPlatform.isMobile ? Get.width : 450,
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Paddings.exceptional),
                    child: Center(child: Text(isEmail ? 'email_verify'.tr : 'phone_verify'.tr, style: AppFonts.x18Bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                    child: Center(child: Lottie.asset(Assets.otpPhone, height: 150, fit: BoxFit.contain)),
                  ),
                  const SizedBox(height: Paddings.exceptional),
                  Text(isEmail ? 'verify_email_msg'.tr : 'verify_phone_msg'.tr, style: AppFonts.x16Regular),
                  Text(phone, style: AppFonts.x16Bold),
                  const SizedBox(height: Paddings.exceptional),
                  CustomTextField(
                    validator: (value) => FormValidators.exactNumberOfIntValidator(value, 6),
                    width: GetPlatform.isMobile ? Get.width - 60 : Get.width,
                    textInputType: const TextInputType.numberWithOptions(),
                    hintText: 'verification_key'.tr,
                    outlinedBorder: true,
                    onChanged: (value) {
                      if (value.length == 6) Get.back(result: value);
                    },
                  ),
                  const SizedBox(height: Paddings.exceptional),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
