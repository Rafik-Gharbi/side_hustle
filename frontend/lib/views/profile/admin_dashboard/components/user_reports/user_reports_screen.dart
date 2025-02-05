import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/constants.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../helpers/buildables.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/dto/report_dto.dart';
import '../../../../../services/theme/theme.dart';
import '../../../../../widgets/custom_buttons.dart';
import '../../../../../widgets/custom_standard_scaffold.dart';
import '../../../../../widgets/hold_in_safe_area.dart';
import '../../../../../widgets/loading_request.dart';
import '../../../../../widgets/service_card.dart';
import '../../../../../widgets/task_card.dart';
import '../../../profile_screen/profile_controller.dart';
import '../../../user_profile/user_profile_screen.dart';
import 'user_reports_controller.dart';

class UserReportsScreen extends StatelessWidget {
  static const String routeName = '/reports';
  const UserReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<UserReportsController>(
        autoRemove: false,
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'reports'.tr,
          onBack: () => ProfileController.find.init(),
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.userReportList.isEmpty
                ? Center(child: Text('nothing_here_yet'.tr, style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.userReportList.length,
                    itemBuilder: (context, index) {
                      final report = controller.userReportList[index];
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
                                  () => context.mounted ? setState(() => highlighted = report.id == controller.highlightedReport?.id) : null,
                                );
                              }
                              isInitialized = true;
                              return ExpansionTile(
                                key: Key(report.hashCode.toString()),
                                title: buildUserCard(report),
                                tilePadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                                backgroundColor: kNeutralLightOpacityColor,
                                collapsedBackgroundColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Buildables.buildProfileInfoRow('email'.tr, report.reportedUser.email ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow(
                                    'birthdate'.tr,
                                    report.reportedUser.birthdate != null ? Helper.formatDate(report.reportedUser.birthdate!) : 'not_provided'.tr,
                                  ),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow('gender'.tr, report.reportedUser.gender?.value ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  const SizedBox(height: Paddings.large),
                                  Text('user_report'.tr, style: AppFonts.x15Bold),
                                  const SizedBox(height: Paddings.regular),
                                  ListTile(
                                    title: Row(
                                      children: [
                                        if (report.user != null)
                                          InkWell(
                                            onTap: () => Get.bottomSheet(
                                              ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                                child: UserProfileScreen(user: report.user),
                                              ),
                                              isScrollControlled: true,
                                            ),
                                            child: Buildables.userImage(providedUser: report.user, size: 40),
                                          )
                                        else
                                          Text('anonymus_user'.tr, style: AppFonts.x14Bold),
                                        const SizedBox(width: Paddings.small),
                                        Text('${'has_reported'.tr}: ', style: AppFonts.x14Regular),
                                        const SizedBox(width: Paddings.small),
                                        InkWell(
                                          onTap: () => Get.bottomSheet(
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                              child: UserProfileScreen(user: report.reportedUser),
                                            ),
                                            isScrollControlled: true,
                                          ),
                                          child: Buildables.userImage(providedUser: report.reportedUser, size: 40),
                                        ),
                                        const SizedBox(width: Paddings.small),
                                        Text(report.reportedUser.name ?? 'not_provided'.tr, style: AppFonts.x14Regular),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: Paddings.regular),
                                        Text(
                                          '${'in_his'.tr} ${report.task != null ? 'task'.tr : report.service != null ? 'service'.tr : 'NA'}',
                                          style: AppFonts.x12Regular,
                                        ),
                                        if (report.task != null)
                                          TaskCard(task: report.task!, dense: true)
                                        else if (report.service != null)
                                          ServiceCard(service: report.service!, dense: true),
                                        const SizedBox(height: Paddings.regular),
                                        Text('${'reason'.tr}: ${report.reasons.value.tr}', style: AppFonts.x12Regular),
                                        const SizedBox(height: Paddings.small),
                                        Text('${'explanation'.tr}: ${report.explanation}', style: AppFonts.x12Regular),
                                        const SizedBox(height: Paddings.regular),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(report.createdAt != null ? Helper.formatDateWithTime(report.createdAt!) : 'NA', style: AppFonts.x12Regular),
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
                                        onPressed: () => controller.callUser(report.user),
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

  Widget buildUserCard(ReportDTO report) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Buildables.userImage(providedUser: report.reportedUser, size: 40),
      title: Text(report.reportedUser.name ?? 'not_provided'.tr, style: AppFonts.x14Bold),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(report.reportedUser.phone ?? 'not_provided'.tr, style: AppFonts.x14Regular),
          Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pin_drop_outlined, size: 14),
                const SizedBox(width: Paddings.small),
                Text(report.reportedUser.governorate?.name ?? 'city'.tr, style: AppFonts.x14Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
