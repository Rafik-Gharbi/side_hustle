import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/main_app_controller.dart';
import '../database/database_repository/task_database_repository.dart';
import '../helpers/helper.dart';
import '../models/dto/task_request_dto.dart';
import '../models/filter_model.dart';
import '../models/reservation.dart';
import '../models/task.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class TaskRepository extends GetxService {
  static TaskRepository get find => Get.find<TaskRepository>();

  Future<Map<String, List<dynamic>>?> getHomeTasks() async {
    try {
      Map<String, List<dynamic>>? tasks = {};
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/task/home-tasks', sendToken: true);
        tasks.putIfAbsent('hotTasks', () => (result['hotTasks'] as List).map((e) => Task.fromJson(e)).toList());
        tasks.putIfAbsent('nearbyTasks', () => (result['nearbyTasks'] as List).map((e) => Task.fromJson(e)).toList());
        if (result['reservation'] != null) tasks.putIfAbsent('reservation', () => (result['reservation'] as List).map((e) => Reservation.fromJson(e)).toList());
        if (result['ongoingReservation'] != null) {
          tasks.putIfAbsent('ongoingReservation', () => (result['ongoingReservation'] as List).map((e) => Reservation.fromJson(e)).toList());
        }
      } else {
        tasks = await TaskDatabaseRepository.find.getHomeTasks();
      }
      if (tasks.isNotEmpty && MainAppController.find.isConnected) TaskDatabaseRepository.find.backupHomeTasks(tasks);
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getHomeTasks:\n$e');
    }
    return null;
  }

  Future<List<Task>?> filterTasks(
      {int page = 0, int limit = kLoadMoreLimit, String searchQuery = '', FilterModel? filter, int? taskId, bool withCoordinates = false, bool boosted = false}) async {
    try {
      List<Task>? tasks;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(
          RequestType.get,
          sendToken: true,
          withCoordinates
              ? '/task/filter?withCoordinates=$withCoordinates${filter?.category != null ? '&categoryId=${filter?.category!.id}' : ''}${filter?.minPrice != null ? '&priceMin=${filter?.minPrice}' : ''}${filter?.maxPrice != null ? '&priceMax=${filter?.maxPrice}' : ''}${filter?.nearby != null ? '&nearby=${filter?.nearby}' : ''}&boosted=$boosted'
              : '/task/filter?page=$page&limit=$limit&searchQuery=$searchQuery${filter?.category != null ? '&categoryId=${filter?.category!.id}' : ''}${filter?.minPrice != null ? '&priceMin=${filter?.minPrice}' : ''}${filter?.maxPrice != null ? '&priceMax=${filter?.maxPrice}' : ''}${filter?.nearby != null ? '&nearby=${filter?.nearby}' : ''}${taskId != null ? '&taskId=$taskId' : ''}&boosted=$boosted',
        );
        tasks = (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
      } else {
        tasks = await TaskDatabaseRepository.find.filterTasks(searchQuery, filter);
      }
      if (tasks.isNotEmpty && MainAppController.find.isConnected) TaskDatabaseRepository.find.backupTasks(tasks);
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in filterTasks:\n$e');
    }
    return null;
  }

  Future<List<TaskRequestDTO>?> listUserTaskRequest({int page = 0, int limit = kLoadMoreLimit}) async {
    try {
      List<TaskRequestDTO>? tasks;
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/task/user-request?page=$page&limit=$limit');
        tasks = (result['formattedList'] as List).map((e) => TaskRequestDTO.fromJson(e)).toList();
      } else {
        final list = await TaskDatabaseRepository.find.getTaskRequest();
        tasks = list.map((e) => TaskRequestDTO(task: e, condidates: 0)).toList();
      }
      if (tasks.isNotEmpty && MainAppController.find.isConnected) TaskDatabaseRepository.find.backupTaskRequest(tasks.map((e) => e.task).toList());
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listUserTaskRequest:\n$e');
    }
    return null;
  }

  Future<Task?> addTask(Task newtask, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, sendToken: true, '/task/', body: newtask.toJson(), files: newtask.attachments?.map((e) => e.file).toList());
      if (withBack) Helper.goBack();
      final task = Task.fromJson(result['task']);
      if (MainAppController.find.isConnected) TaskDatabaseRepository.find.backupTask(task);
      Helper.snackBar(message: 'task_added_successfully'.tr);
      return task;
    } catch (e) {
      Helper.snackBar(message: 'task_add_failed'.tr);
      LoggerService.logger?.e('Error occured in addTask:\n$e');
    }
    return null;
  }

  Future<Task?> updateTask(Task updateTask, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper()
          .request(RequestType.put, sendToken: true, '/task/${updateTask.id}', body: updateTask.toJson(), files: updateTask.attachments?.map((e) => e.file).toList());
      if (withBack) Helper.goBack();
      final task = Task.fromJson(result['task']);
      if (MainAppController.find.isConnected) TaskDatabaseRepository.find.backupTask(task);
      Helper.snackBar(message: 'task_updated_successfully'.tr);
      return task;
    } catch (e) {
      Helper.snackBar(message: 'task_updat_failed'.tr);
      LoggerService.logger?.e('Error occured in updateTask:\n$e');
    }
    return null;
  }

  Future<bool> deleteTask(Task task, {bool withBack = false}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.delete, sendToken: true, '/task/${task.id}');
      final status = result?['done'] ?? false;
      if (withBack) Helper.goBack();
      if (status) Helper.snackBar(message: 'task_deleted_successfully'.tr);
      return status;
    } catch (e) {
      LoggerService.logger?.e('Error occured in deleteUser:\n$e');
    }
    return false;
  }

  Future<Task?> getTaskById(String id) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, sendToken: true, '/task/$id');
      final task = result['task'] != null ? Task.fromJson(result['task']) : null;
      return task;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getTaskById:\n$e');
      return null;
    }
  }
}
