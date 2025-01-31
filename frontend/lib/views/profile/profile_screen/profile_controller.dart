import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/shared_preferences_keys.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/category.dart';
import '../../../models/user.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/tutorials/profile_tutorial.dart';
import '../../../widgets/categories_bottomsheet.dart';
import '../../../widgets/draggable_bottomsheet.dart';

class ProfileController extends GetxController {
  static ProfileController get find => Get.find<ProfileController>();
  final ScrollController scrollController = ScrollController();
  User? loggedInUser;
  RxBool _isLoading = true.obs;
  XFile? profilePicture;
  bool _isUpdatingProfile = false;
  List<Category> subscribedCategories = [];
  DateTime? nextUpdateGategory;
  int myRequestActionRequired = 0;
  int myOffersActionRequired = 0;
  int myStoreActionRequired = 0;
  int approveUsersActionRequired = 0;
  int adminDashboardActionRequired = 0;
  bool userHasBoosts = false;
  List<TargetFocus> targets = [];
  GlobalKey profileHeaderKey = GlobalKey();
  GlobalKey verifyAccountKey = GlobalKey();
  GlobalKey subscribeCategoryKey = GlobalKey();
  GlobalKey createStoreKey = GlobalKey();
  GlobalKey referFriendKey = GlobalKey();

  RxBool get isLoading => _isLoading;
  bool get isUpdatingProfile => _isUpdatingProfile;

  set isUpdatingProfile(bool value) {
    _isUpdatingProfile = value;
    update();
  }

  set isLoading(RxBool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
  }

  static final ProfileController _singleton = ProfileController._internal();

  factory ProfileController() => _singleton;

  ProfileController._internal() {
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedProfileTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => MainAppController.find.isProfileScreen, () {
          ProfileTutorial.showTutorial();
          update();
        });
      }
    });
    init();
  }

  Future<void> init() async {
    final result = await AuthenticationService.find.fetchUserData();
    if (result != null) {
      loggedInUser = result.user;
      AuthenticationService.find.jwtUserData = loggedInUser;
      subscribedCategories = result.subscribedCategories;
      nextUpdateGategory = result.nextUpdateGategory;
      myRequestActionRequired = result.myRequestActionRequired;
      myOffersActionRequired = result.myOffersActionRequired;
      myStoreActionRequired = result.myStoreActionRequired;
      approveUsersActionRequired = result.approveUsersActionRequired;
      adminDashboardActionRequired = result.adminDashboardActionRequired;
      userHasBoosts = result.userHasBoosts;
      MainAppController.find.resolveProfileActionRequired();
      update();
    }
    if (!MainAppController.find.isBackReachable.value) ApiBaseHelper.find.isLoading = false;
    isLoading.value = false;
  }

  Future<void> uploadFilePicture({GlobalKey<FormState>? formKey}) async {
    try {
      XFile? image = await Helper.pickImage();
      if (image != null) {
        profilePicture = image;
        saveProfileInfo(isPictureUpload: true, formKey: formKey);
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadFilePicture:\n$e');
    }
  }

  Future<void> saveProfileInfo({required GlobalKey<FormState>? formKey, bool isPictureUpload = false, User? updatedUserData}) async {
    if (formKey?.currentState?.validate() ?? false || isPictureUpload) {
      // String? phone = loggedInUser!.phone;
      // bool phoneHasBeenChanged = Helper.isNullOrEmpty(loggedInUser?.phone) && phoneController.text.isNotEmpty ||
      //     prefix != null && loggedInUser!.phone != prefix! + phoneController.text.replaceAll(' ', '');
      // if (phoneHasBeenChanged) phone = prefix! + phoneController.text.replaceAll(' ', '');
      isUpdatingProfile = true;
      final updatedUser = await UserRepository.find.updateUser(
        isPictureUpload ? loggedInUser! : updatedUserData!,
        picture: profilePicture,
      );
      if (updatedUser != null) {
        // if (phoneHasBeenChanged) Helper.otpProcess(phone, loggedInUser!.email);
        loggedInUser = updatedUser;
        profilePicture = null;
      }
      isUpdatingProfile = false;
    }
  }

  Future<void> subscribeToCategories(List<Category> categories) async {
    String? fcmToken;
    final permission = await FirebaseMessaging.instance.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e, s) {
        LoggerService.logger?.e('Error in subscribeToCategories!\nError: $e\nStacktrace: $s');
      }
    }
    Helper.openConfirmationDialog(
      content: 'confirm_category_subscription_msg'.trParams({
        'categoriesName': categories.map((e) => e.name).toString(),
        'nextUpdate': Helper.formatDate(DateTime.now().add(const Duration(days: 30))),
      }),
      onConfirm: () async {
        final result = await AuthenticationService.find.subscribeToCategories(categories, fcmToken);
        if (result) init();
      },
    );
    init();
  }

  void manageCategoriesSubscription() {
    void openCategoriesBottomsheet() => Get.bottomSheet(
          DraggableBottomsheet(
            child: CategoriesBottomsheet(
              maxSelect: 3,
              nextUpdate: nextUpdateGategory,
              selected: subscribedCategories,
              onSelectCategory: (category) => subscribeToCategories(category),
            ),
          ),
          isScrollControlled: true,
        );
    subscribedCategories.isEmpty
        ? Helper.openConfirmationDialog(
            title: 'subscribe_to_categories'.tr,
            content: 'subscribe_categories_msg'.tr,
            onConfirm: () async {
              NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(criticalAlert: true);
              debugPrint('User granted permission: ${settings.authorizationStatus}');
              if (settings.authorizationStatus == AuthorizationStatus.authorized) {
                openCategoriesBottomsheet();
              }
            },
          )
        : openCategoriesBottomsheet();
  }
}
