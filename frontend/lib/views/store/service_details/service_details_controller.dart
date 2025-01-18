import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../models/service.dart';

import '../../../viewmodel/store_viewmodel.dart';

class ServiceDetailsController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  RxInt condidates = 0.obs;

  void clearFormFields() {
    noteController.clear();
  }

  void editService(Service service) {
    Get.back();
    StoreViewmodel.editService(service, onFinish: update);
  }

  void deleteService(Service service) {
    Get.back();
    StoreViewmodel.deleteService(service, onFinish: update);
  }
}
