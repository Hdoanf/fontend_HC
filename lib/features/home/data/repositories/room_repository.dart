import '../data_sources/room_api.dart';

class RoomRepository {
  final RoomApi _roomApi;

  RoomRepository(this._roomApi);

  Future<List<dynamic>> getRooms(int homeId) => _roomApi.getRooms(homeId);
  Future<Map<String, dynamic>> createRoom({
    required int homeId,
    required String roomName,
    String? description,
  }) => _roomApi.createRoom(
    homeId: homeId,
    roomName: roomName,
    description: description,
  );

  Future<void> deleteRoom(int roomId) => _roomApi.deleteRoom(roomId);
}
