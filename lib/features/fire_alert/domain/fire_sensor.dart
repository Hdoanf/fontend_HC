import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireSensor {
  final int id;
  final int roomId;
  final String deviceId;
  final String roomName;
  final double temperature;
  final bool isAlert;

  FireSensor({
    required this.id,
    required this.roomId,
    required this.deviceId,
    required this.roomName,
    this.temperature = 0.0,
    this.isAlert = false,
  });

  FireSensor copyWith({
    double? temperature,
    bool? isAlert,
  }) {
    return FireSensor(
      id: id,
      roomId: roomId,
      deviceId: deviceId,
      roomName: roomName,
      temperature: temperature ?? this.temperature,
      isAlert: isAlert ?? this.isAlert,
    );
  }
}
