import 'package:get/get.dart';

import '../helpers/helper.dart';
import '../models/boost.dart';
import '../models/dto/boost_dto.dart';
import '../networking/api_base_helper.dart';
import '../services/logging/logger_service.dart';

class BoostRepository extends GetxService {
  static BoostRepository get find => Get.find<BoostRepository>();

  // Send a proposal for the service's owner
  Future<bool> addBoost({required Boost boost, required String taskServiceId, required bool isTask}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/boost/add', body: boost.toJson(taskServiceId: taskServiceId, isTask: isTask), sendToken: true);
      return result['boost'] != null && result['boost'].toString().isNotEmpty;
    } catch (e) {
      if (e.toString().contains('boost_already_exist')) {
        Helper.snackBar(message: 'boost_already_exist'.tr);
      } else {
        Helper.snackBar(message: 'error_sending_request'.tr);
      }
      LoggerService.logger?.e('Error occured in addBoost:\n$e');
    }
    return false;
  }

  Future<Boost?> getBoostByServiceId(int serviceId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/boost/service/$serviceId', sendToken: true);
      final boost = Boost.fromJson(result['boost']);
      return boost;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getBoostByServiceId:\n$e');
    }
    return null;
  }

  Future<Boost?> getBoostByTaskId(int taskId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/boost/task/$taskId', sendToken: true);
      final boost = Boost.fromJson(result['boost']);
      return boost;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getBoostByTaskId:\n$e');
    }
    return null;
  }

  Future<bool> updateBoost({required Boost boost}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.put,
        '/boost/update',
        sendToken: true,
        body: boost.toJson(taskServiceId: boost.taskServiceId, isTask: boost.isTask),
      );
      return result['boost'] != null && result['boost'].toString().isNotEmpty;
    } catch (e) {
      Helper.snackBar(message: 'error_occurred'.tr);
      LoggerService.logger?.e('Error occured in updateBoost:\n$e');
    }
    return false;
  }

  Future<List<BoostDTO>> getUserBoosts({required int page, int limit = 9}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/boost/list?pageQuery=$page&limitQuery=$limit', sendToken: true);
      List<BoostDTO> boosts = (result['boosts'] as List).map((e) => BoostDTO.fromJson(e)).toList();
      return boosts;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserBoosts:\n$e');
    }
    return [];
  }
}
