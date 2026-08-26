class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});
}

class LoginResponse {
  final String token;
  final DateTime expiresAt;
  final String displayName;
  final String role;
  final String refreshToken;

  const LoginResponse({
    required this.token,
    required this.expiresAt,
    required this.displayName,
    required this.role,
    required this.refreshToken,
  });
}

class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});
}

class RefreshTokenResponse {
  final String token;
  final DateTime expiresAt;
  final String refreshToken;

  const RefreshTokenResponse({
    required this.token,
    required this.expiresAt,
    required this.refreshToken,
  });
}

class RegisterRequest {
  final String username;
  final String password;
  final String displayName;

  const RegisterRequest({
    required this.username,
    required this.password,
    required this.displayName,
  });
}
