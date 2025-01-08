import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/empty_animation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../chat_controller.dart';
import 'build_chat_header.dart';
import 'build_chat_messages.dart';
import 'build_chat_search_result.dart';
import 'circular_button_with_menu.dart';

class MessagesScreen extends StatelessWidget {
  static const String routeName = '/messages';
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ChatController>(
        init: ChatController(),
        initState: (state) => Helper.waitAndExecute(
          () => state.controller != null,
          () => state.controller!.selectedChatBubble == null ? state.controller!.init() : null,
        ),
        builder: (controller) => Obx(
          () => CustomStandardScaffold(
            backgroundColor: kNeutralColor100,
            title: 'messages'.tr,
            onBack: controller.clearMessagesScreen,
            actionButton: 
              CustomButtons.icon(
                icon: Icon(controller.openMessagesSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined),
                onPressed: () => controller.openMessagesSearchBar.value = !controller.openMessagesSearchBar.value,
              ),
            appBarBottom: controller.openMessagesSearchBar.value
                ? AppBar(
                    backgroundColor: kNeutralColor100,
                    leading: const SizedBox(),
                    flexibleSpace: CustomTextField(
                      fieldController: controller.searchMessagesController,
                      hintText: 'search_chat'.tr,
                      suffixIcon: const Icon(Icons.search, color: kPrimaryColor),
                      fillColor: Colors.white,
                      onChanged: (value) => Helper.onSearchDebounce(() => controller.searchChatMessages(value)),
                      focusNode: controller.searchMessagesFocusNode,
                    ),
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.all(Paddings.large).copyWith(bottom: Paddings.exceptional),
              child: controller.selectedChatBubble == null
                  ? Center(child: Text('select_discussion'.tr, style: AppFonts.x14Regular))
                  : SharedPreferencesService.find.isReady.value && AuthenticationService.find.jwtUserData == null
                      ? Buildables.buildLoginRequest(onLogin: controller.update)
                      : controller.loggedInUser == null
                          ? Buildables.buildLoadingWidget()
                          : Helper.isNullOrEmpty(controller.selectedChatBubble?.id.toString())
                              ? Center(child: Text('select_discussion'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralLightColor)))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Chat Header
                                    const BuildChatHeader(),
                                    if (controller.searchChatResult.isNotEmpty)
                                      const BuildChatSearchResult()
                                    else if (controller.searchChatResult.isEmpty && controller.searchMessagesController.text.isNotEmpty && !controller.isSearchMode)
                                      EmptyAnimation(itemCount: 0, message: 'search_not_found'.tr, child: const SizedBox())
                                    else
                                      // Chat Messages
                                      EmptyAnimation(
                                        message: 'no_messages'.tr,
                                        itemCount: controller.discussionHistory.length,
                                        expandIfEmpty: true,
                                        child: const BuildChatMessages(),
                                      ),
                                    const SizedBox(height: Paddings.large),
                                    // Send new message
                                    CustomTextField(
                                      fieldController: controller.messageController,
                                      focusNode: controller.messageFocusNode,
                                      outlinedBorder: true,
                                      enableFloatingLabel: false,
                                      hintText: 'send_message'.tr,
                                      textAlign: TextAlign.start,
                                      onSubmitted: (_) => controller.sendMessage(),
                                      prefixIcon: CircularButtonWithMenu(
                                        menuItems: [
                                          MenuOptionItem(icon: Icons.attach_file_rounded, label: 'attachments'.tr, onTap: controller.attachToMessage),
                                          if (controller.hasOngoingReservation)
                                            MenuOptionItem(icon: Icons.assignment_outlined, label: 'create_contract'.tr, onTap: controller.createContract),
                                        ],
                                      ),
                                      suffixIcon: CustomButtons.icon(
                                        onPressed: controller.sendMessage,
                                        icon: const Icon(Icons.send, color: kNeutralColor),
                                        disabled: controller.selectedChatBubble == null,
                                      ),
                                    ),
                                  ],
                                ),
            ),
          ),
        ),
      ),
    );
  }
}
