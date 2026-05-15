import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportData {
  final String title;
  final double value;
  final double percentageChange;
  final IconType iconType;

  ReportData({
    required this.title,
    required this.value,
    this.percentageChange = 0,
    this.iconType = IconType.members,
  });
}

enum IconType { members, savings, loans, revenue }

class ReportsNotifier extends StateNotifier<AsyncValue<List<ReportData>>> {
  ReportsNotifier() : super(const AsyncValue.data([])) {
    _loadReports();
  }

  Future<void> _loadReports() async {
    state = AsyncValue.data([
      ReportData(title: 'Total Members', value: 0, iconType: IconType.members),
      ReportData(title: 'Total Savings', value: 0, iconType: IconType.savings),
      ReportData(title: 'Total Loans', value: 0, iconType: IconType.loans),
      ReportData(title: 'Revenue', value: 0, iconType: IconType.revenue),
    ]);
  }
}

final reportsNotifierProvider =
    StateNotifierProvider<ReportsNotifier, AsyncValue<List<ReportData>>>((ref) {
  return ReportsNotifier();
});
