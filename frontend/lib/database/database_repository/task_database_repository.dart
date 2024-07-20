import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../../models/dto/image_dto.dart';
import '../../models/filter_model.dart';
import '../../models/task.dart';
import '../../models/user.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences.dart';
import '../database.dart';
import 'user_database_repository.dart';

class TaskDatabaseRepository extends GetxService {
  static TaskDatabaseRepository get find => Get.find<TaskDatabaseRepository>();
  final Database database = Database.getInstance();

  // Insert a task  in the database
  Future<Task?> insert(TaskTableCompanion task) async {
    final int taskId = await database.into(database.taskTable).insert(task);
    Task? result = await getTaskById(taskId);
    return result;
  }

  Future<TaskAttachmentTableCompanion?> insertAttachment(TaskAttachmentTableCompanion attachment) async {
    final int attachmentId = await database.into(database.taskAttachmentTable).insert(attachment);
    TaskAttachmentTableCompanion? result = await getAttachmentById(attachmentId);
    return result;
  }

  // Select all tasks in database
  Future<List<Task>> select() async {
    final List<TaskTableData> allTasks = await database.select(database.taskTable).get();
    final List<Task> result = <Task>[];
    for (var taskElement in allTasks) {
      final Task task = await _convertTaskTo(taskElement.toCompanion(true));
      result.add(task);
    }
    return result;
  }

  Future<List<TaskAttachmentTableCompanion>> selectAttachments() async {
    final List<TaskAttachmentTableData> allTasksAttachments = await database.select(database.taskAttachmentTable).get();
    return allTasksAttachments.map((e) => e.toCompanion(true)).toList();
  }

  Future<List<Task>> selectWithFilter(Function($TaskTableTable tbl) condition, {bool withFeedback = false}) async {
    final List<TaskTableData> allTasks = await (database.select(database.taskTable)..where((tbl) => condition(tbl))).get();
    final List<Task> result = <Task>[];
    for (var taskElement in allTasks) {
      final Task task = await _convertTaskTo(taskElement.toCompanion(true), withFeedback: withFeedback);
      result.add(task);
    }
    return result;
  }

  // Update a task in the database and update the tasks list in OverviewController
  Future<void> update(TaskTableCompanion taskCompanion) async {
    await database.update(database.taskTable).replace(taskCompanion);
  }

  Future<void> updateAttachment(TaskAttachmentTableCompanion attachmentCompanion) async {
    await database.update(database.taskAttachmentTable).replace(attachmentCompanion);
  }

  // Delete a task from both notion and database, returns deleted task id
  Future<int> delete(Task task) async {
    return await database.delete(database.taskTable).delete(task.toTaskCompanion());
  }

  Future<int> deleteAttachment(TaskAttachmentTableCompanion attachment) async {
    return await database.delete(database.taskAttachmentTable).delete(attachment);
  }

  Future<Task?> getTaskById(int taskId) async {
    final TaskTableData? task = (await (database.select(database.taskTable)..where((tbl) => tbl.id.equals(taskId))).get()).firstOrNull;
    return task != null ? await _convertTaskTo(task.toCompanion(true)) : null;
  }

  Future<TaskAttachmentTableCompanion?> getAttachmentById(int attachmentId) async {
    final TaskAttachmentTableData? attachment = (await (database.select(database.taskAttachmentTable)..where((tbl) => tbl.id.equals(attachmentId))).get()).firstOrNull;
    return attachment?.toCompanion(true);
  }

  Future<TaskAttachmentTableCompanion?> getAttachmentByUrl(String url) async {
    final TaskAttachmentTableData? attachment = (await (database.select(database.taskAttachmentTable)..where((tbl) => tbl.url.equals(url))).get()).firstOrNull;
    return attachment?.toCompanion(true);
  }

  Future<void> backupTask(Task task, {bool isFavorite = false}) async {
    if (task.id == null) return;
    final existTask = await getTaskById(task.id!);
    if (existTask != null && isFavorite) {
      // update is Favorite
      await update(existTask.toTaskCompanion(isFavoriteUpdate: task.isFavorite));
    } else if (existTask == null) {
      await insert(task.toTaskCompanion());
    }
    // backup task's attachments if absent, else update
    if (task.attachments != null && task.attachments!.isNotEmpty) {
      for (var attachment in task.attachments!) {
        final existAttachment = await getAttachmentByUrl(attachment.file.path);
        if (existAttachment != null) {
          await updateAttachment(existAttachment);
        } else {
          await insertAttachment(attachment.toAttachmentCompanion(taskId: task.id));
        }
      }
    }
  }

