import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helpers/helper.dart';
import '../../../models/referral.dart';
import '../../../repositories/referral_repository.dart';
import '../../../services/authentication_service.dart';

class ReferralController extends GetxController {
  bool isLoading = true;
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
    isLoading = false;
    update();
  }

  void copyCodeToClipboard() {
    if (referralCode != null) {
      Clipboard.setData(ClipboardData(text: referralCode!));
      Helper.snackBar(message: 'copied_clipboard'.tr);
    }
  }

  void shareReferralCode() {
    if (referralCode != null) {
      final message = 'share_referral_code_message'.trParams({'referralCode': referralCode!});
      Share.share(message);
    }
  }
}
