import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(apiClientProvider));
});

class DashboardSummaryNotifier extends StateNotifier<AsyncValue<DashboardSummary?>> {
  final Ref _ref;

  DashboardSummaryNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> loadSummary() async {
    state = const AsyncValue.loading();
    final repo = _ref.read(dashboardRepositoryProvider);
    final result = await repo.getSummary();
    result.when(
      success: (summary) => state = AsyncValue.data(summary),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }
}

final dashboardSummaryNotifierProvider =
    StateNotifierProvider<DashboardSummaryNotifier, AsyncValue<DashboardSummary?>>((ref) {
  return DashboardSummaryNotifier(ref);
});
