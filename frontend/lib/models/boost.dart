import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import 'governorate.dart';
import 'user.dart';

class Boost {
  final String? id;
  final double budget;
  final Governorate? governorate;
  final Gender? gender;
  final DateTime endDate;
  final int? minAge;
  final int? maxAge;
  final bool isTask;
  final String taskServiceId;
  bool isActive;

  Boost({
    required this.budget,
    required this.endDate,
    required this.taskServiceId,
    required this.isTask,
    this.id,
    this.governorate,
    this.gender,
    this.minAge,
    this.maxAge,
    this.isActive = true,
  });

  factory Boost.fromJson(Map<String, dynamic> json) => Boost(
        id: json['id'],
        governorate: json['governorate_id'] != null ? MainAppController.find.getGovernorateById(json['governorate_id']) : null,
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now().add(const Duration(days: 7)),
        budget: Helper.resolveDouble(json['budget']),
        gender: json['gender'] != null ? Gender.fromString(json['gender']) : null,
        minAge: json['minAge'],
        maxAge: json['maxAge'],
        isActive: json['isActive'] ?? false,
        isTask: json['isTask'] ?? true,
        taskServiceId: json['task_service_id'],
      );

  Map<String, dynamic> toJson({required String taskServiceId, required bool isTask}) {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['governorate_id'] = governorate?.id;
    data['endDate'] = endDate.toIso8601String();
    data['budget'] = budget;
    data['gender'] = gender?.value.toLowerCase();
    data['minAge'] = minAge;
    data['maxAge'] = maxAge;
    data['taskServiceId'] = taskServiceId;
    data['isTask'] = isTask;
    data['isActive'] = isActive;
    return data;
  }
}
