import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../providers/loans_provider.dart';
import '../widgets/repayment_schedule.dart';

class LoanDetailScreen extends ConsumerStatefulWidget {
  final String loanId;

  const LoanDetailScreen({super.key, required this.loanId});

  @override
  ConsumerState<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends ConsumerState<LoanDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loanDetailNotifierProvider.notifier).loadLoan(widget.loanId);
      ref.read(loanRepaymentsNotifierProvider.notifier).loadRepayments(widget.loanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loanState = ref.watch(loanDetailNotifierProvider);
    final repaymentsState = ref.watch(loanRepaymentsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Details'),
        actions: [
          if (loanState.valueOrNull?.status == 'active')
            IconButton(
              icon: const Icon(Icons.payments_rounded),
              onPressed: () => context.go('/dashboard/loans/${widget.loanId}/repay'),
            ),
        ],
      ),
      body: loanState.when(
        loading: () => const AppLoadingPage(),
        error: (error, _) => AppError(
          message: error.toString(),
          onRetry: () => ref.read(loanDetailNotifierProvider.notifier).loadLoan(widget.loanId),
        ),
        data: (loan) {
          if (loan == null) {
            return const AppError(message: 'Loan not found');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Loan Summary',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(label: 'Principal', value: Formatters.currency(loan.principal)),
                            _SummaryItem(label: 'Balance', value: Formatters.currency(loan.balance), valueColor: AppColors.error),
                            _SummaryItem(label: 'Paid', value: Formatters.currency(loan.amountPaid), valueColor: AppColors.success),
                          ],
                        ),
                        if (loan.status == 'active') ...[
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: loan.progress,
                              backgroundColor: AppColors.border,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(loan.progress * 100).toStringAsFixed(1)}% repaid',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(label: 'Loan Product', value: loan.loanProduct),
                        if (loan.memberName != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Member', value: loan.memberName!),
                        ],
                        const Divider(),
                        _DetailRow(label: 'Status', value: loan.status!),
                        const Divider(),
                        _DetailRow(label: 'Interest Rate', value: Formatters.percentage(loan.interestRate)),
                        const Divider(),
                        _DetailRow(label: 'Term', value: '${loan.termMonths} months'),
                        const Divider(),
                        _DetailRow(label: 'Monthly Payment', value: Formatters.currency(loan.monthlyPayment)),
                        if (loan.purpose != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Purpose', value: loan.purpose!),
                        ],
                        if (loan.collateral != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Collateral', value: loan.collateral!),
                        ],
                        if (loan.applicationDate != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Applied', value: Formatters.date(loan.applicationDate!)),
                        ],
                        if (loan.approvalDate != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Approved', value: Formatters.date(loan.approvalDate!)),
                        ],
                        if (loan.maturityDate != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Maturity', value: Formatters.date(loan.maturityDate!)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Repayment Schedule',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                repaymentsState.when(
                  loading: () => const AppLoadingPage(),
                  error: (error, _) => AppError(message: error.toString()),
                  data: (reps) => RepaymentSchedule(repayments: reps),
                ),
                if (loan.status == 'active') ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.go('/dashboard/loans/${widget.loanId}/repay'),
                      icon: const Icon(Icons.payments_rounded),
                      label: const Text('Make Payment'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
