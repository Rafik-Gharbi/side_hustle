import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/balance_transaction.dart';
import '../services/theme/theme.dart';

class BalanceTransactionCard extends StatelessWidget {
  final BalanceTransaction transaction;
  const BalanceTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == BalanceTransactionType.deposit; // TODO does system type is income?
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(transaction.type?.name.tr ?? 'NA', style: AppFonts.x14Regular),
              if (transaction.type == BalanceTransactionType.deposit) Text(' (${transaction.depositType?.name.tr ?? 'NA'})', style: AppFonts.x14Regular),
            ],
          ),
          Text(
            '${isDeposit ? '+' : '-'} ${Helper.formatAmount(transaction.amount ?? 0)} ${MainAppController.find.currency.value}',
            style: AppFonts.x16Bold.copyWith(color: isDeposit ? kConfirmedColor : kErrorColor),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(transaction.status?.name.tr ?? 'NA', style: AppFonts.x12Regular),
          Text(transaction.createdAt != null ? Helper.formatDateWithTime(transaction.createdAt!) : 'NA', style: AppFonts.x12Regular),
        ],
      ),
    );
  }
}
