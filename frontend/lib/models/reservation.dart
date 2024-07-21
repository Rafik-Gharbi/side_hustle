import 'task.dart';
import 'user.dart';

enum ReservationStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  rejected('Rejected'),
  finished('Finished');

  final String value;

  const ReservationStatus(this.value);
}

class Reservation {
  final int? id;
  final Task task;
  final DateTime date;
  final double totalPrice;
  final String? coupon;
  final String note;
  final ReservationStatus status;
  final User user;

  Reservation({
    this.id,
    required this.task,
    required this.date,
    required this.totalPrice,
    required this.user,
    this.status = ReservationStatus.pending,
    this.coupon,
    this.note = '',
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        id: json['id'],
        task: Task.fromJson(json['task'], attachments: json['taskAttachments']),
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        totalPrice: json['totalPrice'] is int ? (json['totalPrice'] as int).toDouble() : json['totalPrice'],
        coupon: json['coupon'],
        note: json['note'],
        status: ReservationStatus.values.singleWhere((element) => element.name == json['status']),
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['taskId'] = task.id;
    data['date'] = date.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['coupon'] = coupon;
    data['note'] = note;
    data['status'] = status.name;
    return data;
  }
}
