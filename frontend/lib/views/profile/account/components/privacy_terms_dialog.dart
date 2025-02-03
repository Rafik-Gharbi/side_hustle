import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../helpers/helper.dart';
import '../../../../repositories/params_repository.dart';
import '../../../../services/authentication_service.dart';
import '../../../../services/theme/theme.dart';

class PrivacyTermsDialog extends StatelessWidget {
  const PrivacyTermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTerms = true;
    return GetBuilder<AuthenticationService>(
      builder: (controller) => Helper.buildDialog(
        padding: const EdgeInsets.all(Paddings.large),
        child: StatefulBuilder(builder: (context, setState) {
          Future<File?>? future = isTerms ? ParamsRepository.find.getTermsCondition() : ParamsRepository.find.getPrivacyPolicy();
          return FutureBuilder<File?>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('error_occurred'.tr));
              } else if (!snapshot.hasData) {
                return Center(child: Text('no_file_available'.tr));
              } else {
                return SizedBox(
                  width: Get.width,
                  height: Get.height * 0.65,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(Paddings.small),
                          child: DecoratedBox(
                            decoration: BoxDecoration(border: regularBorder, borderRadius: smallRadius),
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: ClipRRect(borderRadius: smallRadius, child: SfPdfViewer.file(snapshot.data!, pageSpacing: 1)),
                            ),
                          ),
                        ),
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
                                recognizer: TapGestureRecognizer()..onTap = () => setState(() => isTerms = true),
                              ),
                              TextSpan(text: ' ${'and'.tr} ', style: AppFonts.x14Regular),
                              TextSpan(
                                text: 'privacy_policy'.tr,
                                style: AppFonts.x14Regular.copyWith(color: kPrimaryColor),
                                recognizer: TapGestureRecognizer()..onTap = () => setState(() => isTerms = false),
                              ),
                              TextSpan(text: '.', style: AppFonts.x14Regular),
                            ],
                          ),
                        ),
                        leading: Obx(
                          () => Checkbox(
                            checkColor: kNeutralColor100,
                            value: controller.acceptedTermsPrivacy.value,
                            onChanged: (value) {
                              controller.acceptedTermsPrivacy.value = !controller.acceptedTermsPrivacy.value;
                              if (controller.acceptedTermsPrivacy.value) Future.delayed(Durations.long4, Get.back);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
