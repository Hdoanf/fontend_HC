import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/sensor_history_provider.dart';

class FireSensorHistoryDialog extends ConsumerWidget {
  final int deviceId;
  final String sensorName;

  const FireSensorHistoryDialog({
    super.key,
    required this.deviceId,
    required this.sensorName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(sensorHistoryProvider(deviceId));

    return AlertDialog(
      title: Text('Lịch sử: $sensorName'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: historyAsync.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('Không có dữ liệu lịch sử'));
            }
            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = data[index];
                final timeStr = DateFormat('dd/MM/yyyy HH:mm:ss').format(item.createdAt);
                final bool isHigh = item.value >= 50;

                return ListTile(
                  leading: Icon(
                    Icons.thermostat_rounded,
                    color: isHigh ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    '${item.value.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isHigh ? Colors.red : Colors.green,
                    ),
                  ),
                  subtitle: Text(timeStr),
                  trailing: isHigh
                      ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
                      : null,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Lỗi: $err')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}
