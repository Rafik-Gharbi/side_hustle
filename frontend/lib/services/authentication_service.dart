import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:latlong2/latlong.dart';

import '../constants/shared_preferences_keys.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/dto/profile_dto.dart';
import '../models/governorate.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../views/chat/chat_controller.dart';
import '../views/chat/components/messages_screen.dart';
import '../views/profile/profile_screen/profile_controller.dart';
import '../views/settings/components/privacy_policy_screen.dart';
import '../views/settings/components/terms_condition_screen.dart';
import 'logger_service.dart';
import 'shared_preferences.dart';

enum ForgotPasswordStep { sendEmail, changePassword }

enum LoginWidgetState {
  login,
  signup,
  forgotPassword;

  bool get isSignUp => this == LoginWidgetState.signup;
  bool get isLogin => this == LoginWidgetState.login;
  bool get isChangePassword => this == LoginWidgetState.forgotPassword;
}

class AuthenticationService extends GetxController {
  static AuthenticationService get find => Get.find<AuthenticationService>();
  final GlobalKey<FormState> formLoginKey = GlobalKey();
  final GlobalKey<FormState> formSignupKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController validationKeyController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  late GoogleSignIn _googleSignIn;
  ForgotPasswordStep _screenState = ForgotPasswordStep.sendEmail;
  LoginWidgetState _currentState = LoginWidgetState.login;
  bool _isPhoneInput = true;
  RxBool sendingEmail = false.obs;
  bool stayLoggedIn = false;
  bool _firstMailSent = false;
  RxBool isLoggingIn = false.obs;
  bool _chatRoomInitiated = false;
  bool isReady = false;
  String? phoneNumber;
  Gender? _gender;
  Governorate? _governorate;
  LatLng? _coordinates;
  RxBool isLoading = false.obs;
  RxBool isGettingCoordinates = false.obs;
  RxBool isUpdatingProfile = false.obs;
  RxBool acceptedTermsPrivacy = false.obs;

  // Available logged in user data from JWT token
  bool? isUserMailVerified;
  User? _jwtUserData;

  bool get isPhoneInput => _isPhoneInput;

  RxBool get isUserLoggedIn => (isReady ? _jwtUserData != null : false).obs;

  User? get jwtUserData {
    final savedToken = SharedPreferencesService.find.get(jwtKey);
    if (isUserLoggedIn.value && _jwtUserData == null && savedToken != null) {
      _jwtUserData = User.fromToken(JwtDecoder.decode(savedToken));
    }
    return _jwtUserData;
  }

  LoginWidgetState get currentState => _currentState;

  bool get firstMailSent => _firstMailSent;

  bool get isLoggedIn => _jwtUserData != null;

  ForgotPasswordStep get screenState => _screenState;

  Gender? get gender => _gender;

  Governorate? get governorate => _governorate;

  LatLng? get coordinates => _coordinates;

  set coordinates(LatLng? value) {
    _coordinates = value;
    update();
  }

  set governorate(Governorate? value) {
    _governorate = value;
    update();
  }

  set gender(Gender? value) {
    _gender = value;
    update();
  }

  set screenState(ForgotPasswordStep value) {
    _screenState = value;
    update();
  }

  set firstMailSent(bool value) {
    _firstMailSent = value;
    if (_firstMailSent) sendingEmail.value = false;
    update();
  }

  set currentState(LoginWidgetState value) {
    _currentState = value;
    update();
  }

  set isPhoneInput(bool value) {
    _isPhoneInput = value;
    update();
  }

  set jwtUserData(User? value) {
    _jwtUserData = value;
    update();
  }

