class DeviceModel {
  const DeviceModel({
    required this.deviceId,
    required this.name,
    required this.type,
    required this.status,
    required this.isActive,
    required this.roomId,
  });

  final int deviceId;
  final String name;
  final String type;
  final bool status;
  final bool isActive;
  final int roomId;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      // Thử đọc cả 'id' và 'deviceId' để tránh lỗi 404 do ID = 0
      deviceId: (json['deviceId'] ?? json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      status: json['status'] == true,
      isActive: json['isActive'] == true,
      roomId: (json['roomId'] as num?)?.toInt() ?? 0,
    );
  }
}
