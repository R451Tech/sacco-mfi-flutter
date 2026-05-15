sealed class ApiResult<T> {
  const ApiResult();

  T? get data => switch (this) {
        ApiSuccess<T>(:final data) => data,
        _ => null,
      };

  String? get errorMessage => switch (this) {
        ApiFailure<T>(:final message) => message,
        _ => null,
      };

  void when({
    required void Function(T data) success,
    required void Function(String message, int? statusCode, dynamic data) failure,
  }) {
    switch (this) {
      case ApiSuccess<T>(:final data):
        success(data);
      case ApiFailure<T>(:final message, :final statusCode, :final errorData):
        failure(message, statusCode, errorData);
    }
  }

  R map<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode, dynamic data) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) => success(data),
      ApiFailure<T>(:final message, :final statusCode, :final errorData) =>
          failure(message, statusCode, errorData),
    };
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  @override
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const ApiFailure(this.message, [this.statusCode, this.errorData]);
}
