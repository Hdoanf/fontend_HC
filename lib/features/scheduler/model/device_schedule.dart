import 'package:flutter/material.dart';

class DeviceSchedule {
  final String deviceName;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool enabled;

  DeviceSchedule({
    required this.deviceName,
    required this.startTime,
    required this.endTime,
    this.enabled = true,
  });

  DeviceSchedule copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? enabled,
  }) {
    return DeviceSchedule(
      deviceName: deviceName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      enabled: enabled ?? this.enabled,
    );
  }
}