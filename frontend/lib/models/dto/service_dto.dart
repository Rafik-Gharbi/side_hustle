import '../service.dart';
import '../store.dart';

class ServiceDTO {
  final Service? service;
  final Store? store;

  ServiceDTO({required this.service, required this.store});

  factory ServiceDTO.fromJson(Map<String, dynamic> json) => ServiceDTO(
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
        store: json['store'] != null ? Store.fromJson(json['store']) : null,
      );
}
