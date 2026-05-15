import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../models/loan.dart';
import '../../../models/loan_repayment.dart';

class LoansRepository {
  final ApiClient _apiClient;

  LoansRepository(this._apiClient);

  Future<ApiResult<List<Loan>>> getLoans({String? memberId, String? status}) async {
    try {
      final params = <String, dynamic>{};
      if (memberId != null) params['memberId'] = memberId;
      if (status != null) params['status'] = status;
      final response = await _apiClient.get('/loans', queryParameters: params);
      final list = (response['data'] as List)
          .map((e) => Loan.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess(list);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Loan>> getLoan(String id) async {
    try {
      final response = await _apiClient.get('/loans/$id');
      return ApiSuccess(Loan.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<List<LoanRepayment>>> getRepayments(String loanId) async {
    try {
      final response = await _apiClient.get('/loans/$loanId/repayments');
      final list = (response['data'] as List)
          .map((e) => LoanRepayment.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess(list);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Loan>> applyLoan(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/loans', data: data);
      return ApiSuccess(Loan.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<LoanRepayment>> makeRepayment(String loanId, double amount, {String? paymentMethod, String? reference}) async {
    try {
      final response = await _apiClient.post('/loans/$loanId/repay', data: {
        'amount': amount,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        if (reference != null) 'reference': reference,
      });
      return ApiSuccess(
        LoanRepayment.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Loan>> approveLoan(String id) async {
    try {
      final response = await _apiClient.put('/loans/$id/approve');
      return ApiSuccess(Loan.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Loan>> rejectLoan(String id, {String? reason}) async {
    try {
      final response = await _apiClient.put('/loans/$id/reject', data: {
        if (reason != null) 'reason': reason,
      });
      return ApiSuccess(Loan.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}
