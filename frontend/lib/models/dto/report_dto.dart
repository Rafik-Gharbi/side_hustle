import '../enum/report_reasons.dart';
import '../service.dart';
import '../task.dart';
import '../user.dart';

class ReportDTO {
  final User user;
  final Task? task;
  final Service? service;
  final ReportReasons reasons;
  final String explanation;

  ReportDTO({
    required this.user,
    required this.task,
    required this.service,
    required this.reasons,
    required this.explanation,
  });

  factory ReportDTO.fromJson(Map<String, dynamic> json) => ReportDTO(
        user: User.fromJson(json['user']),
        task: json['task'] != null ? Task.fromJson(json['task']) : null,
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
        reasons: ReportReasons.values.singleWhere((element) => element.name == json['reasons']),
        explanation: json['explanation'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user'] = user.toJson();
    data['reasons'] = reasons.name;
    data['explanation'] = explanation;
    if (task != null) data['task'] = task?.toJson();
    if (service != null) data['service'] = service?.toJson();
    return data;
  }
}
