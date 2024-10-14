import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../helpers/helper.dart';
import '../../../models/reservation.dart';
import '../../../models/service.dart';

import '../../../repositories/reservation_repository.dart';
import '../../../services/authentication_service.dart';

class ServiceDetailsController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  RxInt condidates = 0.obs;

  void clearFormFields() {
    noteController.clear();
  }

  Future<void> bookService(Service service) async {
    final result = await ReservationRepository.find.addServiceReservation(
      reservation: Reservation(
        service: service,
        date: DateTime.now(),
        totalPrice: service.price ?? 0,
        user: AuthenticationService.find.jwtUserData!,
        note: noteController.text,
        // coupon: coupon,
      ),
    );
    if (result) {
      Get.back();
      Helper.snackBar(message: 'service_booked_successfully'.tr);
    }
  }
}
