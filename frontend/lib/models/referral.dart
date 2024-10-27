import 'user.dart';

enum ReferralStatus { pending, registered, activated }

class Referral {
  final int id;
  final ReferralStatus status;
  final int rewardCoins;
  final DateTime? transactionDate;
  final DateTime? registrationDate;
  final DateTime createdAt;
  final User referredUser;

  Referral({
    required this.id,
    required this.status,
    required this.rewardCoins,
    required this.transactionDate,
    required this.registrationDate,
    required this.createdAt,
    required this.referredUser,
  });

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json['id'],
        status: ReferralStatus.values.singleWhere((element) => element.name == json['status']),
        rewardCoins: json['reward_coins'],
        transactionDate: json['transaction_date'] != null ? DateTime.parse(json['transaction_date']) : DateTime.now(),
        registrationDate: json['registration_date'] != null ? DateTime.parse(json['registration_date']) : DateTime.now(),
        createdAt: DateTime.parse(json['createdAt']),
        referredUser: User.fromJson(json['referred_user']),
      );

  DateTime get resolveDate => status == ReferralStatus.pending
      ? createdAt
      : status == ReferralStatus.registered
          ? registrationDate!
          : transactionDate!;
}
