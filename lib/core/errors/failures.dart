/// Base class for all user-facing failures.
///
/// Failures carry a human-readable [message] that is safe to show to users.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'Unable to connect to the server. Please check your connection and try again.',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'The request timed out. Please try again.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Your session has expired. Please sign in again.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message =
        'The submitted data is invalid. Please review it and try again.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message =
        'Something went wrong on the server. Please try again later.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Failed to read local data. Please try again.',
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
