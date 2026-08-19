/// Network configuration constants.
abstract final class ApiConstants {
  static const String baseUrlAndroid = 'https://api.realworth.co.za';
  static const String baseUrlDesktop = 'https://api.realworth.co.za';

  /// Backend base URL injected at build time via
  /// `--dart-define=API_BASE_URL=https://...`. Empty when not supplied, in
  /// which case [baseUrlAndroid]/[baseUrlDesktop] are used.
  static const String baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
