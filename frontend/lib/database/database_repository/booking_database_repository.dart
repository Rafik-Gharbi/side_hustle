import 'package:get/get.dart';

import '../../models/booking.dart';
import '../../models/enum/request_status.dart';
import '../../models/service.dart';
import '../../services/logger_service.dart';
import '../database.dart';
import 'store_database_repository.dart';

class BookingDatabaseRepository extends GetxService {
  static BookingDatabaseRepository get find => Get.find<BookingDatabaseRepository>();
  final Database database = Database.getInstance();

  Future<List<Booking>> select() async {
    List<BookingTableData> result = await database.select(database.bookingTable).get();
    List<Booking> bookings = [];
    for (var booking in result) {
      final service = await StoreDatabaseRepository.find.getServiceById(booking.service!);
      final gallery = await StoreDatabaseRepository.find.getGalleryByServiceId(booking.service!);
      bookings.add(Booking.fromBookingData(booking: booking.toCompanion(true), service: Service.fromServiceData(service: service!, gallery: gallery)));
    }

    return bookings;
  }

  Future<Booking?> getBookingById(String bookingId) async {
    try {
      final BookingTableData booking = (await (database.select(database.bookingTable)..where((tbl) => tbl.id.equals(bookingId))).get()).first;
      final service = await StoreDatabaseRepository.find.getServiceById(booking.service!);
      final gallery = await StoreDatabaseRepository.find.getGalleryByServiceId(booking.service!);
      return Booking.fromBookingData(booking: booking.toCompanion(true), service: Service.fromServiceData(service: service!, gallery: gallery));
    } catch (e) {
      LoggerService.logger?.e(e);
      return null;
    }
  }

  Future<int> delete(Booking booking) async => await database.delete(database.bookingTable).delete(booking.toBookingCompanion());

  Future<int> deleteAll() async => await database.delete(database.bookingTable).go();

  Future<void> update(BookingTableCompanion bookingCompanion) async => await database.update(database.bookingTable).replace(bookingCompanion);

  Future<Booking?> insert(BookingTableCompanion bookingCompanion) async {
    final String bookingId = (await database.into(database.bookingTable).insert(bookingCompanion)).toString(); // TODO fix this
    final bookingBooking = await getBookingById(bookingId);
    return bookingBooking;
  }

  Future<void> backupBookings(List<Booking> bookings) async {
    LoggerService.logger?.i('Backing up bookings...');
    await deleteAll();
    for (var element in bookings) {
      await insert(element.toBookingCompanion());
    }
  }

  Future<void> updateBookingStatus(Booking booking, RequestStatus status) async {
    await update(booking.toBookingCompanion(statusUpdate: status));
  }

  Future<void> addBooking(Booking booking) async {
    await insert(booking.toBookingCompanion());
  }
}
