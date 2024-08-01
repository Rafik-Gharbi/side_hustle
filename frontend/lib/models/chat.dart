class ChatModel {
  final int id;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int recieverId;
  final int senderId;
  final int discussionId;
  bool isFirstMessage;

  ChatModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.recieverId,
    required this.senderId,
    required this.discussionId,
    required this.isFirstMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'],
        message: json['message'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        recieverId: json['reciever_id'],
        senderId: json['sender_id'],
        discussionId: json['discussion_id'],
        isFirstMessage: json['isFirst'] == 'true',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['message'] = message;
    data['reciever_id'] = recieverId;
    data['sender_id'] = senderId;
    data['discussion_id'] = discussionId;
    data['isFirst'] = isFirstMessage;
    return data;
  }
}
