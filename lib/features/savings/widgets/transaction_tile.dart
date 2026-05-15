import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == 'deposit';
    final isWithdrawal = transaction.type == 'withdrawal';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDeposit
            ? AppColors.success.withValues(alpha: 0.1)
            : isWithdrawal
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.info.withValues(alpha: 0.1),
        child: Icon(
          isDeposit
              ? Icons.arrow_downward_rounded
              : isWithdrawal
                  ? Icons.arrow_upward_rounded
                  : Icons.swap_horiz_rounded,
          color: isDeposit
              ? AppColors.success
              : isWithdrawal
                  ? AppColors.error
                  : AppColors.info,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description ?? transaction.type,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        Formatters.dateTime(transaction.date),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isDeposit ? '+' : '-'}${Formatters.currency(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDeposit ? AppColors.success : AppColors.error,
            ),
          ),
          Text(
            'Bal: ${Formatters.currency(transaction.balanceAfter)}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
