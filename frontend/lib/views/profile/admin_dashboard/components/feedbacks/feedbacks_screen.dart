import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/constants.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../helpers/buildables.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/feedback_dto.dart';
import '../../../../../services/theme/theme.dart';
import '../../../../../widgets/custom_buttons.dart';
import '../../../../../widgets/custom_standard_scaffold.dart';
import '../../../../../widgets/hold_in_safe_area.dart';
import '../../../../../widgets/loading_request.dart';
import '../../../profile_screen/profile_controller.dart';
import '../../../user_profile/user_profile_screen.dart';
import 'feedbacks_controller.dart';

class FeedbacksScreen extends StatelessWidget {
  static const String routeName = '/feedbacks';
  const FeedbacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<FeedbacksController>(
        autoRemove: false,
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'feedbacks'.tr,
          onBack: () => ProfileController.find.init(),
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.feedbackList.isEmpty
                ? Center(child: Text('nothing_here_yet'.tr, style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedbackDTO = controller.feedbackList[index];
                      bool highlighted = false;
                      bool isInitialized = false;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                        child: Theme(
                          data: ThemeData(dividerColor: Colors.transparent),
                          child: ClipRRect(
                            borderRadius: smallRadius,
                            child: StatefulBuilder(builder: (context, setState) {
                              if (context.mounted && !isInitialized) {
                                Future.delayed(
                                  const Duration(milliseconds: 600),
                                  () => context.mounted ? setState(() => highlighted = feedbackDTO.id == controller.highlightedFeedback?.id) : null,
                                );
                              }
                              isInitialized = true;
                              return ExpansionTile(
                                key: Key(feedbackDTO.hashCode.toString()),
                                title: buildUserCard(feedbackDTO),
                                tilePadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                                backgroundColor: kNeutralLightOpacityColor,
                                collapsedBackgroundColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Buildables.buildProfileInfoRow('email'.tr, feedbackDTO.user?.email ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow(
                                    'birthdate'.tr,
                                    feedbackDTO.user?.birthdate != null ? Helper.formatDate(feedbackDTO.user!.birthdate!) : 'not_provided'.tr,
                                  ),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow('gender'.tr, feedbackDTO.user?.gender?.value ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  const SizedBox(height: Paddings.large),
                                  Text('user_feedback'.tr, style: AppFonts.x15Bold),
                                  const SizedBox(height: Paddings.regular),
                                  ListTile(
                                    title: Row(
                                      children: [
                                        InkWell(
                                          onTap: () => Get.bottomSheet(
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                              child: UserProfileScreen(user: feedbackDTO.user),
                                            ),
                                            isScrollControlled: true,
                                          ),
                                          child: Buildables.userImage(providedUser: feedbackDTO.user, size: 40),
                                        ),
                                        const SizedBox(width: Paddings.small),
                                        Text(feedbackDTO.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Regular),
                                        const SizedBox(width: Paddings.small),
                                        Text('is_feeling'.tr, style: AppFonts.x14Regular),
                                        const SizedBox(width: Paddings.small),
                                        Text(feedbackDTO.feedback.value.tr, style: AppFonts.x14Bold),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: Paddings.small),
                                        Text('${'comment'.tr}: ${feedbackDTO.comment}', style: AppFonts.x12Regular),
                                        const SizedBox(height: Paddings.regular),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(feedbackDTO.createdAt != null ? Helper.formatDateWithTime(feedbackDTO.createdAt!) : 'NA', style: AppFonts.x12Regular),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.regular),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButtons.icon(
                                        icon: const Icon(Icons.phone_outlined),
                                        onPressed: () => controller.callUser(feedbackDTO.user),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Paddings.regular),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String path, BuildContext context) {
    return InkWell(
      onTap: () => showImageViewer(context, Image.network(path).image),
      child: ClipRRect(
        borderRadius: smallRadius,
        child: Image.network(path, height: (Get.width - 100) / 2, width: (Get.width - 100) / 2, fit: BoxFit.cover),
      ),
    );
  }

  Widget buildUserCard(FeedbackDTO feedback) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Buildables.userImage(providedUser: feedback.user, size: 40),
      title: Text(feedback.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Bold),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(feedback.feedback.name.tr, style: AppFonts.x14Regular),
          Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pin_drop_outlined, size: 14),
                const SizedBox(width: Paddings.small),
                Text(feedback.user?.governorate?.name ?? 'city'.tr, style: AppFonts.x14Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
