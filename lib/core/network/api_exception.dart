class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';

  factory ApiException.fromStatusCode(int code, [dynamic data]) {
    switch (code) {
      case 400:
        return ApiException(message: 'Bad request', statusCode: code, data: data);
      case 401:
        return ApiException(message: 'Unauthorized', statusCode: code, data: data);
      case 403:
        return ApiException(message: 'Forbidden', statusCode: code, data: data);
      case 404:
        return ApiException(message: 'Not found', statusCode: code, data: data);
      case 409:
        return ApiException(message: 'Conflict', statusCode: code, data: data);
      case 422:
        return ApiException(message: 'Validation error', statusCode: code, data: data);
      case 500:
        return ApiException(message: 'Internal server error', statusCode: code, data: data);
      case 502:
        return ApiException(message: 'Bad gateway', statusCode: code, data: data);
      case 503:
        return ApiException(message: 'Service unavailable', statusCode: code, data: data);
      default:
        return ApiException(message: 'Unknown error', statusCode: code, data: data);
    }
  }
}
