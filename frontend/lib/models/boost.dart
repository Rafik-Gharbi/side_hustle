import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import 'governorate.dart';
import 'user.dart';

class Boost {
  final int? id;
  final double budget;
  final Governorate? governorate;
  final Gender? gender;
  final DateTime endDate;
  final int? minAge;
  final int? maxAge;

  Boost({
    required this.budget,
    required this.endDate,
    this.id,
    this.governorate,
    this.gender,
    this.minAge,
    this.maxAge,
  });

  factory Boost.fromJson(Map<String, dynamic> json) => Boost(
        id: json['id'],
        governorate: json['governorate_id'] != null ? MainAppController.find.getGovernorateById(json['governorate_id']) : null,
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now().add(const Duration(days: 7)),
        budget: Helper.resolveDouble(json['budget']),
        gender: json['gender'] != null ? Gender.fromString(json['gender']) : null,
        minAge: json['minAge'],
        maxAge: json['maxAge'],
      );

  Map<String, dynamic> toJson({required int taskServiceId, required bool isTask}) {
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
    return data;
  }
}
