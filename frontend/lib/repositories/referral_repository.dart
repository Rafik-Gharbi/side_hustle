import 'package:get/get.dart';

import '../models/referral.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class ReferralRepository extends GetxService {
  static ReferralRepository get find => Get.find<ReferralRepository>();

  Future<List<Referral>?> listReferral() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/referral/list', sendToken: true);
      final referrals = (result?['referrals'] as List?)?.map((e) => Referral.fromJson(e)).toList();
      return referrals;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listReferral:\n$e');
    }
    return null;
  }
}
