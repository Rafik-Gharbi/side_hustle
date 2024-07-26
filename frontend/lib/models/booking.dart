import 'enum/request_status.dart';
import 'service.dart';
import 'user.dart';

class Booking {
  final int? id;
  final Service service;
  final DateTime date;
  final double totalPrice;
  final String? coupon;
  final String note;
  final RequestStatus status;
  final User user;

  Booking({
    this.id,
    required this.service,
    required this.date,
    required this.totalPrice,
    required this.user,
    this.status = RequestStatus.pending,
    this.coupon,
    this.note = '',
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        service: Service.fromJson(json['service'], gallery: json['serviceGallery']),
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        totalPrice: json['totalPrice'] is int ? (json['totalPrice'] as int).toDouble() : json['totalPrice'],
        coupon: json['coupon'],
        note: json['note'],
        status: RequestStatus.values.singleWhere((element) => element.name == json['status']),
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['serviceId'] = service.id;
    data['date'] = date.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['coupon'] = coupon;
    data['note'] = note;
    data['status'] = status.name;
    return data;
  }
}
