import 'package:dio/dio.dart';

import 'failures.dart';
import 'network_error_check.dart';

/// Maps exceptions raised in the data layer into user-facing [Failure]s.
Failure mapFailure(Object error) {
  if (error is Failure) return error;
  if (error is DioException) return _mapDioException(error);
  return const UnknownFailure();
}

Failure _mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badCertificate:
      return const NetworkFailure(
        'The server connection is not secure. Please try again.',
      );
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) return const UnauthorizedFailure();
      if (statusCode == 404) {
        return const ValidationFailure(
          'The requested resource was not found.',
        );
      }
      if (statusCode != null && statusCode >= 500) {
        return const ServerFailure();
      }
      return const ValidationFailure();
    case DioExceptionType.cancel:
      return const UnknownFailure('The request was cancelled.');
    case DioExceptionType.unknown:
      if (isIoNetworkError(error.error)) {
        return const NetworkFailure();
      }
      return const UnknownFailure();
  }
}
