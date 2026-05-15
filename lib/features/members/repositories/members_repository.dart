import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../models/member.dart';

class MembersRepository {
  final ApiClient _apiClient;

  MembersRepository(this._apiClient);

  Future<ApiResult<List<Member>>> getMembers({String? search}) async {
    try {
      final params = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        params['search'] = search;
      }
      final response = await _apiClient.get('/members', queryParameters: params);
      final list = (response['data'] as List)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiSuccess(list);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Member>> getMember(String id) async {
    try {
      final response = await _apiClient.get('/members/$id');
      return ApiSuccess(Member.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Member>> createMember(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/members', data: data);
      return ApiSuccess(Member.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Member>> updateMember(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/members/$id', data: data);
      return ApiSuccess(Member.fromJson(response['data'] as Map<String, dynamic>));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<void>> deleteMember(String id) async {
    try {
      await _apiClient.delete('/members/$id');
      return const ApiSuccess(null);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}
