import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../models/category.dart';
import '../../../../services/theme/theme.dart';
import '../../../../viewmodel/store_viewmodel.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_field.dart';
import '../my_store_controller.dart';

class AddServiceBottomsheet extends StatelessWidget {
  final bool isUpdate;
  const AddServiceBottomsheet({super.key, this.isUpdate = false});

  @override
  Widget build(BuildContext context) => GetBuilder<MyStoreController>(builder: (controller) {
        double attachmentSize = (Get.width - 50) / 3;
        if ((StoreViewmodel.serviceGallery.length) > 2) attachmentSize = attachmentSize * 0.9;
        return Padding(
          padding: const EdgeInsets.only(top: Paddings.exceptional * 2),
          child: SizedBox(
            height: 680,
            child: Material(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              color: kNeutralColor100,
              child: Form(
                key: StoreViewmodel.formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Paddings.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text('add_service'.tr, style: AppFonts.x16Bold)),
                        const SizedBox(height: Paddings.extraLarge),
                        CustomTextField(
                          outlinedBorder: true,
                          isOptional: false,
                          hintText: 'service_name'.tr,
                          fieldController: StoreViewmodel.serviceNameController,
                          validator: FormValidators.notEmptyOrNullValidator,
                        ),
                        const SizedBox(height: Paddings.regular),
                        CustomTextField(
                          isOptional: false,
                          outlinedBorder: true,
                          hintText: 'service_description'.tr,
                          fieldController: StoreViewmodel.serviceDescriptionController,
                          isTextArea: true,
                          validator: FormValidators.notEmptyOrNullValidator,
                        ),
                        const SizedBox(height: Paddings.regular),
                        CustomTextField(
                          outlinedBorder: true,
                          hintText: 'whats_included'.tr,
                          fieldController: StoreViewmodel.serviceIncludedController,
                          isTextArea: true,
                        ),
                        const SizedBox(height: Paddings.regular),
                        CustomTextField(
                          outlinedBorder: true,
                          hintText: 'whats_not_included'.tr,
                          fieldController: StoreViewmodel.serviceNotIncludedController,
                          isTextArea: true,
                        ),
                        const SizedBox(height: Paddings.regular),
                        CustomTextField(
                          outlinedBorder: true,
                          hintText: 'note'.tr,
                          fieldController: StoreViewmodel.serviceNoteController,
                          isTextArea: true,
                        ),
                        const SizedBox(height: Paddings.regular),
                        Obx(
                          () => CustomDropDownMenu<Category>(
                            items: MainAppController.find.categories,
                            hint: 'select_category'.tr,
                            dropDownWithDecoration: true,
                            maxWidth: true,
                            isRequired: true,
                            selectedItem: StoreViewmodel.category.value.empty ? null : StoreViewmodel.category.value,
                            buttonHeight: 45,
                            valueFrom: (category) => category.name,
                            onChanged: (value) => StoreViewmodel.category.value = value ?? Category.empty(),
                            validator: (_) => FormValidators.notEmptyOrNullValidator(StoreViewmodel.category.value.name),
                          ),
                        ),
                        const SizedBox(height: Paddings.regular),
                        CustomTextField(
                          outlinedBorder: true,
                          hintText: 'service_price'.tr,
                          isOptional: false,
                          fieldController: StoreViewmodel.servicePriceController,
                          textInputType: const TextInputType.numberWithOptions(decimal: true),
                          validator: FormValidators.notEmptyOrNullValidator,
                        ),
                        const SizedBox(height: Paddings.regular),
                        Row(
                          children: [
                            CustomTextField(
                              outlinedBorder: true,
                              width: (Get.width - 70) / 2,
                              hintText: 'time_estimation_from'.tr,
                              fieldController: StoreViewmodel.serviceTimeFromController,
                              textInputType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                            const SizedBox(width: Paddings.regular),
                            CustomTextField(
                              outlinedBorder: true,
                              width: (Get.width - 70) / 2,
                              hintText: 'time_estimation_to'.tr,
                              fieldController: StoreViewmodel.serviceTimeToController,
                              textInputType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: Paddings.extraLarge),
                        Text('service_gallery'.tr, style: AppFonts.x14Bold),
                        const SizedBox(height: Paddings.regular),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: Paddings.regular),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: kNeutralLightColor, borderRadius: smallRadius, border: regularBorder),
                                  child: SizedBox(
                                    width: attachmentSize,
                                    height: attachmentSize,
                                    child: ClipRRect(
                                      borderRadius: smallRadius,
                                      child: CustomButtons.icon(
                                        icon: const Icon(Icons.add_a_photo_outlined),
                                        onPressed: controller.addServicePictures,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ...List.generate(
                                StoreViewmodel.serviceGallery.length,
                                (index) {
                                  final picture = StoreViewmodel.serviceGallery[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: index < StoreViewmodel.serviceGallery.length - 1 ? Paddings.regular : 0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(borderRadius: smallRadius, border: regularBorder),
                                      child: SizedBox(
                                        width: attachmentSize,
                                        height: attachmentSize,
                                        child: ClipRRect(
                                          borderRadius: smallRadius,
                                          child: isUpdate
                                              ? Image.network(picture.path, height: attachmentSize, width: attachmentSize, fit: BoxFit.cover)
                                              : Image.file(File(picture.path), height: attachmentSize, width: attachmentSize, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Paddings.exceptional * 2),
                        CustomButtons.elevatePrimary(
                          title: '${isUpdate ? 'update'.tr : 'create'.tr} ${'service'.tr}',
                          loading: StoreViewmodel.isLoading,
                          width: Get.width,
                          onPressed: () => controller.upsertService(isUpdate: isUpdate),
                        ),
                        const SizedBox(height: Paddings.exceptional),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
