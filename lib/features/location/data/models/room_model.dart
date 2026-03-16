class RoomModel {
  const RoomModel({
    required this.roomId,
    required this.homeId,
    required this.roomName,
  });

  final int roomId;
  final int homeId;
  final String roomName;

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      // Hỗ trợ cả 'roomId' và 'id' để tương thích với các phiên bản Backend khác nhau
      roomId: (json['roomId'] ?? json['id'] as num?)?.toInt() ?? 0,
      homeId: (json['homeId'] as num?)?.toInt() ?? 0,
      roomName: (json['roomName'] ?? json['name'] ?? '').toString(),
    );
  }
}
