import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/loans_provider.dart';
import '../widgets/loan_card.dart';

class LoansListScreen extends ConsumerStatefulWidget {
  const LoansListScreen({super.key});

  @override
  ConsumerState<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends ConsumerState<LoansListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loansListNotifierProvider.notifier).loadLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loansState = ref.watch(loansListNotifierProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/dashboard/loans/apply'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Apply Loan'),
      ),
      body: loansState.when(
        loading: () => const AppLoadingPage(),
        error: (error, _) => AppError(
          message: error.toString(),
          onRetry: () => ref.read(loansListNotifierProvider.notifier).loadLoans(),
        ),
        data: (loans) {
          if (loans.isEmpty) {
            return const EmptyState(
              icon: Icons.monetization_on_outlined,
              title: 'No loans found',
              subtitle: 'Apply for a loan to get started',
              actionLabel: 'Apply for Loan',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(loansListNotifierProvider.notifier).loadLoans(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: loans.length,
              itemBuilder: (context, index) => LoanCard(
                loan: loans[index],
                onTap: () => context.go('/dashboard/loans/${loans[index].id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
