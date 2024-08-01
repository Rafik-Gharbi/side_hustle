import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../constants/shared_preferences_keys.dart';

import '../helpers/helper.dart';
import '../services/authentication_service.dart';
import '../services/logger_service.dart';
import '../services/shared_preferences.dart';
import '../services/theme/theme.dart';
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
const String baseUrlRealIos = 'http://172.20.10.7:3000'; // real device ip address
// const String baseUrlRemote = 'https://HustleMatch.net'; // remote
String _lastRequestedUrl = '';

class ApiBaseHelper extends GetxController {
  static ApiBaseHelper get find => Get.find<ApiBaseHelper>();
  // final String baseUrl = baseUrlRemote;
  final String baseUrl = kReleaseMode
      ? baseUrlRealIos //baseUrlRemote
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
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () {
      _defaultHeader.addAll({'locale': SharedPreferencesService.find.get(languageCodeKey) ?? 'en'});
    });
    String? token;
    if (sendToken) {
      token = getToken();
      _defaultHeader.remove('Authorization');
      _defaultHeader.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    final requestUrl = Uri.parse('$baseUrl$url');

    if (files != null && files.isNotEmpty) {
      final keyImage = imageName ?? (files.length > 1 ? 'gallery' : 'photo');
      LoggerService.logger!.i('API uploadFile, url $url');
      final imageUploadRequest = http.MultipartRequest(requestType.name.toUpperCase(), requestUrl);
      if (sendToken) imageUploadRequest.headers['Authorization'] = 'Bearer $token';

      for (var file in files) {
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
        for (var element in (body).keys) {
          if (body[element] != null) imageUploadRequest.fields.putIfAbsent(element, () => body[element].toString());
        }
      } else {
        LoggerService.logger!.w('uploadFile body is not a Map<String, dynamic>');
      }
      final streamedResponse = await imageUploadRequest.send();
      final responseData = await streamedResponse.stream.asBroadcastStream().bytesToString();
      response = http.Response(
        responseData,
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
        request: streamedResponse.request,
      );
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
            body: jsonEncode(body),
            headers: headers ?? _defaultHeader,
          );
          break;
        case RequestType.put:
          LoggerService.logger!.i('API Put, url $url');
          response = await http.put(
            requestUrl,
            body: body != null ? jsonEncode(body) : null,
            headers: headers ?? _defaultHeader,
          );
          break;
        case RequestType.delete:
          LoggerService.logger!.i('API Delete, url $url');
          response = await http.delete(
            requestUrl,
            body: body != null ? jsonEncode(body) : null,
            headers: headers ?? _defaultHeader,
          );
          break;
      }
    }
    isLoading = false;
    return _returnResponse(response);
  }

  String getImageTask(String pictureName) => '$baseUrl/public/task/$pictureName';
  String getImageStore(String pictureName) => '$baseUrl/public/store/$pictureName';
  String getImageLocal(String pictureName) => pictureName;
  String getUserImage(String pictureName) => '$baseUrl/public/images/user/$pictureName';

  dynamic _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        //LoggerService.logger!.i('API Return 200 OK, length: ${jsonDecode(response.body)['count']}');
        return jsonDecode(response.body);
      case 201:
        return response.statusCode;
      case 400:
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        if (response.body.contains('session_expired')) {
          if (kDebugMode) {
            Helper.snackBar(message: 'session_expired', title: 'login_msg', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
          }
          if (SharedPreferencesService.find.get(refreshTokenKey) != null) {
            final result = await AuthenticationService.find.renewToken();
            return result ? await request(RequestTypeExtension.fromString(response.request!.method), response.request!.url.path, body: response.body, sendToken: true) : null;
          } else {
            AuthenticationService.find.logout();
          }
        } else if (kDebugMode) {
          Helper.snackBar(
              message: jsonDecode(response.body)['message'].toString().tr,
              title: 'debug oups!',
              includeDismiss: false,
              styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
          throw UnauthorisedException(jsonDecode(response.body)['message'].toString());
        }
      case 404:
        if (kDebugMode) {
          Helper.snackBar(
              message: jsonDecode(response.body)['message'], title: 'debug oups!', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
        }
        throw NotFoundException(response.body.toString());
      case 406:
        if (kDebugMode) {
          Helper.snackBar(
              message: jsonDecode(response.body)['message'], title: 'debug oups!', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
        }
        throw UnauthorisedException(jsonDecode(response.body)['message'].toString());
      case 409:
        if (kDebugMode) {
          Helper.snackBar(
              message: jsonDecode(response.body)['message'], title: 'debug oups!', includeDismiss: false, styleMessage: AppFonts.x12Regular.copyWith(color: kErrorColor));
        }
        throw ConflictException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}\n${response.body}',
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

  Future<bool> checkConnectionToBackend() async {
    try {
      final response = await request(RequestType.get, '/params/check-connection');
      return response?['result'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
