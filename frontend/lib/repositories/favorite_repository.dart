import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/task_database_repository.dart';
import '../models/dto/favorite_dto.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class FavoriteRepository extends GetxService {
  static FavoriteRepository get find => Get.find<FavoriteRepository>();

  Future<bool> toggleTaskFavorite({required int idTask}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/favorite/toggle-task', body: {'idTask': idTask}, sendToken: true);
      return result['added'];
    } catch (e) {
      LoggerService.logger?.e('Error occured in toggleTaskFavorite:\n$e');
    }
    return false;
  }

  Future<bool> toggleStoreFavorite({required int idStore}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/favorite/toggle-store', body: {'idStore': idStore}, sendToken: true);
      return result['added'];
    } catch (e) {
      LoggerService.logger?.e('Error occured in toggleStoreFavorite:\n$e');
    }
    return false;
  }

  Future<FavoriteDTO?> listFavorite() async {
    try {
      FavoriteDTO? favorites;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/favorite/list', sendToken: true);
        favorites = FavoriteDTO.fromJson(result);
      } else {
        favorites = await TaskDatabaseRepository.find.getSavedFavorite();
      }
      if (MainAppController.find.isConnected) TaskDatabaseRepository.find.backupFavorite(favorites);
      return favorites;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listFavorite:\n$e');
    }
    return null;
  }
}
