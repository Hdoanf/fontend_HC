import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/services/fire_signalr_service.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/device/presentation/providers/device_providers.dart';
import 'package:thuctap/features/home/presentation/providers/home_providers.dart';
import '../fire_alert_controller.dart'; 

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

  DeviceFireStatus copyWith({double? temperature, bool? isAlert, DateTime? lastUpdate, String? name, String? roomName}) {
    return DeviceFireStatus(
      deviceId: deviceId,
      name: name ?? this.name,
      roomName: roomName ?? this.roomName,
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
    _init();
  }

  void _init() {
    // QUAN TRỌNG: Lắng nghe Provider thay vì lắng nghe Stream thủ công
    // Cách này giúp Riverpod tự động hủy sub cũ và sub vào cái mới khi SignalR kết nối lại
    ref.listen(temperatureStreamProvider, (previous, next) {
      next.whenData((event) {
        final (devIdStr, temp) = event;
        _handleIncomingSignal(devIdStr, temp, isAlert: temp >= 60);
      });
    });

    ref.listen(fireAlertStreamProvider, (previous, next) {
      next.whenData((event) {
        final (devIdStr, temp) = event;
        _handleIncomingSignal(devIdStr, temp, isAlert: true);
      });
    });

    ref.listen(homesProvider, (previous, next) {
      if (next.hasValue && next.value!.isNotEmpty) refreshDevices();
    });

    ref.listen(roomsProvider, (previous, next) {
      if (next.hasValue) refreshDevices();
    });

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) refreshDevices();
    });

    if (ref.read(homesProvider).hasValue) refreshDevices();
  }

  void _handleIncomingSignal(String devIdStr, double temp, {required bool isAlert}) {
    final id = int.tryParse(devIdStr);
    if (id == null) return;

    final index = state.indexWhere((s) => s.deviceId == id);
    
    if (index != -1) {
      final updatedSensor = state[index].copyWith(
        temperature: temp, 
        isAlert: isAlert || temp >= 60, 
        lastUpdate: DateTime.now()
      );
      
      final newList = List<DeviceFireStatus>.from(state);
      newList[index] = updatedSensor;
      
      _updateStateAndSort(newList);
    } else {
      // NẾU THIẾT BỊ CHƯA CÓ TRONG DANH SÁCH: Thêm placeholder ngay lập tức!
      final placeholder = DeviceFireStatus(
        deviceId: id,
        name: "Đang nhận diện...",
        roomName: "Hệ thống",
        roomId: -1,
        temperature: temp,
        isAlert: isAlert || temp >= 60,
        lastUpdate: DateTime.now(),
      );
      
      state = [placeholder, ...state];
      // Sau đó quét lại để cập nhật thông tin chuẩn (tên, phòng)
      refreshDevices();
    }
  }

  void _updateStateAndSort(List<DeviceFireStatus> list) {
    list.sort((a, b) {
      if (a.isAlert && !b.isAlert) return -1;
      if (!a.isAlert && b.isAlert) return 1;
      return 0;
    });
    state = [...list];
  }

  Future<void> refreshDevices() async {
    final homes = ref.read(homesProvider).valueOrNull ?? [];
    if (homes.isEmpty) return;

    List<DeviceFireStatus> allSensors = [];
    final fireRepo = ref.read(fireAlertRepositoryProvider);

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
            final devId = dev['deviceId'] ?? dev['id'];
            
            if (type.contains('sensor') || name.contains('bao_chay') || name.contains('cháy') || name.contains('fire')) {
              
              double currentTemp = 0.0;
              bool isAlert = false;

              // Kiểm tra xem thiết bị này đã có dữ liệu realtime mới hơn chưa
              final existingIndex = state.indexWhere((s) => s.deviceId == devId);
              if (existingIndex != -1 && state[existingIndex].lastUpdate != null) {
                currentTemp = state[existingIndex].temperature;
                isAlert = state[existingIndex].isAlert;
              } else {
                try {
                  final history = await fireRepo.getSensorDataByDeviceId(devId);
                  if (history.isNotEmpty) {
                    currentTemp = history.first.value;
                    isAlert = currentTemp >= 60;
                  }
                } catch (e) {}
              }

              allSensors.add(DeviceFireStatus(
                deviceId: devId,
                name: dev['name'] ?? "Fire Sensor",
                roomName: roomName,
                roomId: roomId,
                temperature: currentTemp,
                isAlert: isAlert,
              ));
            }
          }
        }
      } catch (e) {}
    }
    
    _updateStateAndSort(allSensors);
  }
}

final fireSensorProvider = StateNotifierProvider<FireSensorNotifier, List<DeviceFireStatus>>((ref) {
  return FireSensorNotifier(ref);
});
