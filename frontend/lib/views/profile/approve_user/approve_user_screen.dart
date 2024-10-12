import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/user_approve_dto.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../profile_screen/profile_controller.dart';
import 'approve_user_controller.dart';

class ApproveUserScreen extends StatelessWidget {
  static const String routeName = '/approve-users';
  const ApproveUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ApproveUserController>(
        autoRemove: false,
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'approve_users'.tr,
          onBack: () => ProfileController.find.init(),
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.userApproveList.isEmpty
                ? Center(child: Text('no_users_yet'.tr, style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.userApproveList.length,
                    itemBuilder: (context, index) {
                      final userApprove = controller.userApproveList[index];
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
                                  () => context.mounted ? setState(() => highlighted = userApprove.user?.id == controller.highlightedUserApprove?.user?.id) : null,
                                );
                              }
                              isInitialized = true;
                              return ExpansionTile(
                                key: Key(userApprove.hashCode.toString()),
                                title: buildUserCard(userApprove),
                                tilePadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                                backgroundColor: kNeutralLightOpacityColor,
                                collapsedBackgroundColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Buildables.buildProfileInfoRow('email'.tr, userApprove.user?.email ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow(
                                    'birthdate'.tr,
                                    userApprove.user?.birthdate != null ? Helper.formatDate(userApprove.user!.birthdate!) : 'not_provided'.tr,
                                  ),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow('gender'.tr, userApprove.user?.gender?.value ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  const SizedBox(height: Paddings.large),
                                  Text('user_document'.tr, style: AppFonts.x15Bold),
                                  const SizedBox(height: Paddings.regular),
                                  if (userApprove.userDocument == null)
                                    Text('document_not_available'.tr, style: AppFonts.x12Bold.copyWith(color: kErrorColor))
                                  else
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          if (userApprove.userDocument!.isPassport)
                                            // Passport pictures
                                            Column(
                                              children: [
                                                buildImage(userApprove.userDocument!.passport!, context),
                                                const SizedBox(height: Paddings.regular),
                                                Text('passport_picture'.tr, style: AppFonts.x12Bold),
                                              ],
                                            )
                                          else ...[
                                            // Identity pictures
                                            Column(
                                              children: [
                                                buildImage(userApprove.userDocument!.frontIdentity!, context),
                                                const SizedBox(height: Paddings.regular),
                                                Text('front_picture'.tr, style: AppFonts.x12Bold),
                                              ],
                                            ),
                                            const SizedBox(width: Paddings.regular),
                                            Column(
                                              children: [
                                                buildImage(userApprove.userDocument!.backIdentity!, context),
                                                const SizedBox(height: Paddings.regular),
                                                Text('back_picture'.tr, style: AppFonts.x12Bold),
                                              ],
                                            ),
                                          ],
                                          // Selfie picture
                                          const SizedBox(width: Paddings.regular),
                                          Column(
                                            children: [
                                              buildImage(userApprove.userDocument!.selfie!, context),
                                              const SizedBox(height: Paddings.regular),
                                              Text('selfie_picture'.tr, style: AppFonts.x12Bold),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: Paddings.extraLarge),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButtons.text(
                                        title: 'not_approvable'.tr,
                                        titleStyle: AppFonts.x14Regular,
                                        onPressed: () => controller.couldNotApprove(userApprove.user),
                                      ),
                                      CustomButtons.icon(
                                        icon: const Icon(Icons.phone_outlined),
                                        onPressed: () => controller.callUser(userApprove.user),
                                      ),
                                      CustomButtons.elevatePrimary(
                                        title: 'approve'.tr,
                                        width: (Get.width - 120) / 2,
                                        onPressed: () => controller.approveUser(userApprove.user),
                                      )
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

  Widget buildUserCard(UserApproveDTO userApprove) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Buildables.userImage(providedUser: userApprove.user, size: 40),
      title: Text(userApprove.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Bold),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(userApprove.user?.phone ?? 'not_provided'.tr, style: AppFonts.x14Regular),
          Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pin_drop_outlined, size: 14),
                const SizedBox(width: Paddings.small),
                Text(userApprove.user?.governorate?.name ?? 'city'.tr, style: AppFonts.x14Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