  Future<void> backupTasks(List<Task> tasks, {bool isHotTasks = false, bool isFavorite = false}) async {
    LoggerService.logger?.i('Backing up tasks (isHotTasks: $isHotTasks, isFavorite: $isFavorite)...');
    if (isHotTasks) {
      SharedPreferencesService.find.add(hotTasksKey, jsonEncode(tasks.map((e) => e.id).toList()));
    }
    if (isFavorite) {
      SharedPreferencesService.find.add(favoriteTasksKey, jsonEncode(tasks.map((e) => e.id).toList()));
    }
    for (var task in tasks) {
      await backupTask(task);
    }
  }

  Future<void> deleteOldTasks(List<Task> tasks) async {
    LoggerService.logger?.i('Deleting old tasks...');
    for (var task in tasks) {
      await delete(task);
      task.attachments?.forEach((element) async => await deleteAttachment(element.toAttachmentCompanion(taskId: task.id)));
    }
  }

  Future<List<Task>> filterTasks(String searchQuery, FilterModel? filter) async {
    LoggerService.logger?.i('Filtering tasks (searchQuery: $searchQuery, filter: ${filter.toString()})...');
    final allTasks = await select();
    // final allAttachments = await selectAttachments();
    // Helper.snackBar(message: 'All saved attachments length: ${allAttachments.length}');
    // final allTasks = await selectWithFilter((tbl) => tbl.title.contains(searchQuery), withFeedback: true);
    if (searchQuery.isEmpty && (filter == null || !filter.isNotEmpty)) {
      return allTasks;
    } else {
      final filtered = allTasks
          .where(
            (task) =>
                (searchQuery.isNotEmpty ? task.title.contains(searchQuery) : false) ||
                (searchQuery.isNotEmpty ? task.description.contains(searchQuery) : false) ||
                (task.category != null && filter!.category != null ? task.category?.id == filter.category?.id : false) ||
                (task.price != null && filter!.minPrice != null && filter.maxPrice != null ? task.price! < filter.maxPrice! && task.price! > filter.minPrice! : false),
            // TODO add nearby filtering
          )
          .toList();
      return filtered;
    }
  }

  Future<List<Task>> getHotTasks() async {
    LoggerService.logger?.i('Getting hot tasks...');
    List<Task> result = [];
    final savedIds = SharedPreferencesService.find.get(hotTasksKey);
    List<int> hotTasksId = (jsonDecode(savedIds ?? '[]') as List).map((e) => e is int ? e : int.parse(e.toString())).toList();
    if (hotTasksId.isNotEmpty) {
      for (var taskId in hotTasksId) {
        final task = await getTaskById(taskId);
        if (task != null) result.add(task);
      }
    }
    return result;
  }

  Future<List<Task>> getFavoriteTasks() async {
    try {
      LoggerService.logger?.i('Getting favorite tasks...');
      List<Task> result = [];
      final savedIds = SharedPreferencesService.find.get(favoriteTasksKey);
      List<int> favoriteTasksId = (jsonDecode(savedIds ?? '[]') as List).map((e) => e is int ? e : int.parse(e.toString())).toList();
      if (favoriteTasksId.isNotEmpty) {
        for (var taskId in favoriteTasksId) {
          final task = await getTaskById(taskId);
          if (task != null) result.add(task);
        }
      }
      return result;
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getFavoriteTasks: $e');
      return [];
    }
  }

  Future<List<TaskAttachmentTableData>> _getTaskAttachments(TaskTableCompanion task, {bool withFeedback = false}) async {
    final attachments = (await (database.select(database.taskAttachmentTable)..where((tbl) => tbl.taskId.equals(task.id.value))).get());
    if (withFeedback) Helper.snackBar(message: 'Task ${task.title.value} has ${attachments.length} attachments');
    return attachments;
  }

  Future<Task> _convertTaskTo(TaskTableCompanion task, {bool withFeedback = false}) async {
    final User? taskUser = await UserDatabaseRepository.find.getUserById(task.owner.value as int);
    final List<ImageDTO> attachments = (await _getTaskAttachments(task, withFeedback: withFeedback)).map((e) => _convertToImageDTO(e)).toList();
    return Task.fromTaskData(task: task, owner: taskUser ?? User(id: task.owner.value), attachments: attachments);
  }

  ImageDTO _convertToImageDTO(TaskAttachmentTableData e) => ImageDTO(file: XFile(e.url), type: ImageType.values.singleWhere((element) => element.name == e.type));
}
