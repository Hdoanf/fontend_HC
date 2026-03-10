import 'package:thuctap/core/services/api_client.dart';

class DeviceApi {
  final ApiClient _apiClient;

  DeviceApi(this._apiClient);

  Future<List<dynamic>> getDevices() async {
    final response = await _apiClient.get('/devices');
    return response as List<dynamic>;
  }

  Future<List<dynamic>> getDevicesByRoom(int roomId) async {
    final response = await _apiClient.get('/devices/by-room/$roomId');
    return response as List<dynamic>;
  }

  Future<Map<String, dynamic>> createDevice({
    required int roomId,
    required String name,
    required String type,
    bool status = false,
  }) async {
    final response = await _apiClient.post('/devices', {
      'roomId': roomId,
      'name': name,
      'type': type,
      'status': status,
    });
    return response as Map<String, dynamic>;
  }

  Future<void> updateDeviceStatus(int id, bool status) async {
    await _apiClient.patch('/devices/$id/status', {'status': status});
  }

  Future<void> deleteDevice(int id) async {
    await _apiClient.delete('/devices/$id');
  }
}
