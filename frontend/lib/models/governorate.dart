import 'package:drift/drift.dart';

import '../database/database.dart';

class Governorate {
  final int id;
  final String name;

  Governorate({required this.id, required this.name});

  factory Governorate.fromJson(Map<String, dynamic> json) => Governorate(
        id: json['id'],
        name: json['name'],
      );

  factory Governorate.fromGovernorateData({required GovernorateTableCompanion governorate}) => Governorate(
        id: governorate.id.value,
        name: governorate.name.value,
      );

  GovernorateTableCompanion toGovernorateCompanion() => GovernorateTableCompanion(
        id: Value(id),
        name: Value(name),
      );
}
