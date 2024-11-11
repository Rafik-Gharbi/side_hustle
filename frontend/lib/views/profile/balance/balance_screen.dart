import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import 'balance_controller.dart';

class BalanceScreen extends StatelessWidget {
  static const String routeName = '/my-balance';
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<BalanceController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'my_balance'.tr,
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kNeutralColor, kNeutralColor100], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.only(top: Paddings.extraLarge),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.extraLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Account balance', style: AppFonts.x16Regular.copyWith(color: kNeutralColor100)),
                              Text(
                                '${Helper.formatAmount(AuthenticationService.find.jwtUserData!.balance)} ${MainAppController.find.currency.value}',
                                style: AppFonts.x24Bold.copyWith(color: kNeutralColor100),
                              ),
                              const SizedBox(height: Paddings.extraLarge),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButtons.icon(
                                    onPressed: () {
                                      // TODO
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: kAccentColor.withOpacity(0.8), borderRadius: circularRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Paddings.regular),
                                        child: SizedBox(
                                          width: 120,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(Assets.withdrawMoneyIcon, width: 20),
                                              const SizedBox(width: Paddings.regular),
                                              const Text('Widhdraw', style: AppFonts.x14Regular),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomButtons.icon(
                                    onPressed: () {
                                      // TODO
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: kAccentColor.withOpacity(0.8), borderRadius: circularRadius),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Paddings.regular),
                                        child: SizedBox(
                                          width: 120,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(Assets.depositMoneyIcon, width: 20),
                                              const SizedBox(width: Paddings.regular),
                                              const Text('Deposit', style: AppFonts.x14Regular),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Paddings.regular),
                      LoadingRequest(
                        isLoading: controller.isLoading,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                          child: SizedBox(
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.all(Paddings.extraLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Balance history', style: AppFonts.x15Bold),
                                  if (controller.balanceHistory.isEmpty)
                                    SizedBox(height: Get.height - 470, child: Center(child: Text('no_history_yet'.tr, style: AppFonts.x14Regular)))
                                  else
                                    ...List.generate(
                                      controller.balanceHistory.length,
                                      (index) {
                                        return const SizedBox();
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Paddings.large),
                    ],
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
