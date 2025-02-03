import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/store/market/market_controller.dart';
import '../theme/theme.dart';

class MarketTutorial {
  static void showTutorial() {
    if (MarketController.find.targets.isNotEmpty) MarketController.find.targets.clear();
    MarketController.find.targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: MarketController.find.firstStoreKey,
          bottomContent: [
            Text(
              'hire_experts'.tr,
              style: AppFonts.x18Bold.copyWith(color: kBlackReversedColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'hire_experts_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: kBlackReversedColor),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'store_example'.tr,
              style: AppFonts.x18Bold.copyWith(color: kBlackReversedColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'store_example_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: kBlackReversedColor),
              ),
            )
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: MarketController.find.searchIconKey,
          isCircle: true,
          bottomContent: [
            Text(
              'search_specific'.tr,
              style: AppFonts.x18Bold.copyWith(color: kBlackReversedColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'search_specific_msg_icon'.tr,
                style: AppFonts.x14Regular.copyWith(color: kBlackReversedColor),
              ),
            )
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: MarketController.find.advancedFilterKey,
          isCircle: true,
          bottomContent: [
            Text(
              'advanced_filter'.tr,
              style: AppFonts.x18Bold.copyWith(color: kBlackReversedColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'advanced_filter_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: kBlackReversedColor),
              ),
            )
          ],
        ),
      ],
    );
  }
}
