import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../services/theme/theme.dart';

class StatsScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const StatsScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralLightColor,
      appBar: AppBar(
        backgroundColor: kNeutralColor100,
        title: Text(title, style: AppFonts.x15Bold),
        centerTitle: true,
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
