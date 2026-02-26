import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/auth_api.dart';
import '../../data/models/auth_session.dart';
import '../../data/repositories/auth_repository.dart';

final authApiProvider = Provider<AuthApi>((ref) => AuthApi());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(authApiProvider)),
);

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(
      AuthController.new,
    );

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async => null;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signIn(email: email, password: password),
    );
  }

  void signOut() {
    state = const AsyncData(null);
  }
}
