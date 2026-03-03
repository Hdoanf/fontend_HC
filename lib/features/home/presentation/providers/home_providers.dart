import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/app/providers.dart';
import '../../data/data_sources/home_api.dart';
import '../../data/data_sources/room_api.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/room_repository.dart';
import '../../../auth/presentation/login_controller.dart';

final homeApiProvider = Provider<HomeApi>((ref) => HomeApi(ref.read(apiClientProvider)));
final roomApiProvider = Provider<RoomApi>((ref) => RoomApi(ref.read(apiClientProvider)));

final homeRepositoryProvider = Provider<HomeRepository>((ref) => HomeRepository(ref.read(homeApiProvider)));
final roomRepositoryProvider = Provider<RoomRepository>((ref) => RoomRepository(ref.read(roomApiProvider)));

int? _parseId(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

final homesProvider = FutureProvider<List<dynamic>>((ref) async {
  // Lắng nghe trạng thái Auth
  final authState = ref.watch(authControllerProvider);
  
  // Nếu chưa đăng nhập, trả về danh sách trống ngay lập tức
  if (authState.valueOrNull == null) {
    return [];
  }
  
  // Chỉ khi có session mới đi lấy dữ liệu
  print("Fetching homes for current user session...");
  return ref.read(homeRepositoryProvider).getHomes();
});

final currentHomeIdProvider = StateProvider<int?>((ref) {
  final homes = ref.watch(homesProvider).valueOrNull;
  if (homes != null && homes.isNotEmpty) {
    final firstHome = homes.first;
    return _parseId(firstHome['homeId']) ?? _parseId(firstHome['HomeId']) ?? _parseId(firstHome['id']) ?? _parseId(firstHome['Id']);
  }
  return null;
});

final roomsProvider = FutureProvider<List<dynamic>>((ref) async {
  final homeId = ref.watch(currentHomeIdProvider);
  if (homeId == null) return [];
  return ref.read(roomRepositoryProvider).getRooms(homeId);
});

class HomeNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  HomeNotifier(this.ref) : super(const AsyncData(null));

  Future<void> createHome(String name) async {
    state = const AsyncLoading();
    try {
      final res = await ref.read(homeRepositoryProvider).createHome(name);
      final id = _parseId(res['homeId'] ?? res['HomeId'] ?? res['id'] ?? res['Id']);
      if (id != null) {
        final defaultRooms = ['Living Room', 'Bedroom', 'Kitchen', 'Bathroom'];
        for (var rName in defaultRooms) {
          await ref.read(roomRepositoryProvider).createRoom(homeId: id, roomName: rName);
        }
      }
      ref.invalidate(homesProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRoom(String name, String description) async {
    final homeId = ref.read(currentHomeIdProvider);
    if (homeId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(roomRepositoryProvider).createRoom(homeId: homeId, roomName: name, description: description);
      ref.invalidate(roomsProvider);
    });
  }
}

final homeControllerProvider = StateNotifierProvider<HomeNotifier, AsyncValue<void>>((ref) => HomeNotifier(ref));
