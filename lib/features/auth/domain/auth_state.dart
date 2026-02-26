import '../data/models/auth_session.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthSession? session;
  final String? errorMessage;
}
