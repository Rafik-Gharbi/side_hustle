import '../helpers/helper.dart';
import 'dto/image_dto.dart';
import 'user.dart';

class Review {
  final String? id;
  final double rating;
  final String? message;
  final ImageDTO? picture;
  final double? quality;
  final double? fees;
  final double? punctuality;
  final double? politeness;
  final User? user;
  final User? reviewee;
  final DateTime? createdAt;

  Review({
    this.id,
    required this.rating,
    required this.message,
    required this.picture,
    required this.quality,
    required this.fees,
    required this.punctuality,
    required this.politeness,
    this.user,
    this.reviewee,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        message: json['message'],
        user: User.fromJson(json['user']),
        reviewee: User.fromJson(json['reviewee']),
        rating: Helper.resolveDouble(json['rating']),
        quality: Helper.resolveDouble(json['quality']),
        fees: Helper.resolveDouble(json['fees']),
        punctuality: Helper.resolveDouble(json['punctuality']),
        politeness: Helper.resolveDouble(json['politeness']),
        picture: json['picture'] != null ? ImageDTO.fromJson(json['picture']) : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['message'] = message;
    data['quality'] = quality;
    data['fees'] = fees;
    data['punctuality'] = punctuality;
    data['politeness'] = politeness;
    data['rating'] = rating;
    data['user_id'] = user?.id;
    data['picture'] = picture;
    return data;
  }
}
