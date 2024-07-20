import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/task_database_repository.dart';
import '../helpers/helper.dart';
import '../models/filter_model.dart';
import '../models/task.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class TaskRepository extends GetxService {
  static TaskRepository get find => Get.find<TaskRepository>();

  // TODO remove this method replace by filter and lazy loading
  Future<List<Task>?> getAllTasks() async {
    try {
      List<Task>? tasks;
      if (MainAppController.find.isConnected.value) {
        final result = await ApiBaseHelper().request(RequestType.get, '/task/', sendToken: true);
        tasks = (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
      } else {
        tasks = await TaskDatabaseRepository.find.select();
      }
      if (tasks.isNotEmpty && MainAppController.find.isConnected.value) TaskDatabaseRepository.find.backupTasks(tasks);
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getAllTasks:\n$e');
    }
    return null;
  }

  Future<List<Task>?> getHotTasks() async {
    try {
      List<Task>? tasks;
      if (MainAppController.find.isConnected.value) {
        final result = await ApiBaseHelper().request(RequestType.get, '/task/hot', sendToken: true);
        tasks = (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
      } else {
        tasks = await TaskDatabaseRepository.find.getHotTasks();
      }
      if (tasks.isNotEmpty && MainAppController.find.isConnected.value) TaskDatabaseRepository.find.backupTasks(tasks, isHotTasks: true);
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getHotTasks:\n$e');
    }
    return null;
  }

  Future<List<Task>?> filterTasks({required String searchQuery, required FilterModel filter}) async {
    try {
      List<Task>? tasks;
      if (MainAppController.find.isConnected.value) {
        final result = await ApiBaseHelper().request(
          RequestType.get,
          sendToken: true,
          '/task/filter?searchQuery=$searchQuery${filter.category != null ? '&categoryId=${filter.category!.id}' : ''}${filter.minPrice != null ? '&priceMin=${filter.minPrice}' : ''}${filter.maxPrice != null ? '&priceMax=${filter.maxPrice}' : ''}${filter.nearby != null ? '&nearby=${filter.nearby}' : ''}',
        );
        tasks = (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
      } else {
        tasks = await TaskDatabaseRepository.find.filterTasks(searchQuery, filter);
      }
      if (tasks.isNotEmpty && MainAppController.find.isConnected.value) TaskDatabaseRepository.find.backupTasks(tasks);
      return tasks;
    } catch (e) {
      LoggerService.logger?.e('Error occured in filterTasks:\n$e');
    }
    return null;
  }

  Future<Task?> addTask(Task newtask, {required bool withBack}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, sendToken: true, '/task/', body: newtask.toJson(), files: newtask.attachments?.map((e) => e.file).toList());
      if (withBack) Get.back();
      final task = Task.fromJson(result['task']);
      if (MainAppController.find.isConnected.value) TaskDatabaseRepository.find.backupTask(task);
      Helper.snackBar(message: 'Task added successfully');
      return task;
    } catch (e) {
      Helper.snackBar(message: 'Error occurred adding your task, please try again later!');
      LoggerService.logger?.e('Error occured in addTask:\n$e');
    }
    return null;
  }
}
