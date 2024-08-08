import '../../controllers/main_app_controller.dart';
import '../category.dart';
import '../user.dart';

class ProfileDTO {
  final User user;
  final List<Category> subscribedCategories;
  final DateTime nextUpdateGategory;
  final int myRequestActionRequired;
  final int taskHistoryActionRequired;
  final int myStoreActionRequired;
  final int approveUsersActionRequired;
  final int servieHistoryActionRequired;
  final bool userHasBoosts;

  ProfileDTO({
    required this.user,
    required this.subscribedCategories,
    required this.nextUpdateGategory,
    this.approveUsersActionRequired = 0,
    this.myRequestActionRequired = 0,
    this.myStoreActionRequired = 0,
    this.taskHistoryActionRequired = 0,
    this.servieHistoryActionRequired = 0,
    this.userHasBoosts = false,
  });

  factory ProfileDTO.fromJson(Map<String, dynamic> json) => ProfileDTO(
        user: User.fromJson(json['user']),
        subscribedCategories:
            json['subscribedCategories'] != null ? (json['subscribedCategories'] as List).map((e) => MainAppController.find.getCategoryById(e['category_id'])!).toList() : [],
        nextUpdateGategory: json['subscribedCategories'] != null && (json['subscribedCategories'] as List).isNotEmpty
            ? DateTime.parse(json['subscribedCategories'][0]['updatedAt']).add(const Duration(days: 30))
            : DateTime.now(),
        approveUsersActionRequired: json['approveUsersActionRequired'] ?? 0,
        myRequestActionRequired: json['myRequestActionRequired'] ?? 0,
        myStoreActionRequired: json['myStoreActionRequired'] ?? 0,
        taskHistoryActionRequired: json['taskHistoryActionRequired'] ?? 0,
        servieHistoryActionRequired: json['servieHistoryActionRequired'] ?? 0,
        userHasBoosts: json['userHasBoosts'] ?? false,
      );
}
