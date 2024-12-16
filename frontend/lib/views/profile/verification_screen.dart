import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/loading_request.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import 'profile_screen/profile_screen.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/hold_in_safe_area.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = '/verification';
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final errorHasOccured = Get.arguments == null || Get.arguments.isNotEmpty;
    return HoldInSafeArea(
      child: CustomScaffoldBottomNavigation(
        backgroundColor: kNeutralColor100,
        body: DecoratedBox(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.5))),
          child: LoadingRequest(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional),
                  child: Center(child: Lottie.asset(errorHasOccured ? Assets.failed : Assets.success, height: 150, fit: BoxFit.contain)),
                ),
                if (errorHasOccured)
                  Align(alignment: Alignment.center, child: Text('${'error_occurred'.tr}\n${Get.arguments.toString().tr}', style: AppFonts.x18Bold, textAlign: TextAlign.center))
                else
                  Align(alignment: Alignment.center, child: Text('account_verified_success'.tr, style: AppFonts.x18Bold)),
                const SizedBox(height: Paddings.regular),
                CustomButtons.text(
                  title: 'go_profile'.tr,
                  onPressed: () => MainAppController.find.manageNavigation(routeName: ProfileScreen.routeName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
