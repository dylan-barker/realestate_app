/// Network configuration constants.
abstract final class ApiConstants {
  static const String baseUrlAndroid = 'https://10.0.2.2:7063';
  static const String baseUrlDesktop = 'https://localhost:7063';

  /// Backend base URL injected at build time via
  /// `--dart-define=API_BASE_URL=https://...`. Empty when not supplied, in
  /// which case the local dev hosts above are used.
  static const String baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
