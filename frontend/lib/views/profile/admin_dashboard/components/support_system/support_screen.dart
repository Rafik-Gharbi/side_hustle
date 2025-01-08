import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/constants.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../helpers/buildables.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/support_ticket.dart';
import '../../../../../services/theme/theme.dart';
import '../../../../../widgets/custom_buttons.dart';
import '../../../../../widgets/custom_standard_scaffold.dart';
import '../../../../../widgets/hold_in_safe_area.dart';
import '../../../../../widgets/loading_request.dart';
import '../../../profile_screen/profile_controller.dart';
import '../../../user_profile/user_profile_screen.dart';
import '../../../../support/components/ticket_details.dart';
import 'support_controller.dart';

class SupportScreen extends StatelessWidget {
  static const String routeName = '/support';
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<SupportController>(
        autoRemove: false,
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'support_system'.tr,
          onBack: () => ProfileController.find.init(),
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.ticketList.isEmpty
                ? Center(child: Text('nothing_here_yet'.tr, style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.ticketList.length,
                    itemBuilder: (context, index) {
                      final supportTicket = controller.ticketList[index];
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
                                  () => context.mounted ? setState(() => highlighted = supportTicket.id == controller.highlightedTicket?.id) : null,
                                );
                              }
                              isInitialized = true;
                              return ExpansionTile(
                                key: Key(supportTicket.hashCode.toString()),
                                title: buildUserCard(supportTicket),
                                tilePadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                shape: RoundedRectangleBorder(borderRadius: smallRadius, side: const BorderSide(color: kNeutralLightColor)),
                                backgroundColor: kNeutralLightOpacityColor,
                                collapsedBackgroundColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Buildables.buildProfileInfoRow('email'.tr, supportTicket.user?.email ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow(
                                    'birthdate'.tr,
                                    supportTicket.user?.birthdate != null ? Helper.formatDate(supportTicket.user!.birthdate!) : 'not_provided'.tr,
                                  ),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow('gender'.tr, supportTicket.user?.gender?.value ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  const SizedBox(height: Paddings.large),
                                  Text('support_ticket'.tr, style: AppFonts.x15Bold),
                                  const SizedBox(height: Paddings.regular),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('opened_by'.tr, style: AppFonts.x14Bold),
                                            const SizedBox(width: Paddings.regular),
                                            InkWell(
                                              onTap: () => Get.bottomSheet(
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                                  child: UserProfileScreen(user: supportTicket.user),
                                                ),
                                                isScrollControlled: true,
                                              ),
                                              child: Buildables.userImage(providedUser: supportTicket.user, size: 40),
                                            ),
                                            const SizedBox(width: Paddings.small),
                                            Text(supportTicket.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Regular),
                                          ],
                                        ),
                                        const SizedBox(height: Paddings.small),
                                        Text('${'subject'.tr}: ${supportTicket.subject}', style: AppFonts.x14Bold),
                                        const SizedBox(height: Paddings.small),
                                        Text('${'category'.tr}: ${supportTicket.category.name.tr}', style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
                                        const SizedBox(height: Paddings.regular),
                                        Text('${'description'.tr}: ${supportTicket.description}', style: AppFonts.x14Regular),
                                        const SizedBox(height: Paddings.regular),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(supportTicket.createdAt != null ? Helper.formatDateWithTime(supportTicket.createdAt!) : 'NA', style: AppFonts.x12Regular),
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
                                        onPressed: () => controller.callUser(supportTicket.user),
                                      ),
                                      const SizedBox(width: Paddings.regular),
                                      CustomButtons.icon(
                                        icon: const Icon(Icons.chat_outlined),
                                        onPressed: () => Get.toNamed(TicketDetails.routeName, arguments: supportTicket),
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

  Widget buildUserCard(SupportTicket ticket) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Buildables.userImage(providedUser: ticket.user, size: 40),
      title: Text(ticket.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Bold),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${'category'.tr}: ${ticket.category.name.tr}', style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
          const SizedBox(height: Paddings.small),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ticket.subject, style: AppFonts.x14Regular),
              Padding(
                padding: const EdgeInsets.only(right: Paddings.regular),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pin_drop_outlined, size: 14),
                    const SizedBox(width: Paddings.small),
                    Text(ticket.user?.governorate?.name ?? 'city'.tr, style: AppFonts.x14Regular),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
