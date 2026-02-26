import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fire_alert_controller.dart';
import '../domain/fire_alert_state.dart';
import 'widgets/fire_alert_list.dart';

class FireAlertScreen extends ConsumerWidget {
  const FireAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fireAlertControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Alerts'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(fireAlertControllerProvider.notifier).markAllAsRead();
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatusCard(state: state),
            const SizedBox(height: 12),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FireAlertList(
                      events: state.events,
                      onAcknowledge: (id) {
                        return ref
                            .read(fireAlertControllerProvider.notifier)
                            .acknowledgeAlert(id);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});

  final FireAlertState state;

  @override
  Widget build(BuildContext context) {
    final active = state.activeEvent;
    final bgColor = state.isFireActive
        ? const Color(0xFFFFECEC)
        : const Color(0xFFECFDF5);
    final fgColor = state.isFireActive
        ? const Color(0xFFB91C1C)
        : const Color(0xFF166534);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: fgColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              state.isFireActive
                  ? 'Dang co chay: ${active?.zoneName ?? 'Unknown zone'}'
                  : 'He thong an toan, khong co chay',
              style: TextStyle(color: fgColor, fontWeight: FontWeight.w700),
            ),
          ),
          if (state.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                state.unreadCount > 99 ? '99+' : state.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
