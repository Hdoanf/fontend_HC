import 'package:flutter/material.dart';

class DeviceSchedule {
  final int deviceId;
  final String deviceName;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool enabled;

  DeviceSchedule({
    required this.deviceId,
    required this.deviceName,
    required this.startTime,
    required this.endTime,
    this.enabled = true,
  });

  DeviceSchedule copyWith({
    int? deviceId,
    String? deviceName,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? enabled,
  }) {
    return DeviceSchedule(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'endHour': endTime.hour,
      'endMinute': endTime.minute,
      'enabled': enabled,
    };
  }

  factory DeviceSchedule.fromJson(Map<String, dynamic> json) {
    return DeviceSchedule(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      startTime: TimeOfDay(hour: json['startHour'], minute: json['startMinute']),
      endTime: TimeOfDay(hour: json['endHour'], minute: json['endMinute']),
      enabled: json['enabled'],
    );
  }
}
