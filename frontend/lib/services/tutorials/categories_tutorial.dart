import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../theme/theme.dart';

class CategoriesTutorial {
  static List<TargetFocus> targets = [];
  static GlobalKey searchFieldKey = GlobalKey();
  static GlobalKey categoryKey = GlobalKey();

  static void showTutorial() {
    targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: searchFieldKey,
          topContent: [
            const SizedBox(height: Paddings.exceptional),
            Text(
              'filter_by_category'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'filter_by_category_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
          bottomContent: [
            Text(
              'search_for_category'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'search_for_category_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: categoryKey,
          isCircle: true,
          topContent: [
            Text(
              'explore_categories'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'explore_categories_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
          bottomContent: [
            Text(
              'filter_subcategory'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'filter_subcategory_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
