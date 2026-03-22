import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../features/location/presentation/providers/location_providers.dart';
import '../../../../features/home/presentation/providers/home_providers.dart' hide roomApiProvider;
import '../../model/device_schedule.dart';

final schedulerProvider =
    StateNotifierProvider<SchedulerNotifier, List<DeviceSchedule>>((ref) {
      return SchedulerNotifier(ref);
    });

class SchedulerNotifier extends StateNotifier<List<DeviceSchedule>> {
  final Ref ref;
  Timer? _timer;
  static const String _storageKey = 'device_schedules';

  SchedulerNotifier(this.ref) : super([]) {
    _loadSchedules();
    _startTimer();
  }

  Future<void> _loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      try {
        final List<dynamic> decoded = json.decode(data);
        state = decoded.map((item) => DeviceSchedule.fromJson(item)).toList();
      } catch (e) {
        print('Scheduler: Error decoding schedules: $e');
        state = [];
      }
    }
  }

  Future<void> saveSchedules(List<DeviceSchedule> newSchedules) async {
    state = newSchedules;
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(state.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void _startTimer() {
    _timer?.cancel();
    // Kiểm tra mỗi phút
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndExecute();
    });
  }

  void _checkAndExecute() {
    final now = TimeOfDay.fromDateTime(DateTime.now());

    for (final schedule in state) {
      if (!schedule.enabled) continue;

      // Kiểm tra giờ bắt đầu (Bật thiết bị)
      if (schedule.startTime.hour == now.hour &&
          schedule.startTime.minute == now.minute) {
        _updateDeviceStatus(schedule.deviceId, true);
      }

      // Kiểm tra giờ kết thúc (Tắt thiết bị)
      if (schedule.endTime.hour == now.hour &&
          schedule.endTime.minute == now.minute) {
        _updateDeviceStatus(schedule.deviceId, false);
      }
    }
  }

  Future<void> _updateDeviceStatus(int deviceId, bool status) async {
    try {
      final roomApi = ref.read(roomApiProvider);
      await roomApi.updateDeviceStatus(deviceId, status);

      print('Scheduler: Successfully updated device $deviceId to $status');

      // Làm mới danh sách thiết bị để cập nhật UI
      // Vì roomId có thể thay đổi hoặc không biết trước, 
      // ta invalidate các provider liên quan để ép tải lại dữ liệu mới nhất.
      ref.invalidate(roomsProvider);
      // Lưu ý: Do devicesByRoomProvider yêu cầu tham số roomId, 
      // việc invalidate roomsProvider sẽ kích hoạt chuỗi cập nhật nếu UI đang lắng nghe.
    } catch (e) {
      print('Scheduler: Failed to update device $deviceId: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
