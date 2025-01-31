import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/form_validators.dart';
import '../../../helpers/helper.dart';
import '../../../models/task.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../services/tutorials/add_task_tutorial.dart';
import '../../../widgets/categories_bottomsheet.dart';
import '../../../widgets/coordinates_picker.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/draggable_bottomsheet.dart';
import '../../../widgets/governorates_bottomsheet.dart';
import 'add_task_controller.dart';

class AddTaskBottomsheet extends StatelessWidget {
  static const String routeName = '/add-task';
  final Task? task;

  const AddTaskBottomsheet({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final hasFinishedAddTaskTutorial = SharedPreferencesService.find.get(hasFinishedAddTaskTutorialKey) == 'true';
    RxBool hasOpenedTutorial = false.obs;
    return GetBuilder<AddTaskController>(
      init: AddTaskController(task: task),
      initState: (state) {
        Helper.waitAndExecute(() => state.controller != null, () {
          if (!hasFinishedAddTaskTutorial && !hasOpenedTutorial.value && state.controller!.targets.isNotEmpty) {
            hasOpenedTutorial.value = true;
            TutorialCoachMark(
              targets: state.controller!.targets,
              colorShadow: kNeutralOpacityColor,
              onClickTarget: (target) => target.keyTarget == state.controller!.priceKey
                  ? state.controller!.scrollController.animateTo(state.controller!.scrollController.position.maxScrollExtent, duration: Durations.long2, curve: Curves.bounceIn)
                  : null,
              textSkip: 'skip'.tr,
              additionalWidget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                child: Obx(
                  () => CheckboxListTile(
                    dense: true,
                    checkColor: kNeutralColor100,
                    contentPadding: EdgeInsets.zero,
                    side: const BorderSide(color: kNeutralColor100),
                    title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                    value: AddTaskTutorial.notShowAgain.value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) => AddTaskTutorial.notShowAgain.value = value ?? false,
                  ),
                ),
              ),
              onSkip: () {
                if (AddTaskTutorial.notShowAgain.value) {
                  SharedPreferencesService.find.add(hasFinishedMarketTutorialKey, 'true');
                }
                hasOpenedTutorial.value = false;
                return true;
              },
              onFinish: () => SharedPreferencesService.find.add(hasFinishedAddTaskTutorialKey, 'true'),
            ).show(context: context);
          }
        });
      },
      autoRemove: false,
      builder: (controller) {
        double attachmentSize = (Get.width - 50) / 3;
        if ((task?.attachments?.length ?? 0) > 3) attachmentSize = attachmentSize * 0.9;
        if (controller.titleController.text.isEmpty) {
          controller.titleFocusNode.requestFocus();
        }
        return Obx(
          () => PopScope(
            canPop: !hasOpenedTutorial.value,
            child: Material(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: kNeutralColor100),
                child: Padding(
                  padding: const EdgeInsets.all(Paddings.extraLarge),
                  child: Form(
                    key: controller.formKey,
                    child: SizedBox(
                      height: Get.height,
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: Paddings.exceptional),
                            Padding(
                              padding: const EdgeInsets.all(Paddings.small),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButtons.icon(icon: const Icon(Icons.close), onPressed: () => Helper.goBack()),
                                  Text(task != null ? '${'edit'.tr} ${'task'.tr}' : 'new_task'.tr, style: AppFonts.x16Bold),
                                  const SizedBox(width: 40),
                                ],
                              ),
                            ),
                            Column(
                              key: controller.titleFieldKey,
                              children: [
                                CustomTextField(
                                  hintText: 'task_title'.tr,
                                  isOptional: false,
                                  focusNode: controller.titleFocusNode,
                                  onTapOutside: (p0) => controller.titleFocusNode.unfocus(),
                                  outlinedBorderColor: Colors.transparent,
                                  fieldController: controller.titleController,
                                  validator: FormValidators.notEmptyOrNullValidator,
                                ),
                                Buildables.lightDivider(),
                                CustomTextField(
                                  hintText: 'task_description'.tr,
                                  isOptional: false,
                                  fieldController: controller.descriptionController,
                                  outlinedBorderColor: Colors.transparent,
                                  isTextArea: true,
                                  validator: FormValidators.notEmptyOrNullValidator,
                                ),
                              ],
                            ),
                            Buildables.lightDivider(),
                            ListTile(
                              key: controller.categoryKey,
                              onTap: () => Get.bottomSheet(
                                DraggableBottomsheet(child: CategoriesBottomsheet(onSelectCategory: (category) => controller.category = category.first, isAdding: true)),
                                isScrollControlled: true,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  text: '${'category'.tr}: ',
                                  style: AppFonts.x14Regular,
                                  children: [TextSpan(text: controller.category!.name, style: AppFonts.x15Bold)],
                                ),
                              ),
                              leading: Buildables.buildCategoryIcon(task?.category?.icon ?? controller.category!.icon),
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
                                      text: controller.governorate?.name ?? 'select_governorate'.tr,
                                      style: AppFonts.x15Bold.copyWith(
                                        fontWeight: controller.governorate?.name == null ? FontWeight.normal : FontWeight.bold,
                                        color: controller.governorate?.name == null ? kNeutralColor : null,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              leading: const Icon(Icons.location_on_outlined, color: kNeutralColor),
                            ),
                            Buildables.lightDivider(),
                            ListTile(
                              key: controller.dueDateKey,
                              contentPadding: const EdgeInsets.only(left: 16),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Text('${'due_date'.tr}: ', style: AppFonts.x14Regular)),
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () =>
                                            Helper.openDatePicker(currentTime: controller.createdDate, onConfirm: (date) => controller.createdDate = date, isFutureDate: true),
                                        child: Text(
                                          Helper.resolveDisplayDate(controller.createdDate),
                                          style: AppFonts.x15Bold.copyWith(decoration: TextDecoration.underline, decorationThickness: 0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              leading: const Icon(Icons.calendar_today_outlined, color: kNeutralColor),
                              trailing: SizedBox(
                                width: 96,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                                  child: Row(
                                    children: [
                                      CustomButtons.icon(
                                        icon: const Icon(Icons.chevron_left, color: kNeutralColor),
                                        onPressed: () => controller.setCreatedDate(previous: true),
                                      ),
                                      CustomButtons.icon(
                                        icon: const Icon(Icons.chevron_right, color: kNeutralColor),
                                        onPressed: () => controller.setCreatedDate(next: true),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Buildables.lightDivider(),
                            if (controller.isPriceRange)
                              Row(
                                key: controller.priceKey,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    width: (Get.width - 50) * 0.4,
                                    hintText: 'task_price_min'.tr,
                                    fieldController: controller.priceController,
                                    outlinedBorderColor: Colors.transparent,
                                    validator: FormValidators.notEmptyOrNullFloatValidator,
                                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                                  ),
                                  Buildables.verticalDivider(color: kNeutralColor, padding: const EdgeInsets.symmetric(horizontal: Paddings.small), thickness: 0.4),
                                  CustomTextField(
                                    width: ((Get.width - 50) * 0.6) - 1,
                                    hintText: 'task_price_max'.tr,
                                    fieldController: controller.priceMaxController,
                                    outlinedBorderColor: Colors.transparent,
                                    validator: FormValidators.notEmptyOrNullFloatValidator,
                                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                                    suffixIcon: InkWell(
                                      onTap: () => controller.isPriceRange = !controller.isPriceRange,
                                      child: const Icon(Icons.compare_arrows_outlined),
                                    ),
                                  ),
                                ],
                              )
                            else
                              CustomTextField(
                                key: controller.priceKey,
                                hintText: 'task_price'.tr,
                                isOptional: false,
                                fieldController: controller.priceController,
                                outlinedBorderColor: Colors.transparent,
                                validator: FormValidators.notEmptyOrNullFloatValidator,
                                textInputType: const TextInputType.numberWithOptions(decimal: true),
                                suffixIcon:
                                    CustomButtons.icon(icon: const Icon(Icons.compare_arrows_outlined), onPressed: () => controller.isPriceRange = !controller.isPriceRange),
                              ),
                            Buildables.lightDivider(),
                            CustomTextField(
                              hintText: 'expected_delivrables'.tr,
                              fieldController: controller.delivrablesController,
                              outlinedBorderColor: Colors.transparent,
                              isTextArea: true,
                              isOptional: false,
                              validator: FormValidators.notEmptyOrNullValidator,
                            ),
                            Buildables.lightDivider(),
                            SizedBox(
                              key: controller.locationKey,
                              child: CoordinatesPicker(
                                onSubmit: (coordinates) => controller.coordinates = coordinates,
                                currentPosition: controller.coordinates,
                                isRequired: false,
                              ),
                            ),
                            Buildables.lightDivider(),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 16),
                              title: Row(
                                children: [
                                  Text('${'attachments'.tr}: ', style: AppFonts.x14Regular),
                                  CustomButtons.text(
                                    title: 'attach_files_pictures'.tr,
                                    titleStyle: AppFonts.x12Regular,
                                    onPressed: () => controller.uploadAttachments(),
                                  ),
                                ],
                              ),
                              leading: const Icon(Icons.attach_file_outlined, color: kNeutralColor),
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
                                                  child: Helper.isImage(xFile.name.toLowerCase())
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
                                      buttonColor: kErrorColor,
                                      onPressed: () => controller.deleteTask(task!),
                                    ),
                                  ),
                                Expanded(
                                  child: CustomButtons.elevatePrimary(
                                    title: task != null ? 'update'.tr : 'add'.tr,
                                    buttonColor: kPrimaryColor,
                                    titleStyle: AppFonts.x16Bold,
                                    width: double.infinity,
                                    loading: controller.isAdding,
                                    onPressed: controller.upsertTask,
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
            ),
          ),
        );
      },
    );
  }
}
