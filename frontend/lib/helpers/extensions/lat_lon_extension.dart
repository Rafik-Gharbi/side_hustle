import 'package:latlong2/latlong.dart';

extension LatLangExtension on String {
  LatLng? fromString() {
    if (contains(',')) {
      final split = this.split(',');
      final latitude = double.tryParse(split[0]);
      final longitude = double.tryParse(split[1]);
      return latitude != null && longitude != null ? LatLng(latitude, longitude) : null;
    }
    return null;
  }
}

extension LatLngExtension on LatLng {
  String toCoordinatesString() {
    return '$latitude,$longitude';
  }
}
