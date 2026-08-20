import 'dart:io' show Platform, HttpClient;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../constants/api_constants.dart';

/// Resolves the default backend base URL for native platforms.
String resolveDefaultBaseUrl() {
  if (ApiConstants.baseUrlOverride.isNotEmpty) {
    return ApiConstants.baseUrlOverride;
  }
  return Platform.isAndroid
      ? ApiConstants.baseUrlAndroid
      : ApiConstants.baseUrlDesktop;
}

/// Bypasses the self-signed dev cert validation for the local backend.
void applyDebugTlsBypass(Dio dio) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    },
  );
}
