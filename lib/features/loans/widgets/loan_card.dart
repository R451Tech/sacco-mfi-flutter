import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/loan.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback? onTap;

  const LoanCard({super.key, required this.loan, this.onTap});

  Color _statusColor(String? status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'approved':
        return AppColors.info;
      case 'rejected':
        return AppColors.error;
      case 'paid':
        return AppColors.success;
      case 'defaulted':
        return AppColors.error;
      default:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _statusColor(loan.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.monetization_on_rounded,
                      color: _statusColor(loan.status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.loanProduct,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (loan.memberName != null)
                          Text(
                            loan.memberName!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(loan.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      loan.status!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(loan.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Principal',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          Formatters.currency(loan.principal),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Balance',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          Formatters.currency(loan.balance),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: loan.balance > 0 ? AppColors.error : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (loan.status == 'active') ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: loan.progress,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loan.progress > 0.5 ? AppColors.success : AppColors.warning,
                    ),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(loan.progress * 100).toStringAsFixed(1)}% paid',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
