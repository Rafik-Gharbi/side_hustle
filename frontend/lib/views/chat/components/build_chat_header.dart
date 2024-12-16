import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../chat_controller.dart';

class BuildChatHeader extends StatelessWidget {
  const BuildChatHeader({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ChatController>(
        builder: (controller) => DecoratedBox(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kNeutralLightColor))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Helper.isMobile ? 0 : Paddings.exceptional, vertical: Paddings.large).copyWith(top: Helper.isMobile ? 0 : Paddings.large),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
              child: Text(
                AuthenticationService.find.jwtUserData?.name == controller.selectedChatBubble?.userName
                    ? controller.selectedChatBubble?.ownerName ?? ''
                    : controller.selectedChatBubble?.userName ?? '',
                style: AppFonts.x14Bold,
              ),
            ),
          ),
        ),
      );
}
