import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../constants/colors.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';
import '../../services/theme/theme.dart';
import '../../widgets/loading_card_effect.dart';
import '../../widgets/main_screen_with_bottom_navigation.dart';
import '../../widgets/overflowed_text_with_tooltip.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasFinishedChatTutorial = SharedPreferencesService.find.get(hasFinishedChatTutorialKey) == 'true';
    bool hasOpenedTutorial = false;
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (controller) => Obx(
        () {
          if (!hasFinishedChatTutorial &&
              MainAppController.find.isChatScreen &&
              !hasOpenedTutorial &&
              controller.userChatPropertiesFiltered.isNotEmpty &&
              controller.targets.isNotEmpty &&
              !controller.isLoading.value) {
            hasOpenedTutorial = true;
            MainScreenWithBottomNavigation.isOnTutorial.value = true;
            TutorialCoachMark(
              targets: controller.targets,
              colorShadow: kNeutralOpacityColor,
              textSkip: 'skip'.tr,
              onSkip: () {
                MainScreenWithBottomNavigation.isOnTutorial.value = false;
                return true;
              },
              onFinish: () => SharedPreferencesService.find.add(hasFinishedChatTutorialKey, 'true'),
            ).show(context: context);
          }
          return MainAppController.find.isChatScreen
              ? RefreshIndicator(
                  color: kPrimaryColor,
                  backgroundColor: kNeutralColor100,
                  displacement: 20,
                  onRefresh: controller.onRefreshScreen,
                  child: Padding(
                    padding: const EdgeInsets.all(Paddings.large),
                    child: LoadingCardEffect(
                      isLoading: controller.isLoading,
                      type: LoadingCardEffectType.chat,
                      child: controller.userChatPropertiesFiltered.isEmpty
                          ? Center(child: Text('no_discussion_yet'.tr, style: AppFonts.x14Regular))
                          : SharedPreferencesService.find.isReady.value && AuthenticationService.find.jwtUserData == null
                              ? Buildables.buildLoginRequest(onLogin: controller.update)
                              : controller.loggedInUser == null
                                  ? Buildables.buildLoadingWidget()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.userChatPropertiesFiltered.length,
                                      itemBuilder: (context, index) {
                                        final discussion = controller.userChatPropertiesFiltered[index];
                                        final isCurrentChat = discussion.id == controller.selectedChatBubble?.id || discussion.id == -1;
                                        return InkWell(
                                          key: hasFinishedChatTutorial ? null : controller.firstChatKey,
                                          onTap: () => controller.selectedChatBubble = discussion,
                                          child: Padding(
                                            padding: const EdgeInsets.all(Paddings.regular),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 49,
                                                  child: InkWell(
                                                    onTap: () => controller.selectedChatBubble = discussion,
                                                    child: Badge(
                                                      offset: const Offset(0, 0),
                                                      isLabelVisible: discussion.notSeen != 0,
                                                      label: Text(discussion.notSeen.toString(), style: AppFonts.x10Regular.copyWith(color: kNeutralColor100)),
                                                      child: CircleAvatar(
                                                        radius: isCurrentChat ? 26 : 22,
                                                        backgroundColor: kPrimaryColor,
                                                        child: Buildables.userImage(
                                                          size: 50,
                                                          providedUser: controller.loggedInUser!.name == discussion.ownerName
                                                              ? User(name: discussion.userName)
                                                              : User(name: discussion.ownerName),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: Paddings.regular),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      OverflowedTextWithTooltip(
                                                        title:
                                                            '${controller.loggedInUser!.name == discussion.ownerName ? discussion.userName ?? 'user'.tr : (discussion.ownerName ?? 'user'.tr)} (${discussion.reservation?.getTitle()})',
                                                        style: (isCurrentChat ? AppFonts.x14Bold : AppFonts.x14Regular).copyWith(color: kBlackColor),
                                                        expand: false,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              Helper.isUUID(discussion.lastMessage ?? '') ? 'new_contract'.tr : discussion.lastMessage ?? '',
                                                              style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(width: Paddings.regular),
                                                          Text(
                                                            DateFormat.MMMEd().format(discussion.lastMessageDate ?? DateTime.now()),
                                                            style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
