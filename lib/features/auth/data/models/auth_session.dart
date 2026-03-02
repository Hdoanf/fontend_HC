class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.name,
    required this.email,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String name;
  final String email;
}
