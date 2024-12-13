import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../services/navigation_history_observer.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';

class CustomStandardScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? actionButton;

  const CustomStandardScaffold({super.key, required this.title, required this.body, this.actionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralLightColor,
      appBar: AppBar(
        backgroundColor: kNeutralColor100,
        title: Text(title, style: AppFonts.x15Bold),
        centerTitle: true,
        leading: CustomButtons.icon(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => NavigationHistoryObserver.instance.goToPreviousRoute(),
        ),
        actions: actionButton != null ? [actionButton!] : null,
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kNeutralLightColor, kNeutralColor100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: body,
        ),
      ),
    );
  }
}
