import '../review.dart';
import '../store.dart';

class StoreReviewDTO {
  final Store? store;
  final List<Review> reviews;

  StoreReviewDTO({required this.store, required this.reviews});

  factory StoreReviewDTO.fromJson(Map<String, dynamic> json) => StoreReviewDTO(
        store: json['store'] != null ? Store.fromJson(json['store']) : null,
        reviews: json['reviews'] != null ? (json['reviews'] as List).map((e) => Review.fromJson(e)).toList() : [],
      );
}
