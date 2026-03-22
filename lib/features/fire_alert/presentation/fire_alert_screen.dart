import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/services/fire_signalr_service.dart';
import 'package:thuctap/features/fire_alert/presentation/providers/fire_sensor_provider.dart';
import 'package:thuctap/features/home/presentation/providers/home_providers.dart';
import 'package:thuctap/features/device/presentation/providers/device_providers.dart';
import 'package:thuctap/core/widgets/top_notice.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/fire_sensor_history_dialog.dart';

class FireAlertScreen extends ConsumerWidget {
  const FireAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensors = ref.watch(fireSensorProvider);
    final statusAsync = ref.watch(connectionStatusProvider);

    // Nhóm sensors theo tên phòng
    final groupedSensors = groupBy(sensors, (DeviceFireStatus s) => s.roomName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Fire Monitoring',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () async {
              showTopNotice(context: context, message: "Đang quét thiết bị...", type: TopNoticeType.info);
              await ref.read(fireSensorProvider.notifier).refreshDevices();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppColors.primary),
            onPressed: () => _showAddDeviceDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection Status
          statusAsync.when(
            data: (status) => _buildStatusBadge(status),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const Text("SignalR Error"),
          ),

          Expanded(
            child: sensors.isEmpty
                ? _buildEmptyState(context, ref)
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: groupedSensors.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 12, top: 8),
                            child: Text(
                              entry.key.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          ...entry.value.map((s) => _FireSensorCard(sensor: s)),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
          ),
          
          if (sensors.any((s) => s.isAlert))
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => ref.read(fireSignalRServiceProvider).setPopupInactive(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.notifications_off_rounded),
                label: const Text("TẮT TẤT CẢ BÁO ĐỘNG", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isConnected = status == "Connected";
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: (isConnected ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: isConnected ? Colors.green : Colors.red, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(status, style: TextStyle(color: isConnected ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sensors_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Chưa có thiết bị cảm biến nào", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddDeviceDialog(context, ref),
            child: const Text("Thêm Cảm Biến Mới"),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context, WidgetRef ref) {
    final rooms = ref.read(roomsProvider).valueOrNull ?? [];
    if (rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng tạo phòng trước")));
      return;
    }

    dynamic selectedRoom = rooms.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Thêm thiết bị báo cháy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Thiết bị sẽ được tạo tự động theo định dạng:\nbao_chay + tên phòng + số hiệu", 
                style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              DropdownButtonFormField<dynamic>(
                value: selectedRoom,
                decoration: const InputDecoration(labelText: "Chọn phòng"),
                items: rooms.map((room) => DropdownMenuItem(value: room, child: Text(room['roomName'] ?? "Unknown"))).toList(),
                onChanged: (val) => setState(() => selectedRoom = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
            ElevatedButton(
              onPressed: () async {
                final roomId = selectedRoom['roomId'] ?? selectedRoom['id'];
                final roomName = selectedRoom['roomName'] ?? "Room";
                
                // Tính toán số hiệu tự tăng cho phòng này
                final existingSensorsInRoom = ref.read(fireSensorProvider)
                    .where((s) => s.roomId == roomId).toList();
                final nextIndex = existingSensorsInRoom.length + 1;
                
                // Định dạng tên: bao_chay + tên phòng + STT
                final formattedName = "bao_chay_${roomName.replaceAll(' ', '')}_$nextIndex";

                await ref.read(devicesByRoomProvider(roomId).notifier).addDevice(
                  name: formattedName,
                  type: "Sensor",
                );
                
                await ref.read(fireSensorProvider.notifier).refreshDevices();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Tạo Tự Động"),
            ),
          ],
        ),
      ),
    );
  }
}

class _FireSensorCard extends StatelessWidget {
  final DeviceFireStatus sensor;
  const _FireSensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final bool isAlert = sensor.isAlert;
    final Color color = isAlert ? Colors.red : (sensor.temperature >= 50 ? Colors.orange : Colors.green);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => FireSensorHistoryDialog(
            deviceId: sensor.deviceId,
            sensorName: sensor.name,
          ),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 6))],
            border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(isAlert ? Icons.local_fire_department_rounded : Icons.thermostat_rounded, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sensor.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text("Device ID: ${sensor.deviceId}", style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      isAlert ? "NGUY HIỂM: PHÁT HIỆN CHÁY!" : (sensor.temperature >= 50 ? "Cảnh báo: Nhiệt độ cao" : "Trạng thái: An toàn"),
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text("${sensor.temperature.toStringAsFixed(1)}°C", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
