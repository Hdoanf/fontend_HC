import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fire_sensor_data_model.dart';
import '../fire_alert_controller.dart';

final sensorHistoryProvider = FutureProvider.family<List<FireSensorDataModel>, int>((ref, deviceId) async {
  final repository = ref.watch(fireAlertRepositoryProvider);
  return repository.getSensorDataByDeviceId(deviceId);
});
