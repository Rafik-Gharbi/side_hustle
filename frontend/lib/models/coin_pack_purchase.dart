import 'coin_pack.dart';

class CoinPackPurchase {
  final String id;
  final CoinPack coinPack;
  final int? available;
  final DateTime createdAt;

  CoinPackPurchase({
    required this.id,
    required this.coinPack,
    required this.createdAt,
    this.available,
  });

  factory CoinPackPurchase.fromJson(Map<String, dynamic> json) => CoinPackPurchase(
        id: json['id'],
        coinPack: CoinPack.fromJson(json['coin_pack']),
        createdAt: DateTime.parse(json['createdAt']),
        available: json['available'],
      );
}
