class AppConstants {
  AppConstants._();

  static const String appName = 'SACCO MFI';
  static const String baseUrl = 'https://api.sacco-mfi.com/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
