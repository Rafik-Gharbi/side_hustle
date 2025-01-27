import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/task/add_task/add_task_controller.dart';
import '../theme/theme.dart';

class AddTaskTutorial {
  static void showTutorial() {
    AddTaskController.find.targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: AddTaskController.find.titleFieldKey,
          bottomContent: [
            const SizedBox(height: Paddings.exceptional),
            Text(
              'add_a_task'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'add_a_task_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'be_clear_specific'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'be_clear_specific_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: AddTaskController.find.categoryKey,
          bottomContent: [
            Text(
              'choose_category'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'choose_category_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: AddTaskController.find.dueDateKey,
          topContent: [
            Text(
              'set_due_date'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'set_due_date_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: AddTaskController.find.priceKey,
          topContent: [
            Text(
              'set_budget'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'set_budget_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: AddTaskController.find.locationKey,
          topContent: [
            Text(
              'add_location'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'add_location_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
