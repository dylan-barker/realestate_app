import 'dart:async';
import 'dart:io' show Platform, HttpClient;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'api_endpoints.dart';

class ApiClient {
  /// Resolves the backend base URL: a `--dart-define=API_BASE_URL` build
  /// override wins, otherwise fall back to the local dev hosts.
  static String _defaultBaseUrl() {
    if (ApiConstants.baseUrlOverride.isNotEmpty) {
      return ApiConstants.baseUrlOverride;
    }
    return Platform.isAndroid
        ? ApiConstants.baseUrlAndroid
        : ApiConstants.baseUrlDesktop;
  }

  final Dio _dio;
  String? _token;
  void Function()? _onUnauthorized;
  Future<bool> Function()? _onRefreshToken;
  Future<void>? _refreshCompleter;

  ApiClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? _defaultBaseUrl(),
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
          headers: {
            'Content-Type': ApiConstants.contentTypeJson,
            'Accept': ApiConstants.acceptJson,
          },
          followRedirects: true,
        ),
      ) {
    // Only bypass TLS certificate validation in debug builds, where the local
    // dev backend serves a self-signed cert. Release builds keep the
    // platform's default validation.
    if (kDebugMode) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    }
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: kDebugMode, responseBody: kDebugMode),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers[ApiConstants.authorizationHeader] =
                '${ApiConstants.bearerPrefix}$_token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            handler.next(error);
            return;
          }

          final path = error.requestOptions.path;
          final isAuthEndpoint =
              path.contains(ApiEndpoints.login) ||
              path.contains(ApiEndpoints.refresh);

          if (isAuthEndpoint) {
            _onUnauthorized?.call();
            handler.next(error);
            return;
          }

          if (_onRefreshToken == null) {
            _onUnauthorized?.call();
            handler.next(error);
            return;
          }

          try {
            _refreshCompleter ??= _onRefreshToken!().then((success) {
              if (!success) throw Exception('Refresh failed');
            });

            await _refreshCompleter;

            final opts = error.requestOptions;
            opts.headers[ApiConstants.authorizationHeader] =
                '${ApiConstants.bearerPrefix}$_token';
            final response = await _dio.fetch(opts);
            handler.resolve(response);
          } catch (_) {
            _onUnauthorized?.call();
            handler.next(error);
          } finally {
            _refreshCompleter = null;
          }
        },
      ),
    ]);
  }

  void setToken(String? token) => _token = token;
  void setOnUnauthorized(void Function()? callback) =>
      _onUnauthorized = callback;

  void setOnRefreshToken(Future<bool> Function()? callback) =>
      _onRefreshToken = callback;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}
