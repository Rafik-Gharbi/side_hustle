import 'package:image_picker/image_picker.dart';

import '../helpers/helper.dart';
import '../networking/api_base_helper.dart';
import '../views/profile/balance/balance_controller.dart';
import 'dto/image_dto.dart';
import 'user.dart';

enum BalanceTransactionType { taskPayment, deposit, withdrawal, system }

enum BalanceTransactionStatus { pending, completed, failed }

class BalanceTransaction {
  final String? id;
  final BalanceTransactionType? type;
  final double? amount;
  final BalanceTransactionStatus? status;
  final String? description;
  final DepositType? depositType;
  final ImageDTO? depositSlip;
  final DateTime? createdAt;
  final User? user;

  BalanceTransaction({
    this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.description,
    required this.depositType,
    required this.depositSlip,
    this.createdAt,
    this.user,
  });

  factory BalanceTransaction.fromJson(Map<String, dynamic> json) => BalanceTransaction(
        id: json['id'],
        type: BalanceTransactionType.values.singleWhere((element) => element.name == json['type']),
        amount: Helper.resolveDouble(json['amount']),
        status: BalanceTransactionStatus.values.singleWhere((element) => element.name == json['status']),
        description: json['description'],
        depositType: json['depositType'] != null ? DepositType.values.singleWhere((element) => element.name == json['depositType']) : null,
        depositSlip: json['depositSlip'] != null ? ImageDTO(file: XFile(ApiBaseHelper.find.getImageDepositSlip(json['depositSlip'])), type: ImageType.image) : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
      );
}
