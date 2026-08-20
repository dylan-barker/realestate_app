import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Network configuration constants.
abstract final class ApiConstants {
  static const String baseUrlAndroid = 'https://api.realworth.co.za';
  static const String baseUrlDesktop = 'https://api.realworth.co.za';

  /// Backend base URL injected at build time via
  /// `--dart-define=API_BASE_URL=https://...` or at runtime via the `.env`
  /// file. Empty when not supplied, in which case [baseUrlAndroid]/
  /// [baseUrlDesktop] are used.
  static String get baseUrlOverride {
    final envUrl = dotenv.maybeGet('API_BASE_URL');
    if (envUrl != null && envUrl.isNotEmpty) return envUrl;
    return const String.fromEnvironment('API_BASE_URL');
  }

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
