import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/buildables.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../chat_controller.dart';

class BuildChatSearchResult extends StatelessWidget {
  const BuildChatSearchResult({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ChatController>(
        builder: (controller) => Expanded(
          child: Column(
            children: [
              if (controller.isLoadingMoreChat) Buildables.buildLoadingWidget(height: 80),
              Expanded(
                child: ListView.builder(
                  controller: controller.chatScrollController,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: controller.searchChatResult.length,
                  itemBuilder: (context, index) {
                    final msg = controller.searchChatResult[index];
                    final isCurrentUser = msg.senderId == AuthenticationService.find.jwtUserData?.id;
                    return InkWell(
                      onTap: () => controller.goToMessageInChat(msg.id),
                      child: ListTile(
                        title: Text(isCurrentUser ? 'you'.tr : 'client'.tr),
                        subtitle: RichText(
                          text: TextSpan(
                            style: AppFonts.x12Regular,
                            children: [
                              TextSpan(
                                text: msg.message.substring(0, msg.message.indexOf(controller.searchMessagesController.text)),
                                style: AppFonts.x12Regular,
                              ),
                              TextSpan(
                                text: controller.searchMessagesController.text,
                                style: AppFonts.x12Bold,
                              ),
                              TextSpan(
                                text: msg.message.substring(msg.message.indexOf(controller.searchMessagesController.text) + controller.searchMessagesController.text.length),
                                style: AppFonts.x12Regular,
                              ),
                              // msg date
                              TextSpan(
                                text: ' • ${DateFormat.MMMd().add_Hm().format(msg.createdAt)}',
                                style: AppFonts.x12Regular,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
