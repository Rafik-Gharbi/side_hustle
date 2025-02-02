import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helpers/helper.dart';
import '../../../models/referral.dart';
import '../../../repositories/referral_repository.dart';
import '../../../services/authentication_service.dart';

class ReferralController extends GetxController {
  RxBool isLoading = true.obs;
  List<Referral> referredUsers = [];

  ReferralController() {
    _init();
  }

  String? get referralCode {
    if (AuthenticationService.find.jwtUserData!.referralCode != null) {
      return AuthenticationService.find.jwtUserData!.referralCode!;
    } else {
      Helper.snackBar(message: 'error_occurred'.tr);
    }
    return null;
  }

  Future<void> _init() async {
    final result = await ReferralRepository.find.listReferral();
    referredUsers = result ?? [];
    isLoading.value = false;
    update();
  }

  void copyCodeToClipboard() {
    if (referralCode != null) {
      Clipboard.setData(ClipboardData(text: referralCode!));
      Helper.snackBar(message: 'copied_clipboard'.tr);
      FirebaseAnalytics.instance.logEvent(
        name: 'share',
        parameters: {
          'method': 'copy_code',
        },
      );
    }
  }

  void shareReferralCode() {
    if (referralCode != null) {
      final message = 'share_referral_code_message'.trParams({'referralCode': referralCode!});
      Share.share(message);
      FirebaseAnalytics.instance.logEvent(
        name: 'share',
        parameters: {
          'method': 'share_msg',
        },
      );
    }
  }
}
