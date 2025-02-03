import 'package:get/get.dart';

import '../constants/shared_preferences_keys.dart';
import '../services/authentication_service.dart';
import '../services/shared_preferences.dart';
import '../views/home/home_controller.dart';

class UserViewmodel {
  static RxBool isLoading = false.obs;

  static get searchMode {
    final savedSearchMode = SearchMode.values.cast<SearchMode?>().singleWhere((element) => element?.name == SharedPreferencesService.find.get(searchModeKey), orElse: () => null);
    return savedSearchMode ??
        (AuthenticationService.find.jwtUserData?.coordinates != null
            ? SearchMode.nearby
            : AuthenticationService.find.jwtUserData?.governorate != null
                ? SearchMode.regional
                : SearchMode.national);
  }
}
