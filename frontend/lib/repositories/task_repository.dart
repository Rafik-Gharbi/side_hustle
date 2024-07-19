import 'package:get/get.dart';

import '../helpers/helper.dart';
import '../models/filter_model.dart';
import '../models/task.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class TaskRepository extends GetxService {
  static TaskRepository get find => Get.find<TaskRepository>();

  Future<List<Task>?> getAllTasks() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/task/', sendToken: true);
      return (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getAllTasks:\n$e');
    }
    return null;
  }

  Future<List<Task>?> getHotTasks() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/task/hot', sendToken: true);
      return (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getHotTasks:\n$e');
    }
    return null;
  }

  Future<List<Task>?> filterTasks({required String searchQuery, required FilterModel filter}) async {
    try {
      final result = await ApiBaseHelper().request(
        RequestType.get,
        sendToken: true,
        '/task/filter?searchQuery=$searchQuery${filter.category != null ? '&categoryId=${filter.category!.id}' : ''}${filter.minPrice != null ? '&priceMin=${filter.minPrice}' : ''}${filter.maxPrice != null ? '&priceMax=${filter.maxPrice}' : ''}${filter.nearby != null ? '&nearby=${filter.nearby}' : ''}',
      );
      return (result['formattedList'] as List).map((e) => Task.fromJson(e)).toList();
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
      Helper.snackBar(message: 'Task added successfully');
      return task;
    } catch (e) {
      Helper.snackBar(message: 'Error occurred adding your task, please try again later!');
      LoggerService.logger?.e('Error occured in addTask:\n$e');
    }
    return null;
  }
}
