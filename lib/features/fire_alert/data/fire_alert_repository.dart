import 'dart:async';
import 'dart:math';

import '../domain/fire_alert_state.dart';

class FireAlertRepository {
  final Random _random = Random();

  Future<List<FireEvent>> getInitialEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return <FireEvent>[
      FireEvent(
        id: 'seed_1',
        zoneName: 'Living Room',
        sensorName: 'Smoke Sensor A1',
        temperatureC: 27.2,
        smokePpm: 8.0,
        severity: FireSeverity.low,
        status: FireAlertStatus.normal,
        detectedAt: now.subtract(const Duration(minutes: 3)),
      ),
    ];
  }

  Stream<FireEvent> watchRealtimeAlerts() {
    return Stream<FireEvent>.periodic(
      const Duration(seconds: 10),
      (_) => _generateEvent(),
    );
  }

  Future<void> acknowledge(String eventId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  FireEvent _generateEvent() {
    final now = DateTime.now();
    final isFire = _random.nextInt(10) >= 7;

    if (!isFire) {
      return FireEvent(
        id: 'evt_${now.microsecondsSinceEpoch}',
        zoneName: _pickZone(),
        sensorName: 'Smoke Sensor ${_random.nextInt(4) + 1}',
        temperatureC: 26 + (_random.nextDouble() * 5),
        smokePpm: 6 + (_random.nextDouble() * 12),
        severity: FireSeverity.low,
        status: FireAlertStatus.normal,
        detectedAt: now,
      );
    }

    final severityIndex = _random.nextInt(3) + 1;
    final severity = FireSeverity.values[severityIndex];

    return FireEvent(
      id: 'evt_${now.microsecondsSinceEpoch}',
      zoneName: _pickZone(),
      sensorName: 'Smoke Sensor ${_random.nextInt(4) + 1}',
      temperatureC: 55 + (_random.nextDouble() * 40),
      smokePpm: 75 + (_random.nextDouble() * 200),
      severity: severity,
      status: FireAlertStatus.active,
      detectedAt: now,
    );
  }

  String _pickZone() {
    const zones = <String>['Living Room', 'Kitchen', 'Bed Room', 'Garage'];
    return zones[_random.nextInt(zones.length)];
  }
}
