import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../helpers/form_validators.dart';
import '../../models/task.dart';
import '../../services/theme/theme.dart';
import '../../widgets/categories_bottomsheet.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/governorates_bottomsheet.dart';
import '../../widgets/hold_in_safe_area.dart';
import 'add_task_controller.dart';

class AddTaskBottomsheet extends StatelessWidget {
  static const String routeName = '/add-task';
  final Task? task;

  const AddTaskBottomsheet({super.key, this.task});

  @override
  Widget build(BuildContext context) => GetBuilder<AddTaskController>(
        init: AddTaskController(),
        autoRemove: false,
        builder: (controller) {
          double attachmentSize = (Get.width - 50) / 3;
          if ((task?.attachments?.length ?? 0) > 3) attachmentSize = attachmentSize * 0.9;
          if (controller.titleController.text.isEmpty) {
            controller.titleFocusNode.requestFocus();
          }
          return HoldInSafeArea(
            child: DecoratedBox(
              decoration: const BoxDecoration(color: kNeutralColor100),
              child: Padding(
                padding: const EdgeInsets.all(Paddings.extraLarge),
                child: Form(
                  key: controller.formKey,
                  child: SizedBox(
                    height: Get.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: Paddings.exceptional),
                          Padding(
                            padding: const EdgeInsets.all(Paddings.small),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButtons.icon(
                                  icon: const Icon(Icons.close),
                                  onPressed: Get.back,
                                ),
                                Text('${task != null ? 'edit'.tr : 'new'.tr} ${'task'.tr}', style: AppFonts.x16Bold),
                                const SizedBox(width: 40),
                              ],
                            ),
                          ),
                          CustomTextField(
                            hintText: 'task_title'.tr,
                            focusNode: controller.titleFocusNode,
                            onTapOutside: (p0) => controller.titleFocusNode.unfocus(),
                            outlinedBorderColor: Colors.transparent,
                            fieldController: controller.titleController,
                            validator: FormValidators.notEmptyOrNullValidator,
                          ),
                          Buildables.lightDivider(),
                          CustomTextField(
                            hintText: 'task_description'.tr,
                            fieldController: controller.descriptionController,
                            outlinedBorderColor: Colors.transparent,
                            isTextArea: true,
                            validator: FormValidators.notEmptyOrNullValidator,
                          ),
                          Buildables.lightDivider(),
                          ListTile(
                            onTap: () => Get.bottomSheet(
                              isScrollControlled: true,
                              CategoriesBottomsheet(onSelectCategory: (category) => controller.category = category.first),
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: '${'category'.tr}: ',
                                style: AppFonts.x14Regular,
                                children: [TextSpan(text: controller.category!.name, style: AppFonts.x15Bold)],
                              ),
                            ),
                            leading: Icon(task?.category?.icon ?? controller.category?.icon, color: kNeutralColor),
                          ),
                          Buildables.lightDivider(),
                          ListTile(
                            onTap: () => Get.bottomSheet(
                              GovernorateBottomsheet(
                                selectedItem: controller.governorate,
                                onSelect: (governorate) => controller.governorate = governorate,
                              ),
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: '${'governorate'.tr}: ',
                                style: AppFonts.x14Regular,
                                children: [
                                  TextSpan(
                                    text: controller.governorate?.name ?? 'Select a governorate',
                                    style: AppFonts.x15Bold.copyWith(
                                      fontWeight: controller.governorate?.name == null ? FontWeight.normal : FontWeight.bold,
                                      color: controller.governorate?.name == null ? kNeutralColor : null,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            leading: Icon(Icons.location_on_outlined, color: kNeutralColor),
                          ),
                          Buildables.lightDivider(),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 16),
                            title: RichText(
                              text: TextSpan(
                                text: '${'due_date'.tr}: ',
                                style: AppFonts.x14Regular,
                                children: [TextSpan(text: controller.resolveDisplayDate(), style: AppFonts.x15Bold)],
                              ),
                            ),
                            leading: Icon(Icons.calendar_today_outlined, color: kNeutralColor),
                            trailing: SizedBox(
                              width: 96,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                                child: Row(
                                  children: [
                                    CustomButtons.icon(
                                      icon: Icon(Icons.chevron_left, color: kNeutralColor),
                                      onPressed: () => controller.setCreatedDate(previous: true),
                                    ),
                                    CustomButtons.icon(
                                      icon: Icon(Icons.chevron_right, color: kNeutralColor),
                                      onPressed: () => controller.setCreatedDate(next: true),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Buildables.lightDivider(),
                          CustomTextField(
                            hintText: 'task_price'.tr,
                            fieldController: controller.priceController,
                            outlinedBorderColor: Colors.transparent,
                            textInputType: const TextInputType.numberWithOptions(decimal: true),
                            validator: FormValidators.notEmptyOrNullValidator,
                          ),
                          Buildables.lightDivider(),
                          CustomTextField(
                            hintText: 'expected_delivrables'.tr,
                            fieldController: controller.delivrablesController,
                            outlinedBorderColor: Colors.transparent,
                            isTextArea: true,
                            validator: FormValidators.notEmptyOrNullValidator,
                          ),
                          Buildables.lightDivider(),
                          ListTile(
                            title: Row(
                              children: [
                                Text('${'attachments'.tr}: ', style: AppFonts.x14Regular),
                                CustomButtons.text(
                                  title: 'attach_files_pictures'.tr,
                                  titleStyle: AppFonts.x14Regular,
                                  onPressed: () => controller.uploadAttachments(),
                                ),
                              ],
                            ),
                            leading: Icon(Icons.attach_file_outlined, color: kNeutralColor),
                          ),
                          if (controller.attachments != null)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  controller.attachments?.length ?? 0,
                                  (index) {
                                    final xFile = controller.attachments![index];
                                    return Padding(
                                      padding: EdgeInsets.only(right: index < controller.attachments!.length - 1 ? Paddings.regular : 0),
                                      child: Stack(
                                        children: [
                                          DecoratedBox(
                                            decoration: BoxDecoration(borderRadius: smallRadius, border: regularBorder),
                                            child: SizedBox(
                                              width: attachmentSize,
                                              height: attachmentSize,
                                              child: Center(
                                                child: controller.isImage(xFile.name.toLowerCase())
                                                    ? ClipRRect(borderRadius: smallRadius, child: Image.file(File(xFile.path), fit: BoxFit.cover))
                                                    : Padding(
                                                        padding: const EdgeInsets.all(Paddings.small),
                                                        child: Text(
                                                          xFile.name,
                                                          textAlign: TextAlign.center,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: kNeutralOpacityColor,
                                              child: CustomButtons.icon(
                                                icon: const Icon(Icons.close, size: 14, color: kNeutralColor100),
                                                onPressed: () => controller.removeAttachments(xFile),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          const SizedBox(height: Paddings.exceptional),
                          Row(
                            children: [
                              if (task != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: Paddings.regular),
                                  child: CustomButtons.iconWithBackground(
                                    padding: const EdgeInsets.all(14),
                                    icon: const Icon(Icons.delete_forever_rounded, color: kNeutralColor100),
                                    buttonColor: kSecondaryColor,
                                    onPressed: () => controller.deleteTask(task!),
                                  ),
                                ),
                              Expanded(
                                child: Obx(
                                  () => CustomButtons.elevatePrimary(
                                    title: task != null ? 'update'.tr : 'add'.tr,
                                    buttonColor: kPrimaryColor,
                                    titleStyle: AppFonts.x16Bold,
                                    width: double.infinity,
                                    loading: controller.isAdding.value,
                                    onPressed: controller.addTask,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Paddings.large),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
