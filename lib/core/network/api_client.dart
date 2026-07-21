import 'dart:async';
import 'dart:io' show Platform, HttpClient;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio;
  String? _token;
  void Function()? _onUnauthorized;
  Future<bool> Function()? _onRefreshToken;
  Future<void>? _refreshCompleter;

  ApiClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl:
              baseUrl ??
              (Platform.isAndroid
                  ? 'https://10.0.2.2:7063'
                  : 'https://localhost:7063'),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          followRedirects: true,
        ),
      ) {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: kDebugMode, responseBody: kDebugMode),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
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
              path.contains('/auth/login') || path.contains('/auth/refresh');

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
            opts.headers['Authorization'] = 'Bearer $_token';
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
