import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants/colors.dart';
import '../constants/shared_preferences_keys.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../main.dart';
import '../services/authentication_service.dart';
import '../services/logger_service.dart';
import '../services/shared_preferences.dart';
import '../services/theme/theme.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/main_screen_with_bottom_navigation.dart';
import 'api_exceptions.dart';

enum RequestType { get, post, delete, put }

extension RequestTypeExtension on RequestType {
  static RequestType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'get':
        return RequestType.get;
      case 'post':
        return RequestType.post;
      case 'delete':
        return RequestType.delete;
      case 'put':
        return RequestType.put;
      default:
        return RequestType.get;
    }
  }
}

const String baseUrlLocalWeb = 'http://localhost:3000'; // web localhost
const String baseUrlLocalAndroid = 'http://10.0.2.2:3000'; // android localhost
const String baseUrlLocalIos = 'http://127.0.0.1:3000'; // ios localhost
const String baseUrlRealDevice = 'http://192.168.1.23:3000'; // 'http://172.20.10.2:3000'; // real device ip address
const String baseUrlRemote = 'https://api.dootify.com'; // remote
String _lastRequestedUrl = '';

class ApiBaseHelper extends GetxController {
  static ApiBaseHelper get find => Get.find<ApiBaseHelper>();
  static bool _isBlockingRenew = false;
  bool changeIpAddressOpened = false;
  // String baseUrl = baseUrlRemote;
  String baseUrl = kReleaseMode
      ? baseUrlRemote
      : kIsWeb
          ? baseUrlLocalWeb
          : GetPlatform.isAndroid
              ? baseUrlLocalAndroid
              : GetPlatform.isIOS
                  ? baseUrlLocalIos
                  : '';
  bool _isLoading = false;
  bool blockRequest = false;
  final _defaultHeader = {
    'Access-Control-Allow-Origin': '*', // Required for CORS support to work
    'Access-Control-Allow-Credentials': 'true', // Required for cookies, authorization headers with HTTPS
    'Access-Control-Allow-Headers': 'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
    'Access-Control-Allow-Methods': 'GET, PUT, POST, DELETE',
    'Content-type': 'application/json',
    'charset': 'UTF-8',
  };

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  String? getToken() => SharedPreferencesService.find.get(jwtKey);

