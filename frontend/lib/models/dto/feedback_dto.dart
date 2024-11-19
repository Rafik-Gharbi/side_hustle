import '../../widgets/feedback_bottomsheet.dart';
import '../user.dart';

class FeedbackDTO {
  final int? id;
  final User? user;
  final FeedbackEmotion feedback;
  final String comment;
  final DateTime? createdAt;

  FeedbackDTO({
    this.id,
    required this.user,
    required this.feedback,
    required this.comment,
    this.createdAt,
  });

  factory FeedbackDTO.fromJson(Map<String, dynamic> json) => FeedbackDTO(
        id: json['id'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        feedback: FeedbackEmotion.values.singleWhere((element) => element.name == json['feedback']),
        comment: json['comment'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (user != null) data['user'] = user!.toJson();
    data['feedback'] = feedback.value;
    data['comment'] = comment;
    return data;
  }
}
