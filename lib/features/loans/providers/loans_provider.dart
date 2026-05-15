import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../models/loan.dart';
import '../../../models/loan_repayment.dart';
import '../repositories/loans_repository.dart';

final loansRepositoryProvider = Provider<LoansRepository>((ref) {
  return LoansRepository(ref.watch(apiClientProvider));
});

class LoansListNotifier extends StateNotifier<AsyncValue<List<Loan>>> {
  final Ref _ref;

  LoansListNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> loadLoans({String? memberId, String? status}) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(loansRepositoryProvider);
    final result = await repo.getLoans(memberId: memberId, status: status);
    result.when(
      success: (loans) => state = AsyncValue.data(loans),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final loansListNotifierProvider =
    StateNotifierProvider<LoansListNotifier, AsyncValue<List<Loan>>>((ref) {
  return LoansListNotifier(ref);
});

class LoanDetailNotifier extends StateNotifier<AsyncValue<Loan?>> {
  final Ref _ref;

  LoanDetailNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> loadLoan(String id) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(loansRepositoryProvider);
    final result = await repo.getLoan(id);
    result.when(
      success: (loan) => state = AsyncValue.data(loan),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final loanDetailNotifierProvider =
    StateNotifierProvider<LoanDetailNotifier, AsyncValue<Loan?>>((ref) {
  return LoanDetailNotifier(ref);
});

class LoanRepaymentsNotifier extends StateNotifier<AsyncValue<List<LoanRepayment>>> {
  final Ref _ref;

  LoanRepaymentsNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> loadRepayments(String loanId) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(loansRepositoryProvider);
    final result = await repo.getRepayments(loanId);
    result.when(
      success: (reps) => state = AsyncValue.data(reps),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final loanRepaymentsNotifierProvider =
    StateNotifierProvider<LoanRepaymentsNotifier, AsyncValue<List<LoanRepayment>>>((ref) {
  return LoanRepaymentsNotifier(ref);
});

class LoanApplyNotifier extends StateNotifier<AsyncValue<Loan?>> {
  final Ref _ref;

  LoanApplyNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> applyLoan(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(loansRepositoryProvider);
    final result = await repo.applyLoan(data);
    result.when(
      success: (loan) => state = AsyncValue.data(loan),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final loanApplyNotifierProvider =
    StateNotifierProvider<LoanApplyNotifier, AsyncValue<Loan?>>((ref) {
  return LoanApplyNotifier(ref);
});

class LoanRepayNotifier extends StateNotifier<AsyncValue<LoanRepayment?>> {
  final Ref _ref;

  LoanRepayNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> repay(
    String loanId,
    double amount, {
    String? paymentMethod,
    String? reference,
  }) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(loansRepositoryProvider);
    final result = await repo.makeRepayment(loanId, amount,
        paymentMethod: paymentMethod, reference: reference);
    result.when(
      success: (repayment) => state = AsyncValue.data(repayment),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final loanRepayNotifierProvider =
    StateNotifierProvider<LoanRepayNotifier, AsyncValue<LoanRepayment?>>((ref) {
  return LoanRepayNotifier(ref);
});
