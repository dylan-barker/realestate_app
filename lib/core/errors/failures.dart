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
    super.message = 'No internet connection. Please check and try again.',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out. Please try again.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Session expired. Please sign in again.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Please check your details and try again.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong. Please try again later.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Couldn\'t load data. Please try again.',
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

/// Returns a short, user-friendly message for wizard auto-save failures.
/// Wraps the raw [message] with the [section] context and ensures it stays
/// concise for a SnackBar.
String friendlySaveMessage(String message, String section) {
  final lower = message.toLowerCase();
  // Known generic failures already are friendly; just add section context
  // for save-specific clarity.
  if (lower.contains('internet') || lower.contains('connection')) {
    return 'No connection. Couldn\'t save $section.';
  }
  if (lower.contains('timed out') || lower.contains('timeout')) {
    return 'Couldn\'t save $section. Please try again.';
  }
  if (lower.contains('session expired') || lower.contains('sign in again')) {
    return 'Session expired. Please sign in again.';
  }
  if (lower.contains('something went wrong') ||
      lower.contains('try again later')) {
    return 'Couldn\'t save $section. Please try again.';
  }
  // For validation-style "field: message", keep it but ensure brevity.
  if (message.length > 90) {
    return 'Couldn\'t save $section. Please check your details.';
  }
  // If message already looks like a field error (e.g. "Street: ..."),
  // prefix with section for context.
  if (message.contains(':')) {
    return message.length > 80 ? 'Couldn\'t save $section. $message' : message;
  }
  return message;
}
