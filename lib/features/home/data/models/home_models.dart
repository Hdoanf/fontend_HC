class RoomModel {
  final int roomId;
  final String roomName;
  final int homeId;
  final List<DeviceModel>? devices;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.homeId,
    this.devices,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'],
      roomName: json['roomName'] ?? '',
      homeId: json['homeId'],
      devices: json['devices'] != null
          ? (json['devices'] as List).map((i) => DeviceModel.fromJson(i)).toList()
          : null,
    );
  }
}

class DeviceModel {
  final int deviceId;
  final String name;
  final String type;
  final bool status;
  final int roomId;

  DeviceModel({
    required this.deviceId,
    required this.name,
    required this.type,
    required this.status,
    required this.roomId,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? false,
      roomId: json['roomId'],
    );
  }
}

class HomeModel {
  final int homeId;
  final String name;
  final List<RoomModel>? rooms;

  HomeModel({
    required this.homeId,
    required this.name,
    this.rooms,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      homeId: json['homeId'],
      name: json['name'] ?? '',
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((i) => RoomModel.fromJson(i)).toList()
          : null,
    );
  }
}
