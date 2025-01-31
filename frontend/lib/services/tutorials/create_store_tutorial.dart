import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/store/my_store/my_store_controller.dart';
import '../theme/theme.dart';

class CreateStoreTutorial {
  static RxBool notShowAgain = false.obs;

  static void showTutorial() {
    if (MyStoreController.find.targets.isEmpty) {
      MyStoreController.find.targets.add(
        Buildables.buildTargetFocus(
          keyTarget: MyStoreController.find.createStoreBtnKey,
          topContent: [
            Text(
              'create_a_store'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'create_a_store_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'why_create_store'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'why_create_store_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
