import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/theme/theme.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import 'market_controller.dart';

class MarketScreen extends StatelessWidget {
  static const String routeName = '/market';
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<MarketController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'Market',
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.discussionList.isEmpty
                ? const Center(child: Text('Nothing here!', style: AppFonts.x14Regular))
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
