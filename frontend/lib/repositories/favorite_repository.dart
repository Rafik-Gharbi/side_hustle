import 'package:get/get.dart';

import '../models/task.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class FavoriteRepository extends GetxService {
  static FavoriteRepository get find => Get.find<FavoriteRepository>();

  Future<bool> toggleFavorite({required int idTask}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/favorite/toggle', body: {'idTask': idTask}, sendToken: true);
      return result['added'];
    } catch (e) {
      LoggerService.logger?.e('Error occured in toggleFavorite:\n$e');
    }
    return false;
  }

  Future<List<Task>> listFavorite() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/favorite/list', sendToken: true);
      return (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in listFavorite:\n$e');
    }
    return [];
  }
}
