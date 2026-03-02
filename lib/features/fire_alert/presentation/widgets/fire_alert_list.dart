import 'package:flutter/material.dart';
import '../../domain/fire_alert_state.dart';
import '../../../../core/constants/app_colors.dart';

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: AppColors.textLight.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'No fire alert history.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final color = _statusColor(event.status, event.severity);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_fire_department_rounded, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${event.zoneName} • ${event.sensorName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Temp: ${event.temperatureC.toStringAsFixed(1)}°C | Smoke: ${event.smokePpm.toStringAsFixed(1)} ppm',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (event.status == FireAlertStatus.active)
                  ElevatedButton(
                    onPressed: () => onAcknowledge(event.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _statusText(event.status),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(FireAlertStatus status, FireSeverity severity) {
    if (status == FireAlertStatus.active) {
      switch (severity) {
        case FireSeverity.critical: return const Color(0xFFB91C1C);
        case FireSeverity.high: return const Color(0xFFDC2626);
        case FireSeverity.medium: return const Color(0xFFEA580C);
        case FireSeverity.low: return const Color(0xFFCA8A04);
      }
    }
    if (status == FireAlertStatus.acknowledged) return AppColors.primary;
    if (status == FireAlertStatus.resolved) return AppColors.success;
    return AppColors.textLight;
  }

  String _statusText(FireAlertStatus status) {
    switch (status) {
      case FireAlertStatus.normal: return 'Normal';
      case FireAlertStatus.active: return 'Active';
      case FireAlertStatus.acknowledged: return 'Ack';
      case FireAlertStatus.resolved: return 'Resolved';
    }
  }
}
