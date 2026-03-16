import 'package:thuctap/core/services/api_client.dart';
import '../models/device_model.dart';
import '../models/room_model.dart';

class RoomApi {
  final ApiClient _apiClient;

  RoomApi(this._apiClient);

  Future<List<RoomModel>> fetchRooms({int homeId = 1, String token = ''}) async {
    final data = await _apiClient.get('/Room?homeId=$homeId');
    if (data is! List) return [];
    return data.map((e) => RoomModel.fromJson(e)).toList();
  }

  Future<List<DeviceModel>> fetchDevicesByRoom(int roomId, {String token = ''}) async {
    final data = await _apiClient.get('/devices/by-room/$roomId');
    if (data is! List) return [];
    return data.map((e) => DeviceModel.fromJson(e)).toList();
  }

  Future<void> createDevice({required int roomId, required String name, required String type, String token = ''}) async {
    await _apiClient.post('/devices', {
      'roomId': roomId,
      'name': name,
      'type': type,
      'status': false,
      'isActive': true
    });
  }

  Future<void> updateDeviceStatus(int deviceId, bool isOn, {String token = ''}) async {
    final body = {
      'id': deviceId,
      'deviceId': deviceId,
      'status': isOn,
      'isActive': true
    };
    
    try {
      await _apiClient.put('/devices/$deviceId', body);
    } catch (e) {
      // Fallback for API design quirks if needed, but ApiClient handles common errors
      await _apiClient.put('/devices', body);
    }
  }

  Future<void> deleteDevice(int deviceId, {String token = ''}) async {
    await _apiClient.delete('/devices/$deviceId');
  }

  Future<void> createRoom({required int homeId, required String roomName, String token = ''}) async {
    await _apiClient.post('/Room', {
      'homeId': homeId,
      'roomName': roomName,
      'name': roomName
    });
  }

  Future<void> deleteRoom(int roomId, {String token = ''}) async {
    await _apiClient.delete('/Room/$roomId');
  }
}
