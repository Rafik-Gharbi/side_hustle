import '../reservation.dart';
import '../user.dart';

class TaskReservationDetailsDTO {
  final int condidates;
  final bool isUserTaskSeeker;
  final User? confirmedTaskUser;
  final Reservation? reservation;

  TaskReservationDetailsDTO({required this.condidates, required this.isUserTaskSeeker, this.confirmedTaskUser, this.reservation});

  factory TaskReservationDetailsDTO.fromJson(Map<String, dynamic> json) => TaskReservationDetailsDTO(
        condidates: json['condidates'],
        isUserTaskSeeker: json['isUserTaskSeeker'],
        confirmedTaskUser: json['confirmedTaskUser'] != null ? User.fromJson(json['confirmedTaskUser']) : null,
        reservation: json['reservation'] != null ? Reservation.fromJson(json['reservation']) : null,
      );
}
