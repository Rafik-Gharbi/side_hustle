import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/extensions/date_time_extension.dart';
import '../../../models/chat.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/message_bubble.dart';
import '../chat_controller.dart';

class BuildChatMessages extends StatelessWidget {
  const BuildChatMessages({super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GetBuilder<ChatController>(
          builder: (controller) => StreamBuilder<List<ChatModel>?>(
            stream: controller.streamSocket.socketStream,
            initialData: controller.discussionHistory,
            builder: (BuildContext context, AsyncSnapshot<List<ChatModel>?> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    if (controller.isLoadingMoreChat) Buildables.buildLoadingWidget(height: 80),
                    Expanded(
                      child: ListView.builder(
                        controller: controller.chatScrollController,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final msg = snapshot.data![index];
                          final isSearch = controller.searchMessagesController.text.isNotEmpty;
                          return Column(
                            children: [
                              if (isSearch && index == snapshot.data!.length - 1 && !controller.endLoadBefore)
                                Center(
                                  child: CustomButtons.text(
                                    onPressed: () => controller.getBeforeAfterMessages(snapshot.data![snapshot.data!.length - 1].id, true),
                                    title: 'load_more'.tr,
                                    titleStyle: AppFonts.x12Regular,
                                  ),
                                ),
                              // Add chat message date
                              if (index == (snapshot.data?.length ?? 0) - 1 ||
                                  index < (snapshot.data?.length ?? 0) - 1 && !snapshot.data![index + 1].createdAt.isSameDate(msg.createdAt))
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: Paddings.small),
                                    child: Text(
                                      DateFormat.MMMMEEEEd().format(msg.createdAt),
                                      style: AppFonts.x12Bold.copyWith(color: kNeutralColor),
                                    ),
                                  ),
                                ),
                              MessageBubble(
                                date: msg.createdAt,
                                searchText: controller.searchMessagesController.text,
                                msgText: msg.message,
                                loggedUser: AuthenticationService.find.jwtUserData!.id != msg.recieverId,
                              ),
                              if (isSearch && index == 0 && !controller.endLoadAfter)
                                Center(
                                  child: CustomButtons.text(
                                    onPressed: () => controller.getBeforeAfterMessages(snapshot.data![0].id, false),
                                    title: 'load_more'.tr,
                                    titleStyle: AppFonts.x12Regular,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Get.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('nothing_here_yet'.tr, style: AppFonts.x14Regular),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );
}
