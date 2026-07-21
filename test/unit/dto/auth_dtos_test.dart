import 'package:flutter_test/flutter_test.dart';
import 'package:realestate_app/core/network/dto/auth_dtos.dart';

void main() {
  group('LoginRequest', () {
    test('toJson() returns correct map', () {
      final request = LoginRequest(username: 'agent', password: 'secret');

      final json = request.toJson();

      expect(json['username'], 'agent');
      expect(json['password'], 'secret');
    });
  });

  group('LoginResponse', () {
    test('fromJson() parses response correctly', () {
      final json = {
        'token': 'abc123',
        'expiresAt': '2026-12-31T23:59:59.000',
        'displayName': 'John Agent',
        'role': 'agent',
        'refreshToken': 'refresh-xyz',
      };

      final response = LoginResponse.fromJson(json);

      expect(response.token, 'abc123');
      expect(response.expiresAt.year, 2026);
      expect(response.displayName, 'John Agent');
      expect(response.role, 'agent');
      expect(response.refreshToken, 'refresh-xyz');
    });
  });

  group('RefreshTokenResponse', () {
    test('fromJson() parses response correctly', () {
      final json = {
        'token': 'new-access-token',
        'expiresAt': '2026-12-31T23:59:59.000',
        'refreshToken': 'new-refresh-token',
      };

      final response = RefreshTokenResponse.fromJson(json);

      expect(response.token, 'new-access-token');
      expect(response.refreshToken, 'new-refresh-token');
    });
  });

  group('RefreshTokenRequest', () {
    test('toJson() returns correct map', () {
      final request = RefreshTokenRequest(refreshToken: 'some-token');

      final json = request.toJson();

      expect(json['refreshToken'], 'some-token');
    });
  });
}
