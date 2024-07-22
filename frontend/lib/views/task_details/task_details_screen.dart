import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/helper.dart';
import '../../models/dto/image_dto.dart';
import '../../models/task.dart';
import '../../services/authentication_service.dart';
import '../../services/logger_service.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../user_profile/user_profile_screen.dart';
import 'task_details_controller.dart';

class TaskDetailsScreen extends StatelessWidget {
  static const String routeName = '/task-details';
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    double attachmentSize = (Get.width - 50) / 3;
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
                            CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: Get.back),
                            CustomButtons.icon(icon: Icon(task.isFavorite ? Icons.bookmark_outlined : Icons.bookmark_add_outlined), onPressed: () {}),
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
                              title: task.owner.name ?? 'User',
                              titleStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor),
                              onPressed: () => Get.bottomSheet(
                                Padding(
                                  padding: EdgeInsets.only(top: Get.height * 0.4),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                    child: UserProfileScreen(user: task.owner),
                                  ),
                                ),
                                isScrollControlled: true,
                              ),
                            ),
                          ],
                        ),
                        if (controller.condidates.value != -1) ...[
                          const SizedBox(height: Paddings.exceptional * 2),
                          CustomButtons.elevatePrimary(
                            title: 'Im_interested'.tr,
                            onPressed: () => AuthenticationService.find.isUserLoggedIn.value
                                ? Get.bottomSheet(
                                    SizedBox(
                                      height: Get.height * 0.4,
                                      child: Material(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(Paddings.large),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: Paddings.regular),
                                              const Center(child: Text('Add proposal', style: AppFonts.x16Bold)),
                                              const SizedBox(height: Paddings.exceptional),
                                              CustomTextField(
                                                fieldController: controller.noteController,
                                                isTextArea: true,
                                                outlinedBorder: true,
                                                outlinedBorderColor: kNeutralColor,
                                                hintText: 'Add a note for the task owner',
                                              ),
                                              const SizedBox(height: Paddings.exceptional),
                                              CustomButtons.elevatePrimary(
                                                title: 'Submit proposal',
                                                width: Get.width,
                                                onPressed: () => controller.submitProposal(task),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                  ).then((value) => controller.clearFormFields())
                                : Helper.snackBar(message: 'login_express_interest_msg'.tr),
                            width: Get.width,
                          ),
                          const SizedBox(height: Paddings.small),
                          Obx(
                            () => Align(
                                alignment: Alignment.centerRight,
                                child: Text('${controller.condidates.value} ${'expressed_interest'.tr}', style: AppFonts.x12Regular.copyWith(color: kNeutralColor))),
                          ),
                        ],
                        const SizedBox(height: Paddings.exceptional),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
