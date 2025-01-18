import 'package:image_picker/image_picker.dart';

import '../networking/api_base_helper.dart';
import 'dto/image_dto.dart';
import 'user.dart';

enum TicketCategory { generalInquiry, technicalIssue, profileDeletion, paymentIssue }

enum TicketStatus { open, pending, resolved, closed }

enum TicketPriority { low, medium, high }

class SupportTicket {
  final String? id;
  final TicketCategory category;
  final String subject;
  final String description;
  final TicketStatus? status;
  final TicketPriority priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? guestId;
  final User? user;
  final User? assigned;
  final XFile? logs;
  final List<ImageDTO>? attachments;

  SupportTicket({
    this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.priority,
    this.user,
    this.guestId,
    this.assigned,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.logs,
    this.attachments,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) => SupportTicket(
        id: json['id'],
        category: TicketCategory.values.singleWhere((element) => element.name == json['category']),
        priority: TicketPriority.values.singleWhere((element) => element.name == json['priority']),
        status: TicketStatus.values.singleWhere((element) => element.name == json['status']),
        subject: json['subject'],
        guestId: json['guest_id'],
        description: json['description'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        assigned: json['assigned'] != null ? User.fromJson(json['assigned']) : null,
        logs: json['logFile'] != null ? XFile(ApiBaseHelper.find.getLogs(json['logFile']['url'], 'log')) : null,
        attachments: json['attachments'] != null && (json['attachments'] as List).isNotEmpty
            ? (json['attachments'] as List).map((e) => ImageDTO.fromJson(e, path: ApiBaseHelper.find.getLogs(e['url'], e['type']))).toList()
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (guestId != null) data['guest_id'] = guestId;
    if (status != null) data['status'] = status!.name;
    data['category'] = category.name;
    data['priority'] = priority.name;
    data['description'] = description;
    data['subject'] = subject;
    return data;
  }
}
