import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/custom_text_field.dart';

class DeleteProfile extends StatelessWidget {
  static const String routeName = '/delete-profile';
  const DeleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController shareThoughts = TextEditingController();
    final TextEditingController otherFeedback = TextEditingController();
    bool hasSubmittedRequest = false;
    Map<String, bool> leaveFeedbacks = {
      'leave_feedback_1': false,
      'leave_feedback_2': false,
      'leave_feedback_3': false,
      'leave_feedback_4': false,
      'leave_feedback_5': false,
      'leave_feedback_other': false,
    };

    return CustomStandardScaffold(
      backgroundColor: kNeutralColor100,
      title: 'delete_profile'.tr,
      body: Padding(
        padding: const EdgeInsets.all(Paddings.large),
        child: StatefulBuilder(builder: (context, setState) {
          ListTile buildLeaveFeedbackTile(int index) => ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                dense: true,
                title: Text(leaveFeedbacks.entries.elementAt(index).key.tr, style: AppFonts.x14Regular),
                leading: Checkbox(
                  checkColor: kNeutralColor100,
                  value: leaveFeedbacks.entries.elementAt(index).value,
                  onChanged: (value) => setState(() => leaveFeedbacks[leaveFeedbacks.entries.elementAt(index).key] = !leaveFeedbacks.entries.elementAt(index).value),
                ),
              );
          return hasSubmittedRequest
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Paddings.extraLarge),
                      Text('request_received'.tr, style: AppFonts.x18Bold),
                      const SizedBox(height: Paddings.large),
                      Text('delete_profile_confirmation_msg'.tr, style: AppFonts.x14Regular),
                      Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.regular)),
                      Text('leave_feedback_question'.tr, style: AppFonts.x16Bold),
                      Text('leave_feedback_msg'.tr, style: AppFonts.x12Regular),
                      const SizedBox(height: Paddings.large),
                      buildLeaveFeedbackTile(0),
                      buildLeaveFeedbackTile(1),
                      buildLeaveFeedbackTile(2),
                      buildLeaveFeedbackTile(3),
                      buildLeaveFeedbackTile(4),
                      buildLeaveFeedbackTile(5),
                      if (leaveFeedbacks.entries.elementAt(5).value)
                        CustomTextField(
                          hintText: 'please_specify'.tr,
                          fieldController: otherFeedback,
                          outlinedBorder: true,
                        ),
                      const SizedBox(height: Paddings.regular),
                      Text('tell_us_more'.tr, style: AppFonts.x14Bold),
                      const SizedBox(height: Paddings.regular),
                      CustomTextField(
                        hintText: 'share_your_thought'.tr,
                        isTextArea: true,
                        fieldController: shareThoughts,
                        outlinedBorder: true,
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Center(
                        child: CustomButtons.elevatePrimary(
                          width: 250,
                          title: 'done'.tr,
                          onPressed: () => UserRepository.find.submitLeaveFeedback(
                            {
                              'reasons': leaveFeedbacks.entries
                                  .where((element) => element.value == true)
                                  .map((e) => Get.translations['en_US']?[e.key])
                                  .followedBy([if (leaveFeedbacks.entries.elementAt(5).value) 'OtherFeedback: ${otherFeedback.text}']).join(', '),
                              'thoughts': shareThoughts.text,
                            },
                          ).then((value) {
                            Get.back();
                            Helper.snackBar(message: 'feedback_thanks_msg'.tr);
                          }),
                        ),
                      ),
                      const SizedBox(height: Paddings.extraLarge),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Paddings.extraLarge),
                    Text('sure_delete_profile'.tr, style: AppFonts.x18Bold),
                    const SizedBox(height: Paddings.large),
                    Text('delete_profile_explication'.tr, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.exceptional),
                    Text('before_delete_know'.trParams({'userName': AuthenticationService.find.jwtUserData?.name ?? 'user'.tr}), style: AppFonts.x16Bold),
                    const SizedBox(height: Paddings.large),
                    Text('delete_profile_info'.tr, style: AppFonts.x14Regular),
                    const Spacer(),
                    Center(
                      child: CustomButtons.elevatePrimary(
                        width: 250,
                        title: 'go_back'.tr,
                        onPressed: Get.back,
                      ),
                    ),
                    const SizedBox(height: Paddings.regular),
                    Center(
                      child: CustomButtons.elevateSecondary(
                        width: 250,
                        title: 'delete_profile'.tr,
                        onPressed: () => UserRepository.find.deleteProfile().then(
                          (value) {
                            if (value) setState(() => hasSubmittedRequest = true);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: Paddings.extraLarge),
                  ],
                );
        }),
      ),
    );
  }
}
