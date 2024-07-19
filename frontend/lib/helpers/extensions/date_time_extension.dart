import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatISOTime {
    final String timeZone =
        '${timeZoneOffset.isNegative ? '-' : '+'}${timeZoneOffset.inHours.toString().padLeft(2, '0')}:${(timeZoneOffset.inMinutes - (timeZoneOffset.inHours * 60)).toString().padLeft(2, '0')}';
    return '${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(this)}$timeZone';
  }

  String get formatDisplay => DateFormat('MMM d, h:mm a').format(this);

  bool isSameDate(DateTime other) => year == other.year && month == other.month && day == other.day;

  bool isSameMonth(DateTime other) => year == other.year && month == other.month;

  bool isBeforeEqualMonth(DateTime other) => year <= other.year && month <= other.month;

  DateTime normalize() => DateTime(year, month, day);

  DateTime toOneMinuteBeforeMidnight() => DateTime(year, month, day, 23, 59);
}
