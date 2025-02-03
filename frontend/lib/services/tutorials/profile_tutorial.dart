import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../models/user.dart';
import '../../views/profile/profile_screen/profile_controller.dart';
import '../authentication_service.dart';
import '../theme/theme.dart';

class ProfileTutorial {
  static void showTutorial() {
    if (ProfileController.find.targets.isNotEmpty) ProfileController.find.targets.clear();
    ProfileController.find.targets.addAll(
      [
        Buildables.buildTargetFocus(
          keyTarget: ProfileController.find.profileHeaderKey,
          bottomContent: [
            Text(
              'this_your_profile'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'this_your_profile_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: Paddings.exceptional),
            Text(
              'manage_coins_balance'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'manage_coins_balance_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        if (AuthenticationService.find.jwtUserData?.isVerified != VerifyIdentityStatus.verified)
          Buildables.buildTargetFocus(
            keyTarget: ProfileController.find.verifyAccountKey,
            bottomContent: [
              Text(
                'verify_account'.tr,
                style: AppFonts.x18Bold.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'verify_account_msg'.tr,
                  style: AppFonts.x14Regular.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        Buildables.buildTargetFocus(
          keyTarget: ProfileController.find.subscribeCategoryKey,
          bottomContent: [
            Text(
              'subscribe_category'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'subscribe_category_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: ProfileController.find.createStoreKey,
          topContent: [
            Text(
              'offer_skills'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'offer_skills_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        Buildables.buildTargetFocus(
          keyTarget: ProfileController.find.referFriendKey,
          topContent: [
            Text(
              'share_the_word'.tr,
              style: AppFonts.x18Bold.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'share_the_word_msg'.tr,
                style: AppFonts.x14Regular.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }
}
