import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../views/chat/chat_controller.dart';
import '../theme/theme.dart';

class ChatTutorial {
  static void showTutorial() {
    if (ChatController.find.targets.isEmpty) {
      ChatController.find.targets.addAll(
        [
          Buildables.buildTargetFocus(
            keyTarget: ChatController.find.firstChatKey,
            bottomContent: [
              Text(
                'chat_with_others'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'discuss_details_expectations'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: Paddings.exceptional),
              Text(
                'create_contract'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'create_contract_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: Paddings.exceptional),
              Text(
                'aware_terms_conditions'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'no_contact_sharing_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          Buildables.buildTargetFocus(
            keyTarget: ChatController.find.searchIconKey,
            isCircle: true,
            bottomContent: [
              Text(
                'search_discussion'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'search_discussion_msg'.tr,
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
