import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ChatController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'Messages',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.discussionList.isEmpty
                ? const Center(child: Text('You have no discussion yet!', style: AppFonts.x14Regular))
                : const SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
