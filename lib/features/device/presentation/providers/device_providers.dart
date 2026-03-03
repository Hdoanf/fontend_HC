import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/app/providers.dart';
import '../../data/data_sources/device_api.dart';
import '../../data/repositories/device_repository.dart';

final deviceApiProvider = Provider<DeviceApi>((ref) => DeviceApi(ref.read(apiClientProvider)));
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) => DeviceRepository(ref.read(deviceApiProvider)));

// Helper để lấy ID an toàn
int? _parseId(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

class DevicesByRoomNotifier extends FamilyAsyncNotifier<List<dynamic>, int> {
  @override
  Future<List<dynamic>> build(int arg) async {
    return ref.watch(deviceRepositoryProvider).getDevicesByRoom(arg);
  }

  Future<void> toggleDeviceStatus(int deviceId, bool currentStatus) async {
    final previousState = state;

    // 1. Optimistic Update
    if (state.hasValue) {
      final updatedList = state.value!.map((device) {
        final id = _parseId(device['deviceId']) ?? _parseId(device['DeviceId']) ?? _parseId(device['id']) ?? _parseId(device['Id']);
        if (id == deviceId) {
          return {...device, 'status': !currentStatus};
        }
        return device;
      }).toList();
      state = AsyncData(updatedList);
    }

    // 2. API Call
    try {
      await ref.read(deviceRepositoryProvider).updateDeviceStatus(deviceId, !currentStatus);
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> addDevice({required String name, required String type}) async {
    state = const AsyncLoading();
    try {
      await ref.read(deviceRepositoryProvider).createDevice(
        roomId: arg,
        name: name,
        type: type,
        status: true,
      );
      ref.invalidateSelf();
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }
}

final devicesByRoomProvider = AsyncNotifierProviderFamily<DevicesByRoomNotifier, List<dynamic>, int>(
  DevicesByRoomNotifier.new,
);
