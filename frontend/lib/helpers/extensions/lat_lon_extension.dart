import 'package:latlong2/latlong.dart';

extension LatLangExtension on String {
  LatLng fromString() {
    return LatLng(double.parse(substring(0, indexOf(','))), double.parse(substring(indexOf(',') + 1)));
  }
}
extension LatLngExtension on LatLng {
  String toCoordinatesString() {
    return '$latitude,$longitude';
  }
}
