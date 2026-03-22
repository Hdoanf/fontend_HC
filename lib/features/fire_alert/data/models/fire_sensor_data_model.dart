class FireSensorDataModel {
  final int dataId;
  final int deviceId;
  final double value;
  final DateTime createdAt;
  final dynamic device;

  FireSensorDataModel({
    required this.dataId,
    required this.deviceId,
    required this.value,
    required this.createdAt,
    this.device,
  });

  factory FireSensorDataModel.fromJson(Map<String, dynamic> json) {
    return FireSensorDataModel(
      dataId: json['dataId'] as int,
      deviceId: json['deviceId'] as int,
      value: (json['value'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      device: json['device'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataId': dataId,
      'deviceId': deviceId,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'device': device,
    };
  }
}
