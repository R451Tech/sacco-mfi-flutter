import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../models/savings_account.dart';
import '../../../models/transaction.dart';
import '../repositories/savings_repository.dart';

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepository(ref.watch(apiClientProvider));
});

class SavingsListNotifier extends StateNotifier<AsyncValue<List<SavingsAccount>>> {
  final Ref _ref;

  SavingsListNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> loadAccounts({String? memberId}) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(savingsRepositoryProvider);
    final result = await repo.getAccounts(memberId: memberId);
    result.when(
      success: (accounts) => state = AsyncValue.data(accounts),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final savingsListNotifierProvider =
    StateNotifierProvider<SavingsListNotifier, AsyncValue<List<SavingsAccount>>>((ref) {
  return SavingsListNotifier(ref);
});

class SavingsDetailNotifier extends StateNotifier<AsyncValue<SavingsAccount?>> {
  final Ref _ref;

  SavingsDetailNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> loadAccount(String id) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(savingsRepositoryProvider);
    final result = await repo.getAccount(id);
    result.when(
      success: (account) => state = AsyncValue.data(account),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final savingsDetailNotifierProvider =
    StateNotifierProvider<SavingsDetailNotifier, AsyncValue<SavingsAccount?>>((ref) {
  return SavingsDetailNotifier(ref);
});

class SavingsTransactionsNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final Ref _ref;

  SavingsTransactionsNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> loadTransactions(String accountId) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(savingsRepositoryProvider);
    final result = await repo.getTransactions(accountId);
    result.when(
      success: (txs) => state = AsyncValue.data(txs),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final savingsTransactionsNotifierProvider =
    StateNotifierProvider<SavingsTransactionsNotifier, AsyncValue<List<Transaction>>>((ref) {
  return SavingsTransactionsNotifier(ref);
});

class SavingsTransactionNotifier extends StateNotifier<AsyncValue<Transaction?>> {
  final Ref _ref;

  SavingsTransactionNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> deposit(String accountId, double amount, {String? description}) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(savingsRepositoryProvider);
    final result = await repo.deposit(accountId, amount, description: description);
    result.when(
      success: (tx) => state = AsyncValue.data(tx),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }

  Future<void> withdraw(String accountId, double amount, {String? description}) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(savingsRepositoryProvider);
    final result = await repo.withdraw(accountId, amount, description: description);
    result.when(
      success: (tx) => state = AsyncValue.data(tx),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final savingsTransactionNotifierProvider =
    StateNotifierProvider<SavingsTransactionNotifier, AsyncValue<Transaction?>>((ref) {
  return SavingsTransactionNotifier(ref);
});
