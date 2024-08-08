import '../boost.dart';
import '../service.dart';
import '../task.dart';

class BoostDTO {
  final Boost boost;
  final Task? task;
  final Service? service;

  BoostDTO({required this.boost, required this.task, required this.service});

  factory BoostDTO.fromJson(Map<String, dynamic> json) => BoostDTO(
        boost: Boost.fromJson(json['boost']),
        task: json['task'] != null ? Task.fromJson(json['task']) : null,
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
      );
}
