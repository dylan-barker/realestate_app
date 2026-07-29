import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/providers/api_providers.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? displayName;
  final String? role;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.displayName,
    this.role,
    this.errorMessage,
  });

  const AuthState.uninitialized()
    : status = AuthStatus.uninitialized,
      displayName = null,
      role = null,
      errorMessage = null;

  const AuthState.authenticated({required this.displayName, required this.role})
    : status = AuthStatus.authenticated,
      errorMessage = null;

  const AuthState.unauthenticated({this.errorMessage})
    : status = AuthStatus.unauthenticated,
      displayName = null,
      role = null;

  AuthState copyWith({String? errorMessage}) {
    return AuthState(
      status: status,
      displayName: displayName,
      role: role,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  AuthState build() {
    return const AuthState.uninitialized();
  }

  Future<void> init() async {
    try {
      final raw = await _storage.read(key: 'auth');
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final token = data['token'] as String?;
        final displayName = data['displayName'] as String?;
        final role = data['role'] as String?;

        if (token != null && displayName != null && role != null) {
          final apiClient = ref.read(apiClientProvider);
          apiClient.setToken(token);
          apiClient.setOnUnauthorized(() => logout());
          apiClient.setOnRefreshToken(() => refreshAuth());
          state = AuthState.authenticated(displayName: displayName, role: role);
        } else {
          state = const AuthState.unauthenticated();
        }
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(errorMessage: null);

    try {
      final authService = ref.read(authApiServiceProvider);
      final response = await authService.login(username, password);

      await _storage.write(
        key: 'auth',
        value: jsonEncode({
          'token': response.token,
          'refreshToken': response.refreshToken,
          'displayName': response.displayName,
          'role': response.role,
        }),
      );

      final apiClient = ref.read(apiClientProvider);
      apiClient.setToken(response.token);
      apiClient.setOnUnauthorized(() => logout());
      apiClient.setOnRefreshToken(() => refreshAuth());

      state = AuthState.authenticated(
        displayName: response.displayName,
        role: response.role,
      );
    } catch (e) {
      state = AuthState.unauthenticated(errorMessage: e.toString());
    }
  }

  Future<bool> refreshAuth() async {
    try {
      final raw = await _storage.read(key: 'auth');
      if (raw == null) return false;

      final data = jsonDecode(raw) as Map<String, dynamic>;
      final currentRefreshToken = data['refreshToken'] as String?;
      if (currentRefreshToken == null) return false;

      final authService = ref.read(authApiServiceProvider);
      final response = await authService.refreshToken(currentRefreshToken);

      await _storage.write(
        key: 'auth',
        value: jsonEncode({
          'token': response.token,
          'refreshToken': response.refreshToken,
          'displayName': data['displayName'],
          'role': data['role'],
        }),
      );

      final apiClient = ref.read(apiClientProvider);
      apiClient.setToken(response.token);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    final apiClient = ref.read(apiClientProvider);
    apiClient.setToken(null);
    state = const AuthState.unauthenticated();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
