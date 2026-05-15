import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';

class DashboardSummary {
  final int totalMembers;
  final int activeLoans;
  final double totalSavings;
  final double totalLoanPortfolio;
  final double totalDisbursed;
  final double totalRepaid;
  final Map<String, double> monthlySavings;
  final Map<String, double> monthlyDisbursements;

  DashboardSummary({
    required this.totalMembers,
    required this.activeLoans,
    required this.totalSavings,
    required this.totalLoanPortfolio,
    required this.totalDisbursed,
    required this.totalRepaid,
    required this.monthlySavings,
    required this.monthlyDisbursements,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalMembers: json['totalMembers'] as int? ?? 0,
      activeLoans: json['activeLoans'] as int? ?? 0,
      totalSavings: (json['totalSavings'] as num?)?.toDouble() ?? 0,
      totalLoanPortfolio: (json['totalLoanPortfolio'] as num?)?.toDouble() ?? 0,
      totalDisbursed: (json['totalDisbursed'] as num?)?.toDouble() ?? 0,
      totalRepaid: (json['totalRepaid'] as num?)?.toDouble() ?? 0,
      monthlySavings: Map<String, double>.from(
        (json['monthlySavings'] as Map? ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      monthlyDisbursements: Map<String, double>.from(
        (json['monthlyDisbursements'] as Map? ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
    );
  }
}

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository(this._apiClient);

  Future<ApiResult<DashboardSummary>> getSummary() async {
    try {
      final response = await _apiClient.get('/dashboard/summary');
      return ApiSuccess(DashboardSummary.fromJson(response));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}
