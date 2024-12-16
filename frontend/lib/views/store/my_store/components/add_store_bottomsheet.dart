import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/form_validators.dart';
import '../../../../models/governorate.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/coordinates_picker.dart';
import '../../../../widgets/custom_buttons.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_field.dart';
import '../my_store_controller.dart';

class AddStoreBottomsheet extends StatelessWidget {
  final bool isUpdate;
  const AddStoreBottomsheet({super.key, this.isUpdate = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyStoreController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.only(top: Paddings.exceptional * 2),
        child: SizedBox(
          height: 680,
          child: Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            color: kNeutralColor100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (controller.storePicture != null)
                    Padding(
                      padding: const EdgeInsets.all(0.6),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        child: isUpdate
                            ? Image.network(controller.currentStore!.picture!.file.path, height: 199, width: Get.width - 1, fit: BoxFit.cover)
                            : Image.file(File(controller.storePicture!.path), height: 198, width: Get.width - 1, fit: BoxFit.cover),
                      ),
                    )
                  else
                    InkWell(
                      onTap: controller.addStorePicture,
                      child: SizedBox(
                        width: Get.width,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined, size: 24, color: kNeutralColor),
                            const SizedBox(height: Paddings.small),
                            Text('add_store_cover'.tr, style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
                          ],
                        ),
                      ),
                    ),
                  Form(
                    key: controller.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(Paddings.large),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'store_name'.tr,
                            fieldController: controller.nameController,
                            validator: FormValidators.notEmptyOrNullValidator,
                          ),
                          const SizedBox(height: Paddings.regular),
                          CustomTextField(
                            hintText: 'store_description'.tr,
                            fieldController: controller.descriptionController,
                            isTextArea: true,
                            validator: FormValidators.notEmptyOrNullValidator,
                          ),
                          const SizedBox(height: Paddings.regular),
                          CustomDropDownMenu<Governorate>(
                            items: MainAppController.find.governorates,
                            hint: 'select_governorate'.tr,
                            maxWidth: true,
                            selectedItem: controller.governorate,
                            buttonHeight: 45,
                            valueFrom: (governorate) => governorate.name,
                            onChanged: (value) => controller.governorate = value,
                            validator: (_) => FormValidators.notEmptyOrNullValidator(controller.governorate?.name),
                          ),
                          const SizedBox(height: Paddings.regular),
                          CoordinatesPicker(
                            onSubmit: (coordinates) => controller.coordinates = coordinates,
                            currentPosition: controller.coordinates,
                          ),
                          const SizedBox(height: Paddings.exceptional * 2),
                          CustomButtons.elevatePrimary(
                            title: '${isUpdate ? 'update'.tr : 'create'.tr} ${'store'.tr}',
                            width: Get.width,
                            onPressed: controller.upsertStore,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