  AuthenticationService() {
    _googleSignIn = GoogleSignIn(
      clientId: GetPlatform.isIOS || GetPlatform.isMacOS ? dotenv.env['GOOGLE_CLIENT_ID_IOS']! : null,
      scopes: ['email', 'openid', 'profile'],
    );
    // Check if exist a saved token and relogin the user
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value && MainAppController.find.isReady, () async {
      final savedToken = SharedPreferencesService.find.get(jwtKey);
      if (savedToken != null) {
        final jwtPayload = JwtDecoder.decode(savedToken);
        final isTokenExpired = JwtDecoder.isExpired(savedToken);
        isUserMailVerified = jwtPayload['isMailVerified'];
        if ((isUserMailVerified ?? false) && !isTokenExpired) {
          initiateCurrentUser(savedToken);
          // init chat messages standBy room
          _initChatStandByRoom();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
        }
      } else if (_googleSignIn.currentUser != null) {
        _silentGoogleLogin();
      } else {
        _checkIfFacebookUserIsLogged();
      }
      isReady = true;
    });
  }

  void updateToken({required String token}) {
    final jwtPayload = JwtDecoder.decode(token);
    _jwtUserData = User.fromToken(jwtPayload);
  }

  Future<ProfileDTO?> fetchUserData() async {
    return await Helper.waitAndExecute(
      () => SharedPreferencesService.find.isReady.value,
      () async {
        final loggedInUser = await UserRepository.find.getLoggedInUser();
        if (loggedInUser?.user.id != null) {
          if (MainAppController.find.isConnected) {
            isUserMailVerified = await UserRepository.find.checkVerifiedUser();
          } else {
            isUserMailVerified = loggedInUser?.user.isMailVerified;
          }
        }
        return loggedInUser;
      },
    );
  }

  Future<Map<String, String?>?> signInWithGoogle({bool isLinking = false, bool isSignUp = false}) async {
    try {
      isLoggingIn.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser?.id != null) {
        return _silentGoogleLogin(isLinking: isLinking, isSignUp: isSignUp);
      } else {
        LoggerService.logger?.e('Sign-in with Google failed due to unknown reason.'); // Handle failed sign-in
      }
    } catch (error) {
      Helper.snackBar(message: 'error_occurred'.tr);
      LoggerService.logger?.e('Error: $error'); // Handle general errors
    }
    isLoggingIn.value = false;
    return null;
  }

  Future<Map<String, String?>?> facebookLogin({bool isLinking = false, bool isSignUp = false}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        return await _silentFacebookLogin(isLinking: isLinking, isSignUp: isSignUp);
      } else {
        LoggerService.logger?.e('Error occured with Facebook login status: ${result.status}\nError message: ${result.message}');
        return null;
      }
    } catch (e) {
      Helper.snackBar(message: 'error_occurred'.tr);
      LoggerService.logger?.e('Error: $e');
    }
    return null;
  }

  Future<void> logout() async {
    bool isFacebookLoggedIn = false;
    try {
      isFacebookLoggedIn = (await FacebookAuth.instance.accessToken) != null;
    } catch (e) {
      LoggerService.logger?.e('Error: $e');
    }
    if (_googleSignIn.currentUser != null) await _googleLogout();
    if (isFacebookLoggedIn) await _facebookLogout();
    try {
      ChatController.find.clear();
    } catch (e) {
      LoggerService.logger?.i('Chat controller is not initialized');
    }
    final sharedPreferencesService = SharedPreferencesService.find;
    final mainAppController = MainAppController.find;
    sharedPreferencesService.removeKey(jwtKey);
    sharedPreferencesService.removeKey(refreshTokenKey);
    mainAppController.notSeenNotifications.value = 0;
    mainAppController.profileActionRequired.value = 0;
    mainAppController.notSeenMessages.value = 0;
    mainAppController.socket?.disconnect();
    _jwtUserData = null;
    _chatRoomInitiated = false;
    isLoggingIn.value = false;
    update();
  }

  Future<void> classicLogin() async {
    if (formLoginKey.currentState?.validate() ?? false) {
      isLoggingIn.value = true;
      final user = User(
        email: emailController.text,
        phone: phoneNumber,
        password: passwordController.text,
      );
      await _handleLogin(user);
    }
  }

  Future<void> signUpUser({User? user}) async {
    if (user == null && (formSignupKey.currentState?.validate() ?? false) || user != null) {
      isLoggingIn.value = true;
      user ??= User(
        name: nameController.text.isEmpty ? null : nameController.text,
        email: emailController.text.isEmpty ? null : emailController.text,
        password: passwordController.text,
        birthdate: birthdateController.text.isNotEmpty ? DateFormat('yyyy-MM-dd').parse(birthdateController.text) : null,
        gender: gender,
        governorate: governorate,
        phone: Helper.isNullOrEmpty(phoneNumber) ? null : phoneNumber,
        coordinates: coordinates,
        hasSharedPosition: coordinates != null,
        referralCode: referralCodeController.text,
        language: Get.locale?.languageCode,
      );
      final jwt = await UserRepository.find.signup(user: user);
      await FirebaseAnalytics.instance.logEvent(
        name: 'sign_up',
        parameters: {
          'referee': referralCodeController.text.isNotEmpty,
          'method': user.getSignupMethod,
        },
      );
      isLoggingIn.value = false;
      if (jwt != null) {
        Helper.goBack();
        // if (!Helper.isNullOrEmpty(phoneNumber)) {
        // Phone number OTP process
        // await Helper.otpProcess(phoneNumber, user.email);
        // Email verification Dialog
        // Get.dialog(const VerifyEmailDialog()).then((value) {
        //   clearFormFields();
        //   if (GetPlatform.isMobile) {
        //     Helper.mobileEmailVerification(user?.email);
        //   } else {
        //     Helper.goBack();;
        //   }
        // });
        // } else {
        // Email verification Dialog
        clearFormFields();
        initiateCurrentUser(jwt);
        await Helper.mobileEmailVerification(user.email);
      }
    } else {
      Helper.snackBar(message: 'check_your_inputs'.tr);
    }
  }

  void clearFormFields() {
    nameController.text = '';
    emailController.text = '';
    phoneController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    birthdateController.text = '';
    phoneNumber = null;
    governorate = null;
    gender = null;
    _currentState = LoginWidgetState.login;
    isLoggingIn.value = false;
    acceptedTermsPrivacy.value = false;
    _isPhoneInput = true;
    resetForgotPassword();
  }

  void resetForgotPassword() {
    emailController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    validationKeyController.text = '';
    _currentState = LoginWidgetState.login;
    _screenState = ForgotPasswordStep.sendEmail;
    _firstMailSent = false;
    sendingEmail.value = false;
  }

  Future<void> _facebookLogout() async => await FacebookAuth.instance.logOut();

  Future<void> _googleLogout() async {
    await _googleSignIn.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> _checkIfFacebookUserIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) _silentFacebookLogin();
  }

  Map<String, String?>? _silentGoogleLogin({bool isLinking = false, bool isSignUp = false}) {
    final googleUser = User(
      email: _googleSignIn.currentUser!.email,
      name: _googleSignIn.currentUser!.displayName,
      picture: _googleSignIn.currentUser!.photoUrl,
      googleId: _googleSignIn.currentUser!.id,
    );
    if (isSignUp) {
      signUpUser(user: googleUser);
    } else {
      if (!isLinking) _handleLogin(googleUser);
    }
    return {'googleId': googleUser.googleId, 'email': googleUser.email, 'name': googleUser.name, 'picture': googleUser.picture};
  }

  Future<Map<String, String?>?> _silentFacebookLogin({bool isLinking = false, bool isSignUp = false}) async {
    final userData = await FacebookAuth.instance.getUserData();
    final facebookUser = User(
      email: userData['email'],
      name: userData['name'],
      picture: userData['picture']['data']['url'],
      facebookId: userData['id'],
    );
    if (isSignUp) {
      signUpUser(user: facebookUser);
    } else {
      if (!isLinking) _handleLogin(facebookUser);
    }
    return {'facebookId': facebookUser.facebookId, 'email': facebookUser.email, 'name': facebookUser.name};
  }

  Future<void> _handleLogin(User user) async {
    final loginResponse = await UserRepository.find.login(user: user);
    await FirebaseAnalytics.instance.logEvent(
      name: 'login',
      parameters: {
        'method': user.getSignupMethod,
      },
    );
    isLoggingIn.value = false;
    if (loginResponse?.token != null) {
      if (loginResponse?.refreshToken != null) {
        SharedPreferencesService.find.add(refreshTokenKey, loginResponse!.refreshToken!);
      }
      initiateCurrentUser(loginResponse?.token, user: user);
      if (!(isUserMailVerified ?? false)) {
        Helper.mobileEmailVerification(user.email);
      }
    } else {
      logout();
    }
  }

  void initiateCurrentUser(String? jwt, {User? user, bool silent = false}) {
    if (jwt != null) {
      final jwtPayload = JwtDecoder.decode(jwt);
      final isTokenExpired = JwtDecoder.isExpired(jwt);
      isUserMailVerified = jwtPayload['isMailVerified'];
      if (!isTokenExpired) {
        SharedPreferencesService.find.add(jwtKey, jwt);
        final userFromToken = User.fromToken(jwtPayload);
        _jwtUserData ??= user ?? userFromToken;
        jwtUserData?.id = userFromToken.id;
        jwtUserData?.role = userFromToken.role;
        jwtUserData?.governorate = userFromToken.governorate;
        jwtUserData?.name = userFromToken.name;
        jwtUserData?.language = userFromToken.language;
        jwtUserData?.balance = userFromToken.balance;
        jwtUserData?.baseCoins = userFromToken.baseCoins;
        jwtUserData?.availableCoins = userFromToken.availableCoins;
        jwtUserData?.availablePurchasedCoins = userFromToken.availablePurchasedCoins;
        jwtUserData?.referralCode = userFromToken.referralCode;
        jwtUserData?.picture = userFromToken.picture;
        jwtUserData?.isVerified = userFromToken.isVerified;
        jwtUserData?.isMailVerified = userFromToken.isMailVerified;
        jwtUserData?.hasSharedPosition = userFromToken.hasSharedPosition;
        jwtUserData?.password = null;
        isLoggingIn.value = true;
      }
      // init chat messages standBy room
      _initChatStandByRoom();
      if (jwtUserData?.language != null && jwtUserData?.language != Get.locale?.languageCode) {
        MainAppController.find.changeLanguage(languageCode: jwtUserData!.language);
      }
      if (!silent) {
        if (MainAppController.find.isProfileScreen) ProfileController.find.init();
        if ((Get.isDialogOpen ?? false) || (Get.isBottomSheetOpen ?? false)) Helper.goBack();
      }
      // update guest user data with user id
      if (SharedPreferencesService.find.get(guestIdKey) != null && jwtUserData?.id != null) {
        UserRepository.find.updateGuestData(guestId: Helper.getOrCreateGuestId()).then((status) => status ? SharedPreferencesService.find.removeKey(guestIdKey) : null);
      }
      update();
    }
  }

  Future<void> updateUserData() async {
    if ((formSignupKey.currentState?.validate() ?? false) && (nameController.text.isNotEmpty || emailController.text.isNotEmpty || phoneNumber != null)) {
      isUpdatingProfile.value = true;
      await UserRepository.find.updateUser(
        User(
          id: _jwtUserData!.id,
          name: nameController.text,
          email: emailController.text,
          phone: phoneNumber,
          governorate: governorate,
          gender: gender,
          coordinates: coordinates,
          hasSharedPosition: coordinates != null,
          birthdate: birthdateController.text.isNotEmpty ? DateFormat('yyyy-MM-dd').parse(birthdateController.text) : null,
        ),
        withBack: true,
      );
      isUpdatingProfile.value = false;
    }
  }

  Future<void> forgotPassword() async {
    if (formSignupKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      await UserRepository.find.forgotPassword(passwordController.text, validationKeyController.text);
      resetForgotPassword();
      isLoading.value = false;
    }
  }

  Future<void> sendVerificationKey() async {
    if (formSignupKey.currentState?.validate() ?? false) {
      sendingEmail.value = true;
      final success = await UserRepository.find.sendChangePasswordCode(emailController.text);
      firstMailSent = true;
      if (success) screenState = ForgotPasswordStep.changePassword;
    }
  }

  void loadUserData(User? user) {
    emailController.text = user?.email ?? '';
    nameController.text = user?.name ?? '';
    birthdateController.text = user?.birthdate != null ? Helper.formatDate(user!.birthdate!) : '';
    phoneNumber = user?.phone;
    _governorate = user?.governorate;
    _gender = user?.gender;
    _coordinates = user?.coordinates;
    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  Future<bool> renewToken() async {
    final savedRefreshToken = SharedPreferencesService.find.get(refreshTokenKey);
    if (savedRefreshToken != null) {
      final isRefreshTokenExpired = JwtDecoder.isExpired(savedRefreshToken);
      if (isRefreshTokenExpired) {
        logout();
      } else {
        final Map<String, dynamic> refreshToken = {refreshTokenKey: savedRefreshToken};
        final loginDTO = await UserRepository.find.renewJWT(token: refreshToken);
        if (loginDTO?.refreshToken != null) {
          SharedPreferencesService.find.add(refreshTokenKey, loginDTO!.refreshToken!);
          try {
            final jwtPayload = JwtDecoder.decode(loginDTO.token ?? '');
            _jwtUserData = User.fromToken(jwtPayload);
          } catch (e) {
            Helper.snackBar(title: 'oups'.tr, message: 'session_expired'.tr);
          }
          initiateCurrentUser(loginDTO.token);
          return true;
        }
      }
    } else {
      SharedPreferencesService.find.removeKey(jwtKey);
    }
    logout();
    return false;
  }

  Future<void> changePassword(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      await UserRepository.find.changePassword(newPasswordController.text, currentPasswordController.text);
      isLoading.value = false;
    }
  }

  Future<bool> subscribeToCategories(List<Category> category, String? fcmToken) async {
    final result = await UserRepository.find.subscribeToCategories(category, fcmToken);
    if (result) {
      Helper.snackBar(message: 'categories_subscription_updated'.tr);
      return true;
    } else {
      Helper.snackBar(message: 'categories_subscription_failed'.tr);
      return false;
    }
  }

  Future<void> getUserCoordinates({bool withSave = false}) async {
    isGettingCoordinates.value = true;
    coordinates = await Helper.getPosition();
    if (withSave) {
      final user = AuthenticationService.find.jwtUserData;
      if (coordinates != null && Helper.shouldUpdateCoordinates(user!.coordinates, coordinates!)) {
        user.coordinates = coordinates;
        await UserRepository.find.updateUserCoordinates(user, silent: true);
      }
    }
    isGettingCoordinates.value = false;
    if (coordinates != null) Helper.snackBar(message: 'location_successfully_shared'.tr);
  }

  void _initChatStandByRoom() {
    // init chat messages standBy room
    if (_chatRoomInitiated) return;
    _chatRoomInitiated = true;
    if (_jwtUserData == null) return;
    if (MainAppController.find.socket == null) MainAppController.find.initSocket();
    MainAppController.find.socket!.emit('standBy', {'userId': _jwtUserData!.id});
    MainAppController.find.socket!.on('notification', (data) {
      // Show a notification to the user if not in the chat tab
      final notification = NotificationModel.fromJson(data['notification']);
      if (!MainAppController.find.isChatScreen && Get.currentRoute != MessagesScreen.routeName) {
        Helper.showNotification(notification);
      } else if (MainAppController.find.isChatScreen || Get.currentRoute == MessagesScreen.routeName) {
        ChatController.find.getUserChatHistory();
      }
      MainAppController.find.getNotSeenNotifications();
      MainAppController.find.getNotSeenMessages();
    });
    MainAppController.find.getNotSeenNotifications();
    MainAppController.find.resolveProfileActionRequired();
  }

  void openTerms() => Get.toNamed(TermsConditionScreen.routeName);

  void openPrivacy() => Get.toNamed(PrivacyPolicyScreen.routeName);
}
