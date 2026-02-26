import 'package:flutter/material.dart';

import '../../domain/fire_alert_state.dart';

void showFireAlertBanner({
  required BuildContext context,
  required FireEvent event,
  required VoidCallback onViewPressed,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(
      MaterialBanner(
        backgroundColor: const Color(0xFFFFECEC),
        content: Text(
          'Canh bao chay tai ${event.zoneName} (${event.sensorName})',
          style: const TextStyle(
            color: Color(0xFF991B1B),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const Icon(
          Icons.local_fire_department,
          color: Color(0xFFDC2626),
        ),
        actions: [
          TextButton(onPressed: onViewPressed, child: const Text('Xem ngay')),
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            child: const Text('Dong'),
          ),
        ],
      ),
    );
}
