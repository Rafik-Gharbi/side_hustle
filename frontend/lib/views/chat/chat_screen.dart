import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/overflowed_text_with_tooltip.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ChatController>(
        initState: (state) => Helper.waitAndExecute(
          () => state.controller != null,
          () => state.controller!.loggedInUser == null || state.controller!.discussionHistory.isEmpty ? state.controller!.init() : null,
        ),
        builder: (controller) => Obx(
          () => CustomScaffoldBottomNavigation(
            appBarTitle: 'messages'.tr,
            appBarActions: [
              CustomButtons.icon(
                icon: Icon(controller.openSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined),
                onPressed: () => controller.openSearchBar.value = !controller.openSearchBar.value,
              ),
            ],
            appBarBottom: controller.openSearchBar.value
                ? AppBar(
                    backgroundColor: kNeutralColor100,
                    leading: const SizedBox(),
                    flexibleSpace: CustomTextField(
                      fieldController: controller.searchDiscussionsController,
                      hintText: 'search_discussions'.tr,
                      suffixIcon: const Icon(Icons.search, color: kPrimaryColor),
                      fillColor: Colors.white,
                      onChanged: (value) => Helper.onSearchDebounce(() => controller.searchChatBubbles(value)),
                      focusNode: controller.searchDiscussionsFocusNode,
                    ),
                  )
                : null,
            body: RefreshIndicator(
              color: kPrimaryColor,
              backgroundColor: kNeutralColor100,
              displacement: 20,
              onRefresh: controller.onRefreshScreen,
              child: Padding(
                padding: const EdgeInsets.all(Paddings.large),
                child: LoadingRequest(
                  isLoading: controller.isLoading,
                  child: controller.userChatPropertiesFiltered.isEmpty
                      ? Center(child: Text('no_discussion_yet'.tr, style: AppFonts.x14Regular))
                      : SharedPreferencesService.find.isReady && AuthenticationService.find.jwtUserData == null
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
                                                      providedUser: controller.loggedInUser!.isOwner ? User(name: discussion.userName) : User(name: discussion.ownerName),
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
                                                    title: controller.loggedInUser!.isOwner ? discussion.userName ?? 'user'.tr : (discussion.ownerName ?? 'user'.tr),
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
            ),
          ),
        ),
      ),
    );
  }
}
