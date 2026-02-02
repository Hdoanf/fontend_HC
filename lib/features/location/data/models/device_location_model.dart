class DeviceLocationModel {
  final String id;
  final String name;
  final String roomId;
  final double x;
  final double y;
  final String status;
  final bool isOn;
  final String icon;

  DeviceLocationModel({
    required this.id,
    required this.name,
    required this.roomId,
    required this.x,
    required this.y,
    required this.status,
    required this.isOn,
    required this.icon,
  });

  factory DeviceLocationModel.fromJson(Map<String, dynamic> json) {
    return DeviceLocationModel(
      id: json['id'],
      name: json['name'],
      roomId: json['roomId'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      status: json['status'],
      isOn: json['isOn'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roomId': roomId,
      'x': x,
      'y': y,
      'status': status,
      'isOn': isOn,
      'icon': icon,
    };
  }
}
