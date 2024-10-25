import 'package:drift/drift.dart';

import '../database/database.dart';
import '../helpers/helper.dart';
import 'enum/request_status.dart';
import 'service.dart';
import 'task.dart';
import 'user.dart';

class Reservation {
  final String? id;
  final Task? task;
  final Service? service;
  final DateTime date;
  final double totalPrice;
  final double? proposedPrice;
  final String? coupon;
  final String note;
  final RequestStatus status;
  final User user;
  final DateTime? dueDate;
  final int coins;

  Reservation({
    this.id,
    required this.date,
    required this.totalPrice,
    required this.user,
    required this.coins,
    this.task,
    this.service,
    this.proposedPrice,
    this.status = RequestStatus.pending,
    this.coupon,
    this.dueDate,
    this.note = '',
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        id: json['id'],
        task: json['task'] != null ? Task.fromJson(json['task'], attachments: json['taskAttachments']) : null,
        service: json['service'] != null ? Service.fromJson(json['service'], gallery: json['serviceGallery']) : null,
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now(),
        totalPrice: Helper.resolveDouble(json['totalPrice']),
        proposedPrice: Helper.resolveDouble(json['proposedPrice']),
        coupon: json['coupon'],
        coins: json['coins'] ?? 0,
        note: json['note'] ?? '',
        status: RequestStatus.values.singleWhere((element) => element.name == json['status']),
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (task != null) data['taskId'] = task?.id;
    if (service != null) data['serviceId'] = service?.id;
    data['date'] = date.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['proposedPrice'] = proposedPrice;
    data['coins'] = coins;
    data['coupon'] = coupon;
    data['note'] = note;
    data['status'] = status.name;
    if (dueDate != null) data['dueDate'] = dueDate!.toIso8601String();
    return data;
  }

  factory Reservation.fromReservationData({required ReservationTableCompanion reservation, Task? task, Service? service}) => Reservation(
        id: reservation.id.value,
        task: task,
        service: service,
        date: reservation.date.value,
        totalPrice: reservation.totalPrice.value,
        proposedPrice: reservation.proposedPrice.value,
        coins: reservation.coins.value,
        coupon: reservation.coupon.value,
        note: reservation.note.value,
        status: reservation.status.value,
        user: User(id: reservation.user.value),
      );

  ReservationTableCompanion toReservationCompanion({RequestStatus? statusUpdate}) => ReservationTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        task: task?.id == null ? const Value.absent() : Value(task?.id!),
        service: service?.id == null ? const Value.absent() : Value(service?.id!),
        date: Value(date),
        totalPrice: Value(totalPrice),
        proposedPrice: Value(proposedPrice),
        coins: Value(coins),
        coupon: coupon == null ? const Value.absent() : Value(coupon!),
        note: Value(note),
        status: Value(statusUpdate ?? status),
        user: user.id == null ? const Value.absent() : Value(user.id!),
      );
}
