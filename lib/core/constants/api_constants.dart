/// Network configuration constants.
abstract final class ApiConstants {
  static const String baseUrlAndroid = 'https://10.0.2.2:7063';
  static const String baseUrlDesktop = 'https://localhost:7063';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
