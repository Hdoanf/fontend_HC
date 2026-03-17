import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/app/providers.dart';
import '../../data/data_sources/auth_api.dart';
import '../../data/models/auth_session.dart';
import '../../data/repositories/auth_repository.dart';
import 'package:thuctap/features/home/presentation/providers/home_providers.dart';

final authApiProvider = Provider<AuthApi>((ref) => AuthApi(ref.read(apiClientProvider)));

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(authApiProvider)),
);

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async => null;

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signIn(email: email, password: password));
    if (result.hasValue && result.value != null) {
      ref.read(apiClientProvider).setToken(result.value!.accessToken);
    }
    state = result;
  }

  Future<bool> signUp({required String name, required String email, required String password}) async {
    state = const AsyncLoading();
    final regRes = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signUp(name: name, email: email, password: password));
    if (regRes.hasError) {
      state = AsyncValue.error(regRes.error!, regRes.stackTrace!);
      return false;
    }

    final loginRes = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signIn(email: email, password: password));
    if (loginRes.hasError) {
      state = AsyncValue.error(loginRes.error!, loginRes.stackTrace!);
      return false;
    }

    if (loginRes.hasValue && loginRes.value != null) {
      ref.read(apiClientProvider).setToken(loginRes.value!.accessToken);
      try {
        await ref.read(homeControllerProvider.notifier).createHome("$name's Home");
      } catch (e) {
        print("Auto home creation error: $e");
      }
      state = loginRes;
      return true;
    }
    state = const AsyncData(null);
    return false;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    
    // 1. Gọi API logout
    await ref.read(authRepositoryProvider).signOut();
    
    // 2. Xóa token
    ref.read(apiClientProvider).setToken(null);
    
    // 3. Reset trạng thái Auth (Tự động kích hoạt homesProvider làm mới vì nó đang watch)
    state = const AsyncData(null);
  }
}
