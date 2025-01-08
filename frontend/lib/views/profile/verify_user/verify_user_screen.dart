import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import 'components/build_document_files_picker.dart';
import 'components/build_finish_verification_process.dart';
import 'components/build_identity_document_chooser.dart';
import 'components/build_onboarding.dart';
import 'components/build_selfie_picture_picker.dart';
import 'verify_user_controller.dart';

class VerifyUserScreen extends StatelessWidget {
  static const String routeName = '/verify-user';
  const VerifyUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<VerifyUserController>(
        builder: (controller) => PopScope(
          onPopInvokedWithResult: (didPop, result) => didPop ? controller.clearData() : null,
          child: CustomStandardScaffold(
            backgroundColor: kNeutralColor100,
            title: 'verify_user'.tr,
            onBack: controller.clearData,
            body: Padding(
              padding: const EdgeInsets.only(bottom: Paddings.exceptional),
              child: controller.isOnBoarding
                  ? BuildOnboarding(onFinish: controller.startVerification)
                  : Padding(
                      padding: const EdgeInsets.all(Paddings.large),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.documentType == null)
                            BuildIdentityDocumentChooser(
                              onPassportSelected: () => controller.setDocumentType(DocumentType.passport),
                              onIdentityCardSelected: () => controller.setDocumentType(DocumentType.identityCard),
                            )
                          else if (!controller.hasProvidedDocument)
                            const BuildDocumentFilesPicker()
                          else if (controller.selfiePicture == null)
                            const BuildSelfiePicturePicker()
                          else if (controller.verifProcessIsGood)
                            const BuildFinishVerificationProcess(),
                          if (controller.documentType == null) const Spacer() else const SizedBox(height: Paddings.regular),
                          if (controller.showTimer)
                            Obx(
                              () => Column(
                                children: [
                                  Container(height: 2, width: (Get.width - 30) / 60 * controller.timerProgress.value.toDouble(), color: kNeutralColor),
                                  Center(
                                    child: Text(
                                      '${controller.timerProgress} ${'seconds_left'.tr}',
                                      style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
