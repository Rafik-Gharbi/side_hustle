import '../enum/report_reasons.dart';
import '../service.dart';
import '../task.dart';
import '../user.dart';

class ReportDTO {
  final int? id;
  final User? user;
  final User reportedUser;
  final Task? task;
  final Service? service;
  final ReportReasons reasons;
  final String explanation;
  final DateTime? createdAt;

  ReportDTO({
    this.id,
    required this.user,
    required this.reportedUser,
    required this.task,
    required this.service,
    required this.reasons,
    required this.explanation,
    this.createdAt,
  });

  factory ReportDTO.fromJson(Map<String, dynamic> json) => ReportDTO(
        id: json['id'],
        reportedUser: User.fromJson(json['reportedUser']),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        task: json['task'] != null ? Task.fromJson(json['task']) : null,
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
        reasons: ReportReasons.values.singleWhere((element) => element.name == json['reasons']),
        explanation: json['explanation'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['reportedUser'] = reportedUser.toJson();
    data['reasons'] = reasons.name;
    data['explanation'] = explanation;
    if (id != null) data['id'] = id;
    if (user != null) data['user'] = user!.toJson();
    if (task != null) data['task'] = task!.toJson();
    if (service != null) data['service'] = service!.toJson();
    return data;
  }
}
