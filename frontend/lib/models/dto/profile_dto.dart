import '../../controllers/main_app_controller.dart';
import '../category.dart';
import '../user.dart';

class ProfileDTO {
  final User user;
  final List<Category> subscribedCategories;
  final DateTime nextUpdateGategory;

  ProfileDTO({required this.user, required this.subscribedCategories, required this.nextUpdateGategory});

  factory ProfileDTO.fromJson(Map<String, dynamic> json) => ProfileDTO(
        user: User.fromJson(json['user']),
        subscribedCategories:
            json['subscribedCategories'] != null ? (json['subscribedCategories'] as List).map((e) => MainAppController.find.getCategoryById(e['category_id'])!).toList() : [],
        nextUpdateGategory: json['subscribedCategories'] != null && (json['subscribedCategories'] as List).isNotEmpty
            ? DateTime.parse(json['subscribedCategories'][0]['updatedAt']).add(const Duration(days: 30))
            : DateTime.now(),
      );
}
