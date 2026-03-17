import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/services/fire_signalr_service.dart';
import 'package:thuctap/features/device/presentation/providers/device_providers.dart';
import 'package:thuctap/features/home/presentation/providers/home_providers.dart';

class DeviceFireStatus {
  final int deviceId;
  final String name;
  final String roomName;
  final int roomId;
  final double temperature;
  final bool isAlert;
  final DateTime? lastUpdate;

  DeviceFireStatus({
    required this.deviceId,
    required this.name,
    required this.roomName,
    required this.roomId,
    this.temperature = 0.0,
    this.isAlert = false,
    this.lastUpdate,
  });

  DeviceFireStatus copyWith({double? temperature, bool? isAlert, DateTime? lastUpdate}) {
    return DeviceFireStatus(
      deviceId: deviceId,
      name: name,
      roomName: roomName,
      roomId: roomId,
      temperature: temperature ?? this.temperature,
      isAlert: isAlert ?? this.isAlert,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

class FireSensorNotifier extends StateNotifier<List<DeviceFireStatus>> {
  final Ref ref;
  FireSensorNotifier(this.ref) : super([]) {
    _listenToSignalR();
    refreshDevices();
  }

  void _listenToSignalR() {
    ref.read(temperatureStreamProvider.stream).listen((event) {
      final (devIdStr, temp) = event;
      _handleIncomingSignal(devIdStr, temp, isAlert: temp >= 60);
    });

    ref.read(fireAlertStreamProvider.stream).listen((event) {
      final (devIdStr, temp) = event;
      _handleIncomingSignal(devIdStr, temp, isAlert: true);
    });
  }

  void _handleIncomingSignal(String devIdStr, double temp, {required bool isAlert}) {
    final id = int.tryParse(devIdStr);
    if (id == null) return;

    final index = state.indexWhere((s) => s.deviceId == id);
    
    if (index != -1) {
      // Nếu thiết bị đã có trong danh sách -> Cập nhật
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            state[i].copyWith(temperature: temp, isAlert: isAlert, lastUpdate: DateTime.now())
          else
            state[i]
      ];
    } else {
      // NẾU CHƯA CÓ TRONG DANH SÁCH -> TỰ ĐỘNG THÊM VÀO (CHẾ ĐỘ AUTO-DETECT)
      print("--- SignalR: Phát hiện thiết bị mới ID $id. Đang tự động thêm vào giao diện... ---");
      final newDetectedSensor = DeviceFireStatus(
        deviceId: id,
        name: "Thiết bị mới phát hiện",
        roomName: "Hệ thống (Auto)",
        roomId: -1,
        temperature: temp,
        isAlert: isAlert,
        lastUpdate: DateTime.now(),
      );
      state = [...state, newDetectedSensor];
    }
  }

  Future<void> refreshDevices() async {
    // Giữ nguyên logic lấy từ DB để đồng bộ
    final homes = ref.read(homesProvider).valueOrNull ?? [];
    List<DeviceFireStatus> allSensors = [];

    for (var home in homes) {
      final homeId = home['homeId'] ?? home['id'];
      if (homeId == null) continue;
      
      try {
        final rooms = await ref.read(roomRepositoryProvider).getRooms(homeId);
        for (var room in rooms) {
          final roomId = room['roomId'] ?? room['id'];
          final roomName = room['roomName'] ?? "Unknown Room";
          final devices = await ref.read(deviceRepositoryProvider).getDevicesByRoom(roomId);
          
          for (var dev in devices) {
            final type = (dev['type'] ?? '').toString().toLowerCase();
            final name = (dev['name'] ?? '').toString().toLowerCase();
            
            if (type.contains('sensor') || name.contains('bao_chay') || name.contains('cháy') || name.contains('fire')) {
              allSensors.add(DeviceFireStatus(
                deviceId: dev['deviceId'] ?? dev['id'],
                name: dev['name'] ?? "Fire Sensor",
                roomName: roomName,
                roomId: roomId,
              ));
            }
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    }
    
    // Hợp nhất danh sách cũ (để giữ các thiết bị auto-detect nếu có)
    final Map<int, DeviceFireStatus> merged = {};
    for (var s in allSensors) merged[s.deviceId] = s;
    for (var s in state) {
      if (merged.containsKey(s.deviceId)) {
        merged[s.deviceId] = merged[s.deviceId]!.copyWith(
          temperature: s.temperature,
          isAlert: s.isAlert,
          lastUpdate: s.lastUpdate,
        );
      } else if (s.roomId == -1) {
        merged[s.deviceId] = s;
      }
    }
    
    state = merged.values.toList();
  }
}

final fireSensorProvider = StateNotifierProvider<FireSensorNotifier, List<DeviceFireStatus>>((ref) {
  return FireSensorNotifier(ref);
});
