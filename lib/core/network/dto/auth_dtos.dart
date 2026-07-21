class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
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

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
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

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      refreshToken: json['refreshToken'] as String,
    );
  }
}
