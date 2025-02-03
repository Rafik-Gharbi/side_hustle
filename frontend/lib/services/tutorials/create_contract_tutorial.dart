import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../helpers/buildables.dart';
import '../theme/theme.dart';

class CreateContractTutorial {
  static List<TargetFocus> targets = [];
  static GlobalKey contractFormKey = GlobalKey();
  static RxBool notShowAgain = false.obs;

  static void showTutorial() {
    if (targets.isNotEmpty) targets.clear();
    targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: contractFormKey,
          topContent: [
            Text(
              'contract_form'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'contract_form_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: contractFormKey,
          topContent: [
            Text(
              'what_next'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'what_next_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
