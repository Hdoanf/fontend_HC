import '../data_sources/device_api.dart';

class DeviceRepository {
  final DeviceApi _deviceApi;

  DeviceRepository(this._deviceApi);

  Future<List<dynamic>> getDevices() => _deviceApi.getDevices();
  Future<List<dynamic>> getDevicesByRoom(int roomId) =>
      _deviceApi.getDevicesByRoom(roomId);
  Future<Map<String, dynamic>> createDevice({
    required int roomId,
    required String name,
    required String type,
    bool status = false,
  }) => _deviceApi.createDevice(
    roomId: roomId,
    name: name,
    type: type,
    status: status,
  );
  Future<void> updateDeviceStatus(int id, bool status) =>
      _deviceApi.updateDeviceStatus(id, status);
  Future<void> deleteDevice(int id) => _deviceApi.deleteDevice(id);
}
