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
  final void Function()? onBack;
  final PreferredSizeWidget? appBarBottom;
  final bool noAppBar;
  final Color? backgroundColor;

  const CustomStandardScaffold(
      {super.key, required this.title, required this.body, this.actionButton, this.onBack, this.appBarBottom, this.noAppBar = false, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? kNeutralLightColor,
      appBar: noAppBar
          ? null
          : AppBar(
              backgroundColor: kNeutralColor100,
              title: Text(title, style: AppFonts.x15Bold),
              centerTitle: true,
              bottom: appBarBottom,
              leading: CustomButtons.icon(
                icon: Icon(Icons.chevron_left, size: 28, color: kBlackColor),
                onPressed: () {
                  onBack?.call();
                  NavigationHistoryObserver.instance.goToPreviousRoute();
                },
              ),
              actions: actionButton != null ? [actionButton!] : null,
            ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: backgroundColor == null
                ? LinearGradient(
                    colors: [kNeutralLightColor, kNeutralColor100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
          ),
          child: body,
        ),
      ),
    );
  }
}
