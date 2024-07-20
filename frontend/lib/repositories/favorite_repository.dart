import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/task_database_repository.dart';
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
      List<Task>? tasks;
      if (MainAppController.find.isConnected.value) {
        final result = await ApiBaseHelper().request(RequestType.get, '/favorite/list', sendToken: true);
        tasks = (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
      } else {
        tasks = await TaskDatabaseRepository.find.getFavoriteTasks();
      }
      if (MainAppController.find.isConnected.value) TaskDatabaseRepository.find.backupTasks(tasks, isFavorite: true);
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listFavorite:\n$e');
    }
    return [];
  }
}
