import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../providers/reports_provider.dart';

class ReportCard extends StatelessWidget {
  final ReportData data;

  const ReportCard({super.key, required this.data});

  IconData _icon() {
    switch (data.iconType) {
      case IconType.members:
        return Icons.people_rounded;
      case IconType.savings:
        return Icons.savings_rounded;
      case IconType.loans:
        return Icons.monetization_on_rounded;
      case IconType.revenue:
        return Icons.trending_up_rounded;
    }
  }

  Color _color() {
    switch (data.iconType) {
      case IconType.members:
        return AppColors.primary;
      case IconType.savings:
        return AppColors.success;
      case IconType.loans:
        return AppColors.accent;
      case IconType.revenue:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _color().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_icon(), color: _color(), size: 20),
                ),
                const Spacer(),
                if (data.percentageChange != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: data.percentageChange > 0
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${data.percentageChange > 0 ? '+' : ''}${data.percentageChange.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: data.percentageChange > 0 ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              Formatters.currency(data.value),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
