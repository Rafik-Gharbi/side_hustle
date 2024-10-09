import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../database/database_repository/booking_database_repository.dart';
import '../helpers/helper.dart';
import '../models/booking.dart';
import '../models/enum/request_status.dart';
import '../models/service.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class BookingRepository extends GetxService {
  static BookingRepository get find => Get.find<BookingRepository>();

  // Send a proposal for the service's owner
  Future<bool> addBooking({required Booking booking}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.post, '/booking/add', body: booking.toJson(), sendToken: true);
      if (MainAppController.find.isConnected) BookingDatabaseRepository.find.addBooking(Booking.fromJson(result));
      return result['booking'] != null && result['booking'].toString().isNotEmpty;
    } catch (e) {
      if (e.toString().contains('booking_already_exist')) {
        Helper.snackBar(message: 'booking_already_exist'.tr);
      } else if (e.toString().contains('cannot_book_your_own_service')) {
        Helper.snackBar(message: 'cannot_book_your_own_service'.tr);
      } else {
        Helper.snackBar(message: 'error_sending_request'.tr);
      }
      LoggerService.logger?.e('Error occured in addBooking:\n$e');
    }
    return false;
  }

  // Future<List<Booking>> listBooking() async {
  //   try {
  //     final result = await ApiBaseHelper().request(RequestType.get, '/booking/list', sendToken: true);
  //     final services = (result['formattedList'] as List).map((e) => Booking.fromJson(e)).toList();
  //     return services;
  //   } catch (e) {
  //     LoggerService.logger?.e('Error occured in listBooking:\n$e');
  //   }
  //   return [];
  // }

  Future<List<Booking>> getBookingByServiceId(String serviceId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/booking/service-booking?serviceId=$serviceId', sendToken: true);
      final services = (result['formattedList'] as List).map((e) => Booking.fromJson(e)).toList();
      return services;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listBooking:\n$e');
    }
    return [];
  }

  Future<int> getServiceCondidates(Service service) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/booking/condidates?serviceId=${service.id}');
      return result['condidates'] ?? 0;
    } catch (e) {
      LoggerService.logger?.e('Error occured in listBooking:\n$e');
    }
    return 0;
  }

  Future<void> updateBookingStatus(Booking booking, RequestStatus status) async {
    try {
      await ApiBaseHelper().request(
        RequestType.post,
        '/booking/update-status',
        sendToken: true,
        body: {'booking': booking.toJson(), 'status': status.name},
      );
      if (MainAppController.find.isConnected) BookingDatabaseRepository.find.updateBookingStatus(booking, status);
    } catch (e) {
      Helper.snackBar(message: 'An error has occurred');
      LoggerService.logger?.e('Error occured in listBooking:\n$e');
    }
  }

  Future<List<Booking>> getUserServicesHistory() async {
    try {
      List<Booking> bookings = [];
      if (MainAppController.find.isConnected) {
        final result = await ApiBaseHelper().request(RequestType.get, '/booking/services-history', sendToken: true);
        bookings = (result['formattedList'] as List).map((e) => Booking.fromJson(e)).toList();
      } else {
        bookings = await BookingDatabaseRepository.find.select();
      }
      if (bookings.isNotEmpty && MainAppController.find.isConnected) BookingDatabaseRepository.find.backupBookings(bookings);
      return bookings;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getUserServicesHistory:\n$e');
    }
    return [];
  }
}