  Future<dynamic> request(
    RequestType requestType,
    String url, {
    Map<String, String>? headers,
    dynamic body,
    List<XFile?>? files,
    String? imageName,
    bool sendToken = false,
  }) async {
    if (url == _lastRequestedUrl) LoggerService.logger?.w('Duplicated Request $url');
    _lastRequestedUrl = url;
    late http.Response response;
    isLoading = true;
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      _defaultHeader.addAll({'locale': SharedPreferencesService.find.get(languageCodeKey) ?? 'en'});
    });
    String? token;
    if (sendToken) {
      token = getToken();
      _defaultHeader.remove('Authorization');
      if (!Helper.isNullOrEmpty(token)) _defaultHeader.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    final savedBaseUrl = SharedPreferencesService.find.get(baseUrlKey);
    if (savedBaseUrl != null) baseUrl = savedBaseUrl;
    final requestUrl = Uri.parse('$baseUrl$url');

    if (files != null && files.isNotEmpty) {
      LoggerService.logger!.i('API uploadFile, url $url');
      final imageUploadRequest = http.MultipartRequest(requestType.name.toUpperCase(), requestUrl);
      imageUploadRequest.headers['Content-Type'] = 'multipart/form-data';
      if (sendToken) imageUploadRequest.headers['Authorization'] = 'Bearer $token';

      for (var file in files) {
        String keyImage = imageName ??
            (file?.mimeType == 'txt'
                ? 'logFile'
                : files.length > 1
                    ? 'gallery'
                    : 'photo');
        Uint8List fileBytes;
        // if file is loaded from user device it should work just fine,
        // else if the file has came from the server it should get loaded by getImageBytesFromNetwork method
        try {
          fileBytes = await file!.readAsBytes();
        } catch (e) {
          fileBytes = await getImageBytesFromNetwork(file!.path);
        }
        String filename = file.name;

        imageUploadRequest.files.add(http.MultipartFile.fromBytes(keyImage, fileBytes.toList(), filename: filename));
      }
      if (body is Map<String, dynamic>) {
        Map<String, dynamic> bodyData = {};
        for (var element in (body).keys) {
          if (body[element] != null) bodyData.putIfAbsent(element, () => body[element].toString());
        }
        if (bodyData.isNotEmpty) {
          imageUploadRequest.fields.putIfAbsent('encryptedData', () => Helper.encryptData(jsonEncode(bodyData)));
        }
      } else {
        LoggerService.logger!.w('uploadFile body is not a Map<String, dynamic>');
      }
      try {
        final streamedResponse = await imageUploadRequest.send();
        final responseData = await streamedResponse.stream.bytesToString();
        response = http.Response(
          responseData,
          streamedResponse.statusCode,
          headers: streamedResponse.headers,
          isRedirect: streamedResponse.isRedirect,
          persistentConnection: streamedResponse.persistentConnection,
          reasonPhrase: streamedResponse.reasonPhrase,
          request: streamedResponse.request,
        );
      } catch (e) {
        LoggerService.logger!.w('Error occured in uploadFile request:\n$e');
      }
    } else {
      switch (requestType) {
        case RequestType.get:
          LoggerService.logger!.i('API Get, url $url');
          response = await http.get(
            requestUrl,
            headers: headers ?? _defaultHeader,
          );
          break;
        case RequestType.post:
          LoggerService.logger!.i('API Post, url $url');
          response = await http.post(
            requestUrl,
            body: body != null ? jsonEncode(Map.of({'encryptedData': Helper.encryptData(jsonEncode(body))})) : null,
            headers: headers ?? _defaultHeader,
          );
          break;
        case RequestType.put:
          LoggerService.logger!.i('API Put, url $url');
          response = await http.put(
            requestUrl,
            body: body != null ? jsonEncode(Map.of({'encryptedData': Helper.encryptData(jsonEncode(body))})) : null,
            headers: headers ?? _defaultHeader,
          );
          break;
        case RequestType.delete:
          LoggerService.logger!.i('API Delete, url $url');
          response = await http.delete(
            requestUrl,
            body: body != null ? jsonEncode(Map.of({'encryptedData': Helper.encryptData(jsonEncode(body))})) : null,
            headers: headers ?? _defaultHeader,
          );
          break;
      }
    }
    isLoading = false;
    return _returnResponse(response);
  }

  String getImageTask(String pictureName) => '$baseUrl/public/task/$pictureName';
  String getImageDepositSlip(String pictureName) => '$baseUrl/public/deposit/$pictureName';
  String getImageStore(String pictureName) => '$baseUrl/public/store/$pictureName';
  String getImageLocal(String pictureName) => pictureName;
  String getUserImage(String pictureName) => '$baseUrl/public/images/user/$pictureName';
  String getLogs(String pictureName, String type) => '$baseUrl/public/support_attachments/${type == 'log' ? 'logs' : type == 'image' ? 'images' : 'documents'}/$pictureName';
  String getCategoryImage(String pictureName) => '$baseUrl/public/images/category/$pictureName';

  dynamic _returnResponse(http.Response response) async {
    dynamic body;
    try {
      body = Helper.decryptData(response.body);
    } catch (e) {
      body = response.body;
    }
    switch (response.statusCode) {
      case 200:
        //LoggerService.logger!.i('API Return 200 OK, length: ${jsonDecode(body)['count']}');
        try {
          return jsonDecode(body);
        } catch (e) {
          return response;
        }
      case 201:
        return response.statusCode;
      case 400:
        throw BadRequestException(jsonDecode(body)['message']);
      case 401:
        throw UnauthorisedException(body.toString());
      case 403:
        if (body.contains('session_expired')) {
          if (!_isBlockingRenew) {
            _isBlockingRenew = true;
            if (kDebugMode) {
              // Helper.snackBar(message: 'session_expired', title: 'login_msg', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
            }
            if (SharedPreferencesService.find.get(refreshTokenKey) != null) {
              final result = await AuthenticationService.find.renewToken();
              return result ? await request(RequestTypeExtension.fromString(response.request!.method), response.request!.url.path, body: body, sendToken: true) : null;
            } else {
              AuthenticationService.find.logout();
            }
            Future.delayed(const Duration(seconds: 30), () => _isBlockingRenew = false);
          }
        } else if (kDebugMode) {
          // Helper.snackBar(
          // message: jsonDecode(body)['message'].toString().tr,
          // title: 'debug oups!',
          // includeDismiss: false,
          // styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
          throw UnauthorisedException(jsonDecode(body)['message'].toString());
        }
      case 404:
        if (kDebugMode) {
          // Helper.snackBar(
          // message: jsonDecode(body)['message'], title: 'debug oups!', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
        }
        throw NotFoundException(body.toString());
      case 406:
        if (kDebugMode) {
          // Helper.snackBar(
          // message: jsonDecode(body)['message'], title: 'debug oups!', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
        }
        throw UnauthorisedException(jsonDecode(body)['message'].toString());
      case 409:
        if (kDebugMode) {
          // Helper.snackBar(
          // message: jsonDecode(body)['message'], title: 'debug oups!', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
        }
        throw ConflictException(body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}\n$body',
        );
    }
  }

  Future<Uint8List> getImageBytesFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<(bool, String?)> checkConnectionToBackend() async {
    // ignore: avoid_print
    if (!changeIpAddressOpened) {
      changeIpAddressOpened = true;
      // ignore: avoid_print
      print('baseUrl: $baseUrl');
      void openIPAddressChanger() {
        Helper.waitAndExecute(
          () => SharedPreferencesService.find.isReady.value && Get.currentRoute == MainScreenWithBottomNavigation.routeName,
          () => Get.bottomSheet(
            Material(
              color: kNeutralColor100,
              child: Padding(
                padding: const EdgeInsets.all(Paddings.large),
                child: Column(
                  children: [
                    const Center(child: Text('Change real device IP address', style: AppFonts.x15Bold)),
                    const SizedBox(height: Paddings.exceptional),
                    Text('Current baseURL: $baseUrl', style: AppFonts.x12Regular),
                    const SizedBox(height: Paddings.regular),
                    CustomTextField(
                      hintText: 'IP address e.g. 192.168.1.23',
                      onSubmitted: (value) {
                        baseUrl = 'http://$value:3000';
                        SharedPreferencesService.find.add(baseUrlKey, baseUrl);
                        RestartWidget.restartApp(Get.context!);
                        Helper.goBack();
                      },
                    ),
                    const SizedBox(height: Paddings.regular),
                    CustomTextField(
                      hintText: 'Or full address e.g. http://192.168.1.23:3000',
                      onSubmitted: (value) {
                        baseUrl = value;
                        SharedPreferencesService.find.add(baseUrlKey, baseUrl);
                        RestartWidget.restartApp(Get.context!);
                        Helper.goBack();
                      },
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    CustomButtons.elevatePrimary(
                      title: 'Cancel & Restart',
                      width: 200,
                      onPressed: () {
                        RestartWidget.restartApp(Get.context!);
                        Helper.goBack();
                      },
                    ),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                ),
              ),
            ),
          ).then((value) => changeIpAddressOpened = false),
        );
      }

      try {
        final response = await request(RequestType.get, '/params/check-connection');
        bool result = response?['result'] ?? false;
        if (!result) openIPAddressChanger();
        return (result, response?['version'] as String?);
      } catch (e) {
        openIPAddressChanger();
        return (false, null);
      }
    }
    return (false, null);
  }
}
