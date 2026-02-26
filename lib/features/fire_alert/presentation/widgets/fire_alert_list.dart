import 'package:flutter/material.dart';

import '../../domain/fire_alert_state.dart';

class FireAlertList extends StatelessWidget {
  const FireAlertList({
    super.key,
    required this.events,
    required this.onAcknowledge,
  });

  final List<FireEvent> events;
  final Future<void> Function(String eventId) onAcknowledge;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text('Chua co su kien bao chay trong phien nay.'),
      );
    }

    return ListView.separated(
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.local_fire_department,
              color: _statusColor(event.status, event.severity),
            ),
            title: Text('${event.zoneName} - ${event.sensorName}'),
            subtitle: Text(
              'Nhiet do: ${event.temperatureC.toStringAsFixed(1)}C | Khoi: '
              '${event.smokePpm.toStringAsFixed(1)} ppm',
            ),
            trailing: event.status == FireAlertStatus.active
                ? TextButton(
                    onPressed: () => onAcknowledge(event.id),
                    child: const Text('Acknowledge'),
                  )
                : Text(
                    _statusText(event.status),
                    style: const TextStyle(fontSize: 12),
                  ),
          ),
        );
      },
    );
  }

  Color _statusColor(FireAlertStatus status, FireSeverity severity) {
    if (status == FireAlertStatus.active) {
      switch (severity) {
        case FireSeverity.critical:
          return const Color(0xFF991B1B);
        case FireSeverity.high:
          return const Color(0xFFDC2626);
        case FireSeverity.medium:
          return const Color(0xFFEA580C);
        case FireSeverity.low:
          return const Color(0xFFCA8A04);
      }
    }
    if (status == FireAlertStatus.acknowledged) return const Color(0xFF2563EB);
    if (status == FireAlertStatus.resolved) return const Color(0xFF16A34A);
    return const Color(0xFF6B7280);
  }

  String _statusText(FireAlertStatus status) {
    switch (status) {
      case FireAlertStatus.normal:
        return 'Normal';
      case FireAlertStatus.active:
        return 'Active';
      case FireAlertStatus.acknowledged:
        return 'Acknowledged';
      case FireAlertStatus.resolved:
        return 'Resolved';
    }
  }
}
