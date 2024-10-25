import 'coin_pack.dart';
import 'service.dart';
import 'task.dart';

enum TransactionType { proposal, refund, purchase, monthlyReset, initialCoins, request }

enum TransactionStatus { pending, completed, refunded }

class Transaction {
  final String id;
  final int coins;
  final Task? task;
  final Service? service;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime createdAt;
  final CoinPack? coinPack;

  Transaction({
    required this.id,
    required this.coins,
    required this.task,
    required this.service,
    required this.type,
    required this.status,
    required this.createdAt,
    this.coinPack,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        coins: json['coins'],
        task: json['task'] != null ? Task.fromJson(json['task']) : null,
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
        coinPack: json['coin_pack'] != null ? CoinPack.fromJson(json['coin_pack']) : null,
        type: TransactionType.values.singleWhere((element) => element.name == json['type']),
        status: TransactionStatus.values.singleWhere((element) => element.name == json['status']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['coins'] = coins;
    data['type'] = type.name;
    data['status'] = status.name;
    if (service != null) data['service'] = service!.toJson();
    if (task != null) data['task'] = task!.toJson();
    return data;
  }
}
