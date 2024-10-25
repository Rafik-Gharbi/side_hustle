class CoinPack {
  final int id;
  final String title;
  final int price;
  final int? save;
  final String description;
  final int? bonus;
  final String? bonusMsg;
  final int totalCoins;
  final int validMonths;
  final DateTime createdAt;

  CoinPack({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.totalCoins,
    required this.validMonths,
    required this.createdAt,
    this.save,
    this.bonus,
    this.bonusMsg,
  });

  factory CoinPack.fromJson(Map<String, dynamic> json) => CoinPack(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        description: json['description'],
        totalCoins: json['totalCoins'],
        validMonths: json['validMonths'],
        save: json['save'],
        bonus: json['bonus'],
        bonusMsg: json['bonusMsg'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
