enum NotificationType { verification, chat, reservation, booking, newTask, review, others }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? action;
  final NotificationType type;
  final DateTime? date;
  final bool seen;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.date,
    required this.seen,
    required this.action,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'].toString(),
        title: json['title'],
        body: json['body'],
        type: NotificationType.values.singleWhere((element) => element.name == json['type']),
        date: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
        seen: json['seen'] == 1,
        action: json['action'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['type'] = type.name;
    data['date'] = date?.toIso8601String();
    data['seen'] = seen;
    data['action'] = action;
    return data;
  }
}
