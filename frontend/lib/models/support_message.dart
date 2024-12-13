import '../networking/api_base_helper.dart';
import 'dto/image_dto.dart';
import 'user.dart';

class SupportMessage {
  final String? id;
  final String ticketId;
  final String message;
  final ImageDTO? attachment;
  final DateTime? createdAt;
  final User? user;

  SupportMessage({this.id, required this.ticketId, required this.message, required this.attachment, this.createdAt, this.user});

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
        id: json['id'],
        ticketId: json['ticketId'] ?? json['ticket_id'],
        message: json['message'],
        attachment:
            json['attachment'] != null ? ImageDTO.fromJson(json['attachment'], path: ApiBaseHelper.find.getLogs(json['attachment']['url'], json['attachment']['type'])) : null,
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (attachment != null) data['attachment'] = attachment!.file.name;
    data['ticketId'] = ticketId;
    data['message'] = message;
    return data;
  }
}
