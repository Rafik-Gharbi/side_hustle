class DiscussionDTO {
  final int? id;
  final String? ownerName;
  final String? userName;
  final int? ownerId;
  final int? userId;
  String? lastMessage;
  DateTime? lastMessageDate;
  int notSeen;

  DiscussionDTO({
    this.ownerName,
    this.userName,
    this.id,
    this.lastMessage,
    this.lastMessageDate,
    this.ownerId,
    this.userId,
    this.notSeen = 0,
  });

  factory DiscussionDTO.fromJson(Map<String, dynamic> json) => DiscussionDTO(
        id: json['id'],
        ownerName: json['owner_name'],
        userName: json['user_name'],
        ownerId: json['owner_id'],
        userId: json['user_id'],
        notSeen: json['notSeen'] ?? 0,
        lastMessage: json['last_message'],
        lastMessageDate: json['last_message_date'] != null ? DateTime.tryParse(json['last_message_date']) : null,
      );
}
