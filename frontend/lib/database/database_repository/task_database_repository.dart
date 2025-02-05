import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../../models/dto/favorite_dto.dart';
import '../../models/dto/image_dto.dart';
import '../../models/filter_model.dart';
import '../../models/task.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/logging/logger_service.dart';
import '../../services/shared_preferences.dart';
import '../database.dart';
import 'store_database_repository.dart';
import 'user_database_repository.dart';

class TaskDatabaseRepository extends GetxService {
  static TaskDatabaseRepository get find => Get.find<TaskDatabaseRepository>();
  final Database database = Database.getInstance();

  // Insert a task  in the database
  Future<Task?> insert(TaskTableCompanion task) async {
    final existingItem = await getTaskById(task.id.value);
    if (existingItem != null) return existingItem;
    await database.into(database.taskTable).insert(task, mode: InsertMode.insertOrReplace);
    Task? result = await getTaskById(task.id.value);
    return result;
  }

  Future<TaskAttachmentTableCompanion?> insertAttachment(TaskAttachmentTableCompanion attachment) async {
    final int attachmentId = await database.into(database.taskAttachmentTable).insert(attachment, mode: InsertMode.insertOrReplace);
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

  Future<Task?> getTaskById(String taskId) async {
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

  Future<void> backupTasks(List<Task> tasks) async {
    LoggerService.logger?.i('Backing up tasks...');
    for (var task in tasks) {
      await backupTask(task);
    }
  }

  Future<void> deleteOldTasks(List<Task> tasks) async {
    LoggerService.logger?.i('Deleting old tasks...');
    for (var task in tasks) {
      final tableExists = await Database.doesTableExist(database, 'task_table');
      if (tableExists) {
        await delete(task);
      }
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
      LatLng? userCoordinates = AuthenticationService.find.jwtUserData?.coordinates;
      final filtered = allTasks
          .where(
            (task) =>
                (searchQuery.isNotEmpty ? task.title.contains(searchQuery) : false) ||
                (searchQuery.isNotEmpty ? task.description.contains(searchQuery) : false) ||
                (task.category != null && filter!.category != null ? task.category?.id == filter.category?.id : false) ||
                (task.price != null && filter!.minPrice != null && filter.maxPrice != null ? task.price! < filter.maxPrice! && task.price! > filter.minPrice! : false) ||
                (filter!.nearby != null && task.coordinates != null && userCoordinates != null
                    ? Helper.calculateDistance(task.coordinates!.latitude, task.coordinates!.longitude, userCoordinates.latitude, userCoordinates.longitude) <= filter.nearby!
                    : false),
          )
          .toList();
      return filtered;
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

  Future<void> backupTaskRequest(List<Task> tasks) async {
    SharedPreferencesService.find.add(taskRequestsKey, jsonEncode(tasks.map((e) => e.id).toList()));
    await backupTasks(tasks);
  }

  Future<List<Task>> getTaskRequest() async {
    LoggerService.logger?.i('Getting task requests...');
    List<Task> result = [];
    final savedIds = SharedPreferencesService.find.get(taskRequestsKey);
    List<String> taskRequestsId = (jsonDecode(savedIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (taskRequestsId.isNotEmpty) {
      for (var taskId in taskRequestsId) {
        final task = await getTaskById(taskId);
        if (task != null) result.add(task);
      }
    }
    return result;
  }

  Future<FavoriteDTO?> getSavedFavorite() async {
    try {
      LoggerService.logger?.i('Getting favorite tasks...');
      FavoriteDTO result = FavoriteDTO(savedTasks: [], savedStores: []);
      final savedTaskIds = SharedPreferencesService.find.get(favoriteTasksKey);
      List<String> favoriteTasksId = (jsonDecode(savedTaskIds ?? '[]') as List).map((e) => e.toString()).toList();
      final savedStoreIds = SharedPreferencesService.find.get(favoriteStoresKey);
      List<int> favoriteStoresId = (jsonDecode(savedStoreIds ?? '[]') as List).map((e) => e is int ? e : int.parse(e.toString())).toList();
      if (favoriteTasksId.isNotEmpty) {
        for (var taskId in favoriteTasksId) {
          final task = await getTaskById(taskId);
          if (task != null) result.savedTasks.add(task);
        }
      }
      if (favoriteStoresId.isNotEmpty) {
        for (var storeId in favoriteStoresId) {
          final store = await StoreDatabaseRepository.find.getStoreById(storeId);
          if (store != null) result.savedStores.add(store);
        }
      }
      return result;
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getSavedFavorite: $e');
      return null;
    }
  }

  Future<void> backupFavorite(FavoriteDTO? favorites) async {
    if (favorites == null) return;
    if (favorites.savedTasks.isNotEmpty) {
      SharedPreferencesService.find.add(favoriteTasksKey, jsonEncode(favorites.savedTasks));
    }
    await backupTasks(favorites.savedTasks);
    await StoreDatabaseRepository.find.backupStores(favorites.savedStores, isFavorite: true);
  }

  Future<void> backupHomeTasks(Map<String, List> tasks) async {
    if (tasks['hotTasks'] != null && (tasks['hotTasks'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(hotTasksKey, jsonEncode((tasks['hotTasks'] as List).map((e) => e.id).toList()));
    }
    if (tasks['nearbyTasks'] != null && (tasks['nearbyTasks'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(nearbyTasksKey, jsonEncode((tasks['nearbyTasks'] as List).map((e) => e.id).toList()));
    }
    if (tasks['governorateTasks'] != null && (tasks['governorateTasks'] as List).isNotEmpty) {
      SharedPreferencesService.find.add(governorateTasksKey, jsonEncode((tasks['governorateTasks'] as List).map((e) => e.id).toList()));
    }
    final List<Task> tasksForBackup = [];
    tasksForBackup.addAll((tasks['hotTasks'] as List).map((e) => e as Task));
    tasksForBackup.addAll((tasks['nearbyTasks'] as List).map((e) => e as Task));
    tasksForBackup.addAll((tasks['governorateTasks'] as List).map((e) => e as Task));
    await backupTasks(tasksForBackup);
  }

  Future<Map<String, List<dynamic>>> getHomeTasks() async {
    LoggerService.logger?.i('Getting home tasks...');
    List<Task> hotTasks = [];
    List<Task> nearbyTasks = [];
    List<Task> governorateTasks = [];
    final savedIds = SharedPreferencesService.find.get(hotTasksKey);
    List<String> hotTasksId = (jsonDecode(savedIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (hotTasksId.isNotEmpty) {
      for (var taskId in hotTasksId) {
        final task = await getTaskById(taskId);
        if (task != null) hotTasks.add(task);
      }
    }
    final savedNearbyIds = SharedPreferencesService.find.get(nearbyTasksKey);
    List<String> nearbyTasksId = (jsonDecode(savedNearbyIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (nearbyTasksId.isNotEmpty) {
      for (var taskId in nearbyTasksId) {
        final task = await getTaskById(taskId);
        if (task != null) nearbyTasks.add(task);
      }
    }
    final savedGovernorateIds = SharedPreferencesService.find.get(governorateTasksKey);
    List<String> governorateTasksId = (jsonDecode(savedGovernorateIds ?? '[]') as List).map((e) => e.toString()).toList();
    if (governorateTasksId.isNotEmpty) {
      for (var taskId in governorateTasksId) {
        final task = await getTaskById(taskId);
        if (task != null) governorateTasks.add(task);
      }
    }
    return {'hotTasks': hotTasks, 'nearbyTasks': nearbyTasks, 'governorateTasks': governorateTasks};
  }
}
