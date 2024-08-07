import 'package:get/get.dart';

import '../helpers/helper.dart';
import '../models/boost.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class BoostRepository extends GetxService {
  static BoostRepository get find => Get.find<BoostRepository>();

  // Send a proposal for the service's owner
  Future<bool> addBoost({required Boost boost, required int taskServiceId, required bool isTask}) async {
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

  // Future<List<Boost>> listBoost() async {
  //   try {
  //     final result = await ApiBaseHelper().request(RequestType.get, '/boost/list', sendToken: true);
  //     final services = (result['formattedList'] as List).map((e) => Boost.fromJson(e)).toList();
  //     return services;
  //   } catch (e) {
  //     LoggerService.logger?.e('Error occured in listBoost:\n$e');
  //   }
  //   return [];
  // }

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

  Future<bool> updateBoost({required Boost boost, required int taskServiceId, required bool isTask}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.put,
        '/boost/update',
        sendToken: true,
        body: boost.toJson(taskServiceId: taskServiceId, isTask: isTask),
      );
      return result['boost'] != null && result['boost'].toString().isNotEmpty;
    } catch (e) {
      Helper.snackBar(message: 'An error has occurred');
      LoggerService.logger?.e('Error occured in updateBoost:\n$e');
    }
    return false;
  }

  Future<List<Boost>> getUserBoosts() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/boost/list', sendToken: true);
      List<Boost> boosts = (result['boost'] as List).map((e) => Boost.fromJson(e)).toList();
      return boosts;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserBoosts:\n$e');
    }
    return [];
  }
}
