import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/helper.dart';
import '../helpers/image_picker_by_platform/image_picker_platform.dart';
import '../models/category.dart';
import '../models/dto/image_dto.dart';
import '../models/service.dart';
import '../models/store.dart';
import '../repositories/store_repository.dart';
import '../services/logger_service.dart';
import '../views/store/my_store/components/add_service_bottomsheet.dart';

class StoreViewmodel {
  static final GlobalKey<FormState> formKey = GlobalKey();
  static final TextEditingController servicePriceController = TextEditingController();
  static final TextEditingController serviceDescriptionController = TextEditingController();
  static final TextEditingController serviceNameController = TextEditingController();
  static final TextEditingController serviceIncludedController = TextEditingController();
  static final TextEditingController serviceNotIncludedController = TextEditingController();
  static final TextEditingController serviceNoteController = TextEditingController();
  static final TextEditingController serviceTimeFromController = TextEditingController();
  static final TextEditingController serviceTimeToController = TextEditingController();
  static List<XFile> serviceGallery = [];
  static Rx<Category> category = Category.empty().obs;
  static String? updateServiceId;
  static Store? currentStore;
  static RxBool isLoading = false.obs;

  static Future<void> upsertService({bool isUpdate = false, void Function()? onFinish}) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      Service? result;
      final service = Service(
        id: updateServiceId,
        name: serviceNameController.text,
        description: serviceDescriptionController.text,
        category: category.value,
        gallery: serviceGallery.map((e) => ImageDTO(file: e, type: ImageType.image)).toList(),
        price: double.tryParse(servicePriceController.text),
        included: serviceIncludedController.text,
        notIncluded: serviceNotIncludedController.text,
        notes: serviceNoteController.text,
        timeEstimationFrom: serviceTimeFromController.text.isNotEmpty ? double.tryParse(serviceTimeFromController.text) : null,
        timeEstimationTo: serviceTimeToController.text.isNotEmpty ? double.tryParse(serviceTimeToController.text) : null,
      );
      if (!isUpdate) {
        result = await StoreRepository.find.addService(service, currentStore!, withBack: true);
        FirebaseAnalytics.instance.logEvent(
          name: 'create_service',
          parameters: {
            'service_name': service.name ?? 'undefined',
            'category': service.category?.name ?? 'undefined',
          },
        );
      } else {
        result = await StoreRepository.find.updateService(service, currentStore!, withBack: true);
      }
      isLoading.value = false;
      if (result != null) {
        currentStore!.services = [...currentStore!.services?.where((element) => element.id != result?.id).toList() ?? [], result];
        onFinish?.call();
      }
    }
  }

  static Future<void> editService(Service service, {void Function()? onFinish}) async {
    isLoading.value = true;
    serviceNameController.text = service.name ?? '';
    serviceDescriptionController.text = service.description ?? '';
    servicePriceController.text = service.price.toString();
    serviceGallery = service.gallery?.map((e) => e.file).toList() ?? [];
    category.value = service.category ?? Category.empty();
    await addService(update: true);
    onFinish?.call();
  }

  static void deleteService(Service service, {void Function()? onFinish}) => Helper.openConfirmationDialog(
        content: 'delete_service_msg'.trParams({'serviceName': service.name!}),
        onConfirm: () async {
          isLoading.value = true;
          final result = await StoreRepository.find.deleteService(service);
          isLoading.value = false;
          if (result) currentStore!.services!.removeWhere((element) => element.id == service.id);
          onFinish?.call();
        },
      );

  static Future<void> addService({bool update = false}) async =>
      await Get.bottomSheet(AddServiceBottomsheet(isUpdate: update), isScrollControlled: true).then((value) => _clearServiceFields());

  static Future<void> addServicePictures({void Function()? onFinish}) async {
    try {
      List<XFile>? imageList;
      final pickerPlatform = ImagePickerPlatform.getPlatformPicker();
      if (foundation.kIsWeb) {
        imageList = await pickerPlatform.getMedia();
      } else {
        imageList = await pickerPlatform.pickMultiImage();
      }
      if (imageList != null) {
        serviceGallery = imageList;
        onFinish?.call();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in addServicePictures:\n$e');
    }
  }

  static void _clearServiceFields() {
    serviceNameController.clear();
    serviceDescriptionController.clear();
    servicePriceController.clear();
    serviceGallery = [];
    category.value = Category.empty();
    updateServiceId = null;
  }
}
