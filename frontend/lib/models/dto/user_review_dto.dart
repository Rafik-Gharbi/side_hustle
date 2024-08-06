import '../review.dart';
import '../user.dart';

class UserReviewDTO {
  final User user;
  final List<Review> reviews;

  UserReviewDTO({required this.user, required this.reviews});

  factory UserReviewDTO.fromJson(Map<String, dynamic> json) => UserReviewDTO(
        user: User.fromJson(json['user']),
        reviews: (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      );
}
