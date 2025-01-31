import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/home/home_controller.dart';
import '../theme/theme.dart';

class HomeTutorial {
  static void showTutorial() {
    if (HomeController.find.targets.isEmpty) {
      HomeController.find.targets.addAll(
        [
          Buildables.buildTargetFocus(
            keyTarget: HomeController.find.firstTaskKey,
            topContent: [
              Text(
                'earn_income'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'earn_income_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: Paddings.exceptional),
              Text(
                'task_example'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'task_example_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Buildables.buildTargetFocus(
            keyTarget: HomeController.find.categoryRowKey,
            bottomContent: [
              Text(
                'filter_category'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'filter_category_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Buildables.buildTargetFocus(
            keyTarget: HomeController.find.searchFieldKey,
            bottomContent: [
              Text(
                'search_specific'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'search_specific_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Buildables.buildTargetFocus(
            keyTarget: HomeController.find.advancedFilterKey,
            isCircle: true,
            bottomContent: [
              Text(
                'advanced_filter'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'advanced_filter_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Buildables.buildTargetFocus(
            keyTarget: HomeController.find.searchModeDropdownKey,
            bottomContent: [
              Text(
                'change_search_mode'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'change_search_mode_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Buildables.buildTargetFocus(
            keyTarget: HomeController.find.mapViewKey,
            isCircle: true,
            bottomContent: [
              Text(
                'visualize_on_map'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'visualize_on_map_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      );
    }
  }
}
