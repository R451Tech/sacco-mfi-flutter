import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../models/user.dart';
import 'dart:convert';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepository(this._apiClient, this._storage);

  Future<ApiResult<User>> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response['token'] as String;
      final user = User.fromJson(response['user'] as Map<String, dynamic>);

      await _storage.write(key: AppConstants.tokenKey, value: token);
      await _storage.write(key: AppConstants.userKey, value: jsonEncode(user.toJson()));

      return ApiSuccess(user);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<User>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/register', data: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      });

      final token = response['token'] as String;
      final user = User.fromJson(response['user'] as Map<String, dynamic>);

      await _storage.write(key: AppConstants.tokenKey, value: token);
      await _storage.write(key: AppConstants.userKey, value: jsonEncode(user.toJson()));

      return ApiSuccess(user);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (_) {}
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
    return const ApiSuccess(null);
  }

  Future<User?> getSavedUser() async {
    final userData = await _storage.read(key: AppConstants.userKey);
    if (userData == null) return null;
    return User.fromJson(jsonDecode(userData) as Map<String, dynamic>);
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}
