import '../task.dart';

class TaskRequestDTO {
  final Task task;
  final int condidates;

  TaskRequestDTO({required this.task, required this.condidates});

  factory TaskRequestDTO.fromJson(Map<String, dynamic> json) => TaskRequestDTO(
        task: Task.fromJson(json['task']),
        condidates: json['condidates'],
      );
}
