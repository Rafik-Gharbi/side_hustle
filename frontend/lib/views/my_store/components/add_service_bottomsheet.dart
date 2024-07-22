import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/form_validators.dart';
import '../../../models/category.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../my_store_controller.dart';

class AddServiceBottomsheet extends StatelessWidget {
  final bool isUpdate;
  const AddServiceBottomsheet({super.key, this.isUpdate = false});

  @override
  Widget build(BuildContext context) => GetBuilder<MyStoreController>(builder: (controller) {
        double attachmentSize = (Get.width - 50) / 3;
        if ((controller.serviceGallery.length) > 3) attachmentSize = attachmentSize * 0.9;
        return Padding(
          padding: const EdgeInsets.only(top: Paddings.exceptional * 2),
          child: SizedBox(
            height: 680,
            child: Material(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              color: kNeutralColor100,
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(Paddings.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: Text('Add service', style: AppFonts.x16Bold)),
                      const SizedBox(height: Paddings.extraLarge),
                      CustomTextField(
                        hintText: 'service_name'.tr,
                        fieldController: controller.serviceNameController,
                        validator: FormValidators.notEmptyOrNullValidator,
                      ),
                      const SizedBox(height: Paddings.regular),
                      CustomTextField(
                        hintText: 'service_description'.tr,
                        fieldController: controller.serviceDescriptionController,
                        isTextArea: true,
                        validator: FormValidators.notEmptyOrNullValidator,
                      ),
                      const SizedBox(height: Paddings.regular),
                      CustomDropDownMenu<Category>(
                        items: MainAppController.find.categories,
                        hint: 'Select a category',
                        maxWidth: true,
                        selectedItem: controller.category,
                        buttonHeight: 45,
                        valueFrom: (category) => category.name,
                        onChanged: (value) => controller.category = value,
                        validator: (_) => FormValidators.notEmptyOrNullValidator(controller.category?.name),
                      ),
                      const SizedBox(height: Paddings.regular),
                      CustomTextField(
                        hintText: 'service_price'.tr,
                        fieldController: controller.servicePriceController,
                        textInputType: const TextInputType.numberWithOptions(decimal: true),
                        validator: FormValidators.notEmptyOrNullValidator,
                      ),
                      const SizedBox(height: Paddings.large),
                      const Text('Service gallery', style: AppFonts.x14Bold),
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
                              controller.serviceGallery.length,
                              (index) {
                                final picture = controller.serviceGallery[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: index < controller.serviceGallery.length - 1 ? Paddings.regular : 0),
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
                        title: '${isUpdate ? 'Update' : 'Create'} service',
                        width: Get.width,
                        onPressed: () => controller.upsertService(isUpdate: isUpdate),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
