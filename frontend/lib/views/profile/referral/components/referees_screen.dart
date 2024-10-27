import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../helpers/buildables.dart';
import '../../../../helpers/helper.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../../widgets/hold_in_safe_area.dart';
import '../../../../widgets/loading_request.dart';
import '../../../../widgets/overflowed_text_with_tooltip.dart';
import '../referral_controller.dart';

class RefereesScreen extends StatelessWidget {
  static const String routeName = '/referees';
  const RefereesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ReferralController>(
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'referees'.tr,
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.referredUsers.isEmpty
                ? Center(child: Text('no_referral_yet'.tr, style: AppFonts.x14Regular))
                : Padding(
                    padding: const EdgeInsets.all(Paddings.large),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('my_referrals'.tr, style: AppFonts.x15Bold),
                          const SizedBox(height: Paddings.regular),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.referredUsers.length,
                            itemBuilder: (context, index) {
                              final referee = controller.referredUsers[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.regular),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      OverflowedTextWithTooltip(title: referee.referredUser.name ?? '', style: AppFonts.x14Bold),
                                      Padding(
                                        padding: const EdgeInsets.only(right: Paddings.small),
                                        child: Row(
                                          children: [
                                            Text(referee.rewardCoins.toString(), style: AppFonts.x14Bold.copyWith(color: kAccentColor)),
                                            const SizedBox(width: Paddings.small),
                                            const Icon(Icons.paid_outlined, size: 18, color: kAccentColor),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(referee.status.name.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                      Text(Helper.formatDate(referee.resolveDate), style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                    ],
                                  ),
                                  leading: Buildables.userImage(providedUser: referee.referredUser, size: 40),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
