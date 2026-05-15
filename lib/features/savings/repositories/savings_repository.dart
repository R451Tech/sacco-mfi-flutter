import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../models/savings_account.dart';
import '../../../models/transaction.dart';

class SavingsRepository {
  final ApiClient _apiClient;

  SavingsRepository(this._apiClient);

  Future<ApiResult<List<SavingsAccount>>> getAccounts({String? memberId}) async {
    try {
      final params = <String, dynamic>{};
      if (memberId != null) params['memberId'] = memberId;
      final response = await _apiClient.get('/savings', queryParameters: params);
      final list = (response['data'] as List)
          .map((e) => SavingsAccount.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess(list);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<SavingsAccount>> getAccount(String id) async {
    try {
      final response = await _apiClient.get('/savings/$id');
      return ApiSuccess(
        SavingsAccount.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<List<Transaction>>> getTransactions(String accountId) async {
    try {
      final response = await _apiClient.get('/savings/$accountId/transactions');
      final list = (response['data'] as List)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess(list);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Transaction>> deposit(String accountId, double amount, {String? description}) async {
    try {
      final response = await _apiClient.post('/savings/$accountId/deposit', data: {
        'amount': amount,
        if (description != null) 'description': description,
      });
      return ApiSuccess(
        Transaction.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Transaction>> withdraw(String accountId, double amount, {String? description}) async {
    try {
      final response = await _apiClient.post('/savings/$accountId/withdraw', data: {
        'amount': amount,
        if (description != null) 'description': description,
      });
      return ApiSuccess(
        Transaction.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}
