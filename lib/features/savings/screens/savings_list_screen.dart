import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/savings_provider.dart';

class SavingsListScreen extends ConsumerStatefulWidget {
  const SavingsListScreen({super.key});

  @override
  ConsumerState<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends ConsumerState<SavingsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(savingsListNotifierProvider.notifier).loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountsState = ref.watch(savingsListNotifierProvider);

    return accountsState.when(
      loading: () => const AppLoadingPage(),
      error: (error, _) => AppError(
        message: error.toString(),
        onRetry: () => ref.read(savingsListNotifierProvider.notifier).loadAccounts(),
      ),
      data: (accounts) {
        if (accounts.isEmpty) {
          return const EmptyState(
            icon: Icons.savings_outlined,
            title: 'No savings accounts',
            subtitle: 'Savings accounts will appear here once created',
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(savingsListNotifierProvider.notifier).loadAccounts(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: InkWell(
                  onTap: () => context.go('/dashboard/savings/${account.id}'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.savings_rounded,
                            color: AppColors.success,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.memberName ?? 'Account ${account.accountNumber}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                account.accountNumber,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.currency(account.balance),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: account.status == 'active'
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                account.status,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: account.status == 'active'
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: AppColors.textHint),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
