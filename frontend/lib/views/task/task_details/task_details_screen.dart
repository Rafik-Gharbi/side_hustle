import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/task.dart';
import '../../../models/user.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_button_with_overlay.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/report_user_dialog.dart';
import '../../boost/add_boost/add_boost_bottomsheet.dart';
import '../../chat/components/messages_screen.dart';
import '../add_task/add_task_bottomsheet.dart';
import '../task_proposal/task_proposal_screen.dart';
import '../../profile/user_profile/user_profile_screen.dart';
import 'task_details_controller.dart';

class TaskDetailsScreen extends StatelessWidget {
  static const String routeName = '/task-details';
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    double attachmentSize = (Get.width - 50) / 3;
    final isOwner = AuthenticationService.find.jwtUserData?.id == task.owner.id;
    if ((task.attachments?.length ?? 0) > 3) attachmentSize = attachmentSize * 0.9;
    return GetBuilder<TaskDetailsController>(
        init: TaskDetailsController(task),
        tag: 'task-details-${task.id}',
        autoRemove: false,
        builder: (controller) => HoldInSafeArea(
              child: CustomScaffoldBottomNavigation(
                noAppBar: true,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Paddings.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: () => Helper.goBack()),
                            CustomButtonWithOverlay(
                              offset: const Offset(-170, 30),
                              buttonWidth: 50,
                              button: const Icon(Icons.more_vert_outlined),
                              menu: DecoratedBox(
                                decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralColor100),
                                child: SizedBox(
                                  width: 200,
                                  height: isOwner ? 180 : 120,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                        title: Text('bookmark'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                        leading: Icon(task.isFavorite ? Icons.bookmark_outlined : Icons.bookmark_add_outlined),
                                        onTap: () async {
                                          Helper.goBack();
                                          await MainAppController.find.toggleFavoriteTask(task);
                                          controller.update();
                                        },
                                      ),
                                      if (isOwner)
                                        ListTile(
                                          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                          title: Text('boost'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                          leading: const Icon(Icons.rocket_launch_outlined),
                                          onTap: () {
                                            Helper.goBack();
                                            Get.bottomSheet(AddBoostBottomsheet(taskId: task.id), isScrollControlled: true);
                                          },
                                        ),
                                      if (task.owner.id != AuthenticationService.find.jwtUserData?.id)
                                        ListTile(
                                          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                          title: Text('report'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                          leading: const Icon(Icons.report_outlined),
                                          onTap: () async {
                                            Helper.goBack();
                                            Get.bottomSheet(ReportUserDialog(user: task.owner, task: task), isScrollControlled: true);
                                          },
                                        )
                                      else
                                        ListTile(
                                          shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                          title: Text('edit'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                          leading: const Icon(Icons.edit_outlined),
                                          onTap: () async {
                                            Helper.goBack();
                                            Get.bottomSheet(AddTaskBottomsheet(task: task), isScrollControlled: true).then((value) => controller.getTaskUpdate());
                                          },
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Paddings.large),
                        Text(task.title, style: AppFonts.x16Bold),
                        Row(
                          children: [
                            Icon(task.category?.icon, size: 14),
                            const SizedBox(width: Paddings.regular),
                            Text(task.category?.name ?? '', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                              child: Text('•', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                            ),
                            const Icon(Icons.location_on_outlined, size: 14),
                            const SizedBox(width: Paddings.regular),
                            Text(task.governorate?.name ?? '', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                          ],
                        ),
                        const SizedBox(height: Paddings.exceptional),
                        Text('description'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                        const SizedBox(height: Paddings.regular),
                        Text(task.description, style: AppFonts.x14Regular),
                        const SizedBox(height: Paddings.exceptional),
                        if (task.delivrables != null) ...[
                          Text('delivrables'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                          const SizedBox(height: Paddings.regular),
                          Text(task.delivrables ?? '', style: AppFonts.x14Regular),
                          const SizedBox(height: Paddings.exceptional),
                        ],
                        if (task.attachments != null && task.attachments!.isNotEmpty) ...[
                          Text('attachments'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                          const SizedBox(height: Paddings.regular),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                task.attachments?.length ?? 0,
                                (index) {
                                  final attachment = task.attachments![index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: index < task.attachments!.length - 1 ? Paddings.regular : 0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(borderRadius: smallRadius, border: regularBorder),
                                      child: SizedBox(
                                        width: attachmentSize,
                                        height: attachmentSize,
                                        child: attachment.type == ImageType.file
                                            ? Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(Paddings.small),
                                                  child: Text(attachment.file.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 3),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius: smallRadius,
                                                child: CachedNetworkImage(
                                                  imageUrl: attachment.file.path,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => Lottie.asset(Assets.pictureLoading, fit: BoxFit.cover),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  errorListener: (error) => LoggerService.logger?.e(error),
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: Paddings.exceptional),
                        ],
                        Row(
                          children: [
                            const Icon(Icons.monetization_on_outlined),
                            const SizedBox(width: Paddings.regular),
                            Text('${'price'.tr}:', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                            const SizedBox(width: Paddings.regular),
                            Text('${Helper.formatAmount(task.price ?? 0)} ${MainAppController.find.currency.value}', style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                          ],
                        ),
                        const SizedBox(height: Paddings.regular),
                        Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: Paddings.regular),
                            Text('${'owner'.tr}:', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                            CustomButtons.text(
                              title: task.owner.name ?? 'user'.tr,
                              titleStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor),
                              onPressed: () => Get.bottomSheet(
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                  child: UserProfileScreen(user: task.owner),
                                ),
                                isScrollControlled: true,
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => controller.condidates.value != -1 || isOwner
                              ? Column(
                                  children: [
                                    const SizedBox(height: Paddings.exceptional * 2),
                                    if (AuthenticationService.find.jwtUserData?.id == task.owner.id && controller.condidates.value == -1)
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomButtons.elevateSecondary(
                                            title: '${'chat_with'.tr} ${controller.confirmedTaskUser.value?.name ?? 'user'.tr}',
                                            titleStyle: AppFonts.x14Regular,
                                            icon: const Icon(Icons.chat_outlined),
                                            width: Get.width - 40,
                                            onPressed: () => Get.toNamed(MessagesScreen.routeName, arguments: controller.confirmedTaskUser.value),
                                          ),
                                          const SizedBox(height: Paddings.regular),
                                          CustomButtons.elevatePrimary(
                                            title: 'mark_task_done'.tr,
                                            titleStyle: AppFonts.x14Regular,
                                            icon: const Icon(Icons.done, color: kNeutralColor100),
                                            width: Get.width - 40,
                                            onPressed: controller.markDoneProposals,
                                          ),
                                        ],
                                      )
                                    else if (AuthenticationService.find.jwtUserData?.id == task.owner.id)
                                      CustomButtons.elevatePrimary(
                                        title: 'check_proposal'.tr,
                                        onPressed: () => Get.toNamed(TaskProposalScreen.routeName, arguments: task),
                                        width: Get.width,
                                      )
                                    else
                                      CustomButtons.elevatePrimary(
                                        title: 'Im_interested'.tr,
                                        onPressed: () => AuthenticationService.find.isUserLoggedIn.value
                                            ? AuthenticationService.find.jwtUserData?.isVerified == VerifyIdentityStatus.verified
                                                ? Buildables.requestBottomsheet(
                                                    noteController: controller.noteController,
                                                    proposedPriceController: controller.proposedPriceController,
                                                    deliveryDateController: controller.deliveryDateController,
                                                    onSubmit: () => controller.submitProposal(task),
                                                    isTask: true,
                                                    neededCoins: task.coins,
                                                  ).then((value) => controller.clearFormFields())
                                                : Helper.snackBar(message: 'verify_profile_msg'.tr)
                                            : Helper.snackBar(message: 'login_express_interest_msg'.tr),
                                        width: Get.width,
                                      ),
                                    const SizedBox(height: Paddings.small),
                                    if (controller.condidates.value != -1)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('${controller.condidates.value} ${'expressed_interest'.tr}', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                      ),
                                  ],
                                )
                              : controller.isUserConfirmedTaskSeeker.value
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: Paddings.exceptional * 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.chat_outlined),
                                          CustomButtons.text(
                                            title: '${'chat_with'.tr} ${task.owner.name ?? 'user'.tr}',
                                            titleStyle: AppFonts.x14Regular,
                                            onPressed: () => Get.toNamed(MessagesScreen.routeName, arguments: task.owner),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                        ),
                        const SizedBox(height: Paddings.exceptional),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
