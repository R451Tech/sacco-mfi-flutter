import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/savings_provider.dart';
import '../widgets/transaction_tile.dart';

class SavingsDetailScreen extends ConsumerStatefulWidget {
  final String accountId;

  const SavingsDetailScreen({super.key, required this.accountId});

  @override
  ConsumerState<SavingsDetailScreen> createState() => _SavingsDetailScreenState();
}

class _SavingsDetailScreenState extends ConsumerState<SavingsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(savingsDetailNotifierProvider.notifier).loadAccount(widget.accountId);
      ref.read(savingsTransactionsNotifierProvider.notifier).loadTransactions(widget.accountId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(savingsDetailNotifierProvider);
    final transactionsState = ref.watch(savingsTransactionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Account'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'deposit') {
                context.go('/dashboard/savings/${widget.accountId}/deposit');
              } else if (value == 'withdraw') {
                context.go('/dashboard/savings/${widget.accountId}/withdraw');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'deposit',
                child: ListTile(
                  leading: Icon(Icons.add_circle_outlined, color: AppColors.success),
                  title: Text('Deposit'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'withdraw',
                child: ListTile(
                  leading: Icon(Icons.remove_circle_outlined, color: AppColors.error),
                  title: Text('Withdraw'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: accountState.when(
        loading: () => const AppLoadingPage(),
        error: (error, _) => AppError(
          message: error.toString(),
          onRetry: () => ref.read(savingsDetailNotifierProvider.notifier).loadAccount(widget.accountId),
        ),
        data: (account) {
          if (account == null) {
            return const AppError(message: 'Account not found');
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
                          'Current Balance',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Formatters.currency(account.balance),
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ActionButton(
                              icon: Icons.add_circle_rounded,
                              label: 'Deposit',
                              color: AppColors.success,
                              onTap: () => context.go('/dashboard/savings/${widget.accountId}/deposit'),
                            ),
                            _ActionButton(
                              icon: Icons.remove_circle_rounded,
                              label: 'Withdraw',
                              color: AppColors.error,
                              onTap: () => context.go('/dashboard/savings/${widget.accountId}/withdraw'),
                            ),
                          ],
                        ),
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
                        _DetailRow(label: 'Account Number', value: account.accountNumber),
                        const Divider(),
                        _DetailRow(label: 'Status', value: account.status),
                        if (account.memberName != null) ...[
                          const Divider(),
                          _DetailRow(label: 'Member', value: account.memberName!),
                        ],
                        const Divider(),
                        _DetailRow(
                          label: 'Opened',
                          value: Formatters.date(account.openedDate),
                        ),
                        if (account.interestRate > 0) ...[
                          const Divider(),
                          _DetailRow(
                            label: 'Interest Rate',
                            value: Formatters.percentage(account.interestRate),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Transaction History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                transactionsState.when(
                  loading: () => const AppLoadingPage(),
                  error: (error, _) => AppError(message: error.toString()),
                  data: (txs) {
                    if (txs.isEmpty) {
                      return const EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No transactions yet',
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: txs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) => TransactionTile(transaction: txs[index]),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
