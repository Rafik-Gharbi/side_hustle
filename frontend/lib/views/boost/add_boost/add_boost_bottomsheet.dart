import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/form_validators.dart';
import '../../../helpers/helper.dart';
import '../../../models/boost.dart';
import '../../../models/governorate.dart';
import '../../../models/user.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import 'add_boost_controller.dart';

class AddBoostBottomsheet extends StatelessWidget {
  final Boost? boost;
  final String? taskId;
  final String? serviceId;

  const AddBoostBottomsheet({super.key, this.boost, this.taskId, this.serviceId});

  @override
  Widget build(BuildContext context) {
    final isUpdate = boost != null;
    return SizedBox(
      height: 640,
      child: GetBuilder<AddBoostController>(
        init: AddBoostController(boost: boost, taskId: taskId, serviceId: serviceId),
        builder: (controller) => Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: kNeutralColor100,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: () => Helper.goBack()),
                    Text('add_boost'.tr, style: AppFonts.x15Bold),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Paddings.large),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                          child: Text('budget'.tr, style: AppFonts.x15Bold),
                        ),
                        Obx(
                          () => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      min: 1,
                                      max: 100,
                                      divisions: 99,
                                      activeColor: kPrimaryColor,
                                      value: controller.budgetRange.value,
                                      onChanged: (double value) => controller.budgetRange.value = value,
                                    ),
                                  ),
                                  CustomTextField(
                                    width: 100,
                                    textFontSize: 14,
                                    isOptional: false,
                                    fieldController: TextEditingController(text: '${controller.budgetRange.value.toStringAsFixed(0)} ${MainAppController.find.currency.value}'),
                                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                                    onChanged: (value) => Helper.onSearchDebounce(
                                      () => controller.budgetRange.value = double.parse(value.contains(' ') ? value.substring(0, value.indexOf(' ')) : value),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Paddings.small),
                              Row(
                                children: [
                                  const Icon(Icons.rocket_outlined, size: 16),
                                  const SizedBox(width: Paddings.regular),
                                  Text(
                                    'estimated_reach_min_max'
                                        .trParams({'min': controller.getEstimationReachMin().toString(), 'max': controller.getEstimationReachMax().toString()}),
                                    style: AppFonts.x12Regular,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Paddings.regular),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.small),
                          child: Text('target_audience'.tr, style: AppFonts.x15Bold),
                        ),
                        CustomDropDownMenu<Governorate>(
                          items: MainAppController.find.governorates,
                          hint: 'select_governorate'.tr,
                          maxWidth: true,
                          selectedItem: controller.governorate ?? MainAppController.find.governorates.first,
                          buttonHeight: 45,
                          valueFrom: (governorate) => governorate.name,
                          onChanged: (value) => controller.governorate = value,
                          validator: (_) => FormValidators.notEmptyOrNullValidator(controller.governorate?.name),
                        ),
                        const SizedBox(height: Paddings.regular),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.small),
                          child: Text('audience_age'.tr, style: AppFonts.x15Bold),
                        ),
                        Theme(
                          data: ThemeData(sliderTheme: const SliderThemeData(valueIndicatorColor: kNeutralColor)),
                          child: RangeSlider(
                            min: 18,
                            max: 65,
                            divisions: 47,
                            labels: RangeLabels(
                              controller.minAge?.toString() ?? '18',
                              controller.maxAge == 65 || controller.maxAge == null ? '65+' : controller.maxAge!.toString(),
                            ),
                            overlayColor: WidgetStatePropertyAll(kPrimaryOpacityColor),
                            activeColor: kPrimaryColor,
                            onChanged: (value) => controller.manageAgeAudience(range: value),
                            values: RangeValues(
                              controller.minAge?.toDouble() ?? 18,
                              controller.maxAge?.toDouble() ?? 65,
                            ),
                          ),
                        ),
                        const SizedBox(height: Paddings.small),
                        Text(
                          '${'age'.tr}: ${controller.minAge ?? 18} - ${controller.maxAge == 65 || controller.maxAge == null ? '65+' : controller.maxAge}'.tr,
                          style: AppFonts.x12Regular,
                        ),
                        const SizedBox(height: Paddings.regular),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.small),
                          child: Text('audience_gender'.tr, style: AppFonts.x15Bold),
                        ),
                        CustomDropDownMenu<String>(
                          items: ['all_genders'.tr, ...Gender.values.map((e) => e.value.tr)],
                          hint: 'select_gender'.tr,
                          maxWidth: true,
                          selectedItem: controller.gender?.value ?? 'all_genders'.tr,
                          buttonHeight: 45,
                          onChanged: (value) => value == 'all_genders'.tr ? controller.gender = null : controller.gender = Gender.fromString(value!),
                        ),
                        const SizedBox(height: Paddings.regular),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Text('${'end_date'.tr}: ', style: AppFonts.x15Bold)),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () => Helper.openDatePicker(currentTime: controller.endDate, onConfirm: (date) => controller.endDate = date, isFutureDate: true),
                                    child: Text(
                                      Helper.resolveDisplayDate(controller.endDate),
                                      style: AppFonts.x14Regular.copyWith(decoration: TextDecoration.underline, decorationThickness: 0.6),
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
                                    onPressed: () => controller.endDate = controller.endDate.subtract(const Duration(days: 1)),
                                  ),
                                  CustomButtons.icon(
                                    icon: const Icon(Icons.chevron_right, color: kNeutralColor),
                                    onPressed: () => controller.endDate = controller.endDate.add(const Duration(days: 1)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Paddings.exceptional),
                        CustomButtons.elevatePrimary(
                          title: '${isUpdate ? 'update'.tr : 'create'.tr} ${'boost'.tr}',
                          width: Get.width,
                          onPressed: controller.upsertBoost,
                        ),
                        const SizedBox(height: Paddings.exceptional),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
