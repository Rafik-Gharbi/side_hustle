import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../models/chat.dart';
import '../models/dto/discussion_dto.dart';
import '../models/reservation.dart';
import '../networking/api_base_helper.dart';
import '../services/authentication_service.dart';
import '../services/logging/logger_service.dart';

class ChatRepository extends GetxService {
  static ChatRepository get find => Get.find<ChatRepository>();

  Future<(List<DiscussionDTO>?, List<Reservation>?)> getUserDiscussions({String? search}) async {
    try {
      if (AuthenticationService.find.isLoggedIn) {
        final result = await ApiBaseHelper().request(
          RequestType.get,
          '/chat/get-chat${search != null ? '?searchText=$search' : ''}',
          sendToken: true,
        );
        return (
          (result?['result'] as List?)?.map((e) => DiscussionDTO.fromJson(e)).toList(),
          (result?['reservations'] as List?)?.map((e) => Reservation.fromJson(e)).toList(),
        );
      }
      return (null, null);
    } catch (e) {
      LoggerService.logger?.e('Error occured in getChat:\n$e');
    }
    return (null, null);
  }

  Future<List<ChatModel>?> getMoreMessages({int? pageQuery = 1, int? limitQuery = 11, required int discussionId}) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/chat/load-more-chat?discussionId=$discussionId&pageQuery=$pageQuery&limitQuery=$limitQuery', sendToken: true);
      return (result['chatList'] as List).map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getMoreMessages:\n$e');
    }
    return null;
  }

  Future<List<ChatModel>?> searchInMessages(String? search, int? discussionId) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/chat/search-chat?searchText=$search&disc=$discussionId', sendToken: true);
      return (result['chatList'] as List).map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getMoreMessages:\n$e');
    }
    return null;
  }

  Future<List<ChatModel>?> getMessagesById(int? idChat) async {
    final result = await ApiBaseHelper().request(RequestType.get, '/chat/chat-id?idChat=$idChat', sendToken: true);
    if (idChat == null) return null;
    try {
      return (result['chatList'] as List).map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getMessagesById:\n$e');
    }
    return null;
  }

  Future<List<ChatModel>?> getMessagesBeforeAfter({required int? idChat, required bool isBefore}) async {
    if (idChat == null) return null;
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/chat/chat-before-after?idChat=$idChat&isBefore=$isBefore', sendToken: true);
      return (result['chatList'] as List).map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getMessagesById:\n$e');
    }
    return null;
  }

  Future<int> getNotSeenMessages() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/chat/get-not-seen', sendToken: true);
      return result['result'];
    } catch (e) {
      LoggerService.logger?.e('Error occured in getNotSeenMessages:\n$e');
    }
    return 0;
  }

  Future<File?> getContract(String id) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/public/contracts?id=$id&lang=${Get.locale?.languageCode ?? 'en'}', sendToken: true);
      if (result != null) {
        final bytes = result.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File(path.join(dir.path, 'contract.pdf'));
        await file.writeAsBytes(bytes);
        return file;
      }
      return null;
    } catch (e) {
      LoggerService.logger?.e('Error occured in getContract:\n$e');
      return null;
    }
  }
}
