import 'package:drift/drift.dart';

import '../database/database.dart';
import '../helpers/helper.dart';
import 'enum/request_status.dart';
import 'task.dart';
import 'user.dart';

class Reservation {
  final String? id;
  final Task task;
  final DateTime date;
  final double totalPrice;
  final double? proposedPrice;
  final String? coupon;
  final String note;
  final RequestStatus status;
  final User user;

  Reservation({
    this.id,
    required this.task,
    required this.date,
    required this.totalPrice,
    required this.user,
    this.proposedPrice,
    this.status = RequestStatus.pending,
    this.coupon,
    this.note = '',
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        id: json['id'],
        task: Task.fromJson(json['task'], attachments: json['taskAttachments']),
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        totalPrice: Helper.resolveDouble(json['totalPrice']),
        proposedPrice: Helper.resolveDouble(json['proposedPrice']),
        coupon: json['coupon'],
        note: json['note'],
        status: RequestStatus.values.singleWhere((element) => element.name == json['status']),
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['taskId'] = task.id;
    data['date'] = date.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['proposedPrice'] = proposedPrice;
    data['coupon'] = coupon;
    data['note'] = note;
    data['status'] = status.name;
    return data;
  }

  factory Reservation.fromReservationData({required ReservationTableCompanion reservation, required Task task}) => Reservation(
        id: reservation.id.value,
        task: task,
        date: reservation.date.value,
        totalPrice: reservation.totalPrice.value,
        proposedPrice: reservation.proposedPrice.value,
        coupon: reservation.coupon.value,
        note: reservation.note.value,
        status: reservation.status.value,
        user: User(id: reservation.user.value),
      );

  ReservationTableCompanion toReservationCompanion({RequestStatus? statusUpdate}) => ReservationTableCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        task: task.id == null ? const Value.absent() : Value(task.id!),
        date: Value(date),
        totalPrice: Value(totalPrice),
        proposedPrice: Value(proposedPrice),
        coupon: coupon == null ? const Value.absent() : Value(coupon!),
        note: Value(note),
        status: Value(statusUpdate ?? status),
        user: user.id == null ? const Value.absent() : Value(user.id!),
      );
}
