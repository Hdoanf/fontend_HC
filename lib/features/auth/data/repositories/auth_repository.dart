import '../data_sources/auth_api.dart';
import '../models/auth_session.dart';

class AuthRepository {
  const AuthRepository(this._authApi);

  final AuthApi _authApi;

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) {
    return _authApi.signIn(email: email, password: password);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _authApi.signUp(name: name, email: email, password: password);
  }
}
