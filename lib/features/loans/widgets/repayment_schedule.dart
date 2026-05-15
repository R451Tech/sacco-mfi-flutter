import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/loan_repayment.dart';

class RepaymentSchedule extends StatelessWidget {
  final List<LoanRepayment> repayments;

  const RepaymentSchedule({super.key, required this.repayments});

  @override
  Widget build(BuildContext context) {
    if (repayments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No repayments scheduled',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repayments.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final repayment = repayments[index];
        final isPaid = repayment.status == 'paid';
        final isOverdue = repayment.isOverdue;

        return ListTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: isPaid
                ? AppColors.success.withValues(alpha: 0.1)
                : isOverdue
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
            child: Icon(
              isPaid
                  ? Icons.check_circle_rounded
                  : isOverdue
                      ? Icons.warning_rounded
                      : Icons.schedule_rounded,
              color: isPaid
                  ? AppColors.success
                  : isOverdue
                      ? AppColors.error
                      : AppColors.warning,
              size: 20,
            ),
          ),
          title: Text(
            'Installment ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Due: ${Formatters.date(repayment.dueDate)}',
            style: TextStyle(
              color: isOverdue ? AppColors.error : AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(repayment.amount),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (isPaid)
                Text(
                  'Paid ${Formatters.date(repayment.paidDate!)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.success,
                  ),
                ),
              if (isOverdue)
                Text(
                  'OVERDUE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
