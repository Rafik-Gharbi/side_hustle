import '../store.dart';
import '../task.dart';

class FavoriteDTO {
  final List<Task> savedTasks;
  final List<Store> savedStores;

  FavoriteDTO({required this.savedTasks, required this.savedStores});

  factory FavoriteDTO.fromJson(Map<String, dynamic> json) => FavoriteDTO(
        savedTasks: json['savedTasks'] != null ? (json['savedTasks'] as List).map((e) => Task.fromJson(e)).toList() : [],
        savedStores: json['savedStores'] != null ? (json['savedStores'] as List).map((e) => Store.fromJson(e)).toList() : [],
      );
}
