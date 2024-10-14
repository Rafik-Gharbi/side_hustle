import '../helpers/helper.dart';
import 'service.dart';
import 'task.dart';
import 'user.dart';

class Contract {
  final String? id;
  final double finalPrice;
  final DateTime? dueDate;
  final Task? task;
  final Service? service;
  final DateTime createdAt;
  final bool isSigned;
  final bool isPayed;
  final User? provider;
  final User? seeker;

  Contract({
    this.id,
    required this.finalPrice,
    required this.dueDate,
    required this.task,
    required this.service,
    required this.createdAt,
    this.provider,
    this.seeker,
    this.isSigned = false,
    this.isPayed = false,
  });

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
        id: json['id'],
        finalPrice: Helper.resolveDouble(json['finalPrice']),
        createdAt: DateTime.parse(json['createdAt']),
        dueDate: DateTime.parse(json['dueDate']),
        task: json['task'] != null ? Task.fromJson(json['task']) : null,
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
        provider: User.fromJson(json['provider']),
        seeker: User.fromJson(json['seeker']),
        isSigned: json['isSigned'] ?? false,
        isPayed: json['isPayed'] ?? false,
      );

  Map<String, dynamic> toJson({bool includeOwner = false}) {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['createdAt'] = createdAt.toIso8601String();
    data['dueDate'] = dueDate?.toIso8601String();
    data['finalPrice'] = finalPrice;
    if (task != null) data['task'] = task!.toJson(includeOwner: includeOwner);
    if (service != null) data['service'] = service!.toJson();
    data['isSigned'] = isSigned;
    data['isPayed'] = isPayed;
    if (includeOwner) data['seeker'] = seeker?.toJson();
    if (includeOwner) data['provider'] = provider?.toJson();
    return data;
  }
}
