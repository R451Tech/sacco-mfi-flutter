import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/transaction.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (transactions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No recent transactions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          ...transactions.map((tx) => _TransactionItem(transaction: tx)),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

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
      trailing: Text(
        '${isDeposit ? '+' : '-'}${Formatters.currency(transaction.amount)}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDeposit ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}
