import 'package:thuctap/core/services/api_client.dart';
import '../../home/data/models/home_models.dart';

class DeviceRepository {
  final ApiClient _apiClient;

  const DeviceRepository(this._apiClient);

  Future<List<DeviceModel>> getDevices() async {
    try {
      final List<dynamic> data = await _apiClient.get('/devices');
      return data.map((json) => DeviceModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleDeviceStatus(int deviceId, bool status) async {
    await _apiClient.patch('/devices/$deviceId/status?status=$status', {});
  }

  Future<void> deleteDevice(int deviceId) async {
    await _apiClient.delete('/devices/$deviceId');
  }

  Future<List<DeviceModel>> getDevicesByRoom(int roomId) async {
    final List<dynamic> data = await _apiClient.get('/devices/by-room/$roomId');
    return data.map((json) => DeviceModel.fromJson(json)).toList();
  }
}
