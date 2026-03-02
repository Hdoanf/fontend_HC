import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/app/providers.dart';
import 'package:thuctap/core/services/api_client.dart';
import 'package:thuctap/features/location/data/models/device_location_model.dart';
import 'package:thuctap/core/constants/app_strings.dart';

final roomServiceProvider = Provider<RoomService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RoomService(apiClient);
});

class RoomService {
  final ApiClient _apiClient;

  RoomService(this._apiClient);

  Future<List<DeviceLocationModel>> getDevicesByRoom(String roomName) async {
    try {
      final int roomId = _mapRoomNameToIdInt(roomName);
      final List<dynamic> data = await _apiClient.get('/devices/by-room/$roomId');
      
      if (data.isEmpty) {
        print('Warning: No devices found in room $roomName (ID: $roomId)');
      }

      return data.map((json) {
        return DeviceLocationModel(
          id: json['deviceId'].toString(),
          name: json['name'] ?? 'Unknown Device',
          roomId: json['roomId'].toString(),
          x: 50, 
          y: 50,
          status: json['status'] == true ? 'Connected' : 'Disconnected',
          isOn: json['status'] ?? false,
          icon: _guessIcon(json['type'] ?? ''),
        );
      }).toList();
    } catch (e) {
      print('API Error for room $roomName: $e');
      // Chỉ trả về danh sách trống nếu lỗi để bạn biết API chưa chạy đúng
      return []; 
    }
  }

  String _guessIcon(String type) {
    if (type.toLowerCase().contains('switch')) return 'power';
    if (type.toLowerCase().contains('light')) return 'light';
    return 'default';
  }

  int _mapRoomNameToIdInt(String roomName) {
    if (roomName == AppStrings.livingRoom || roomName == 'phòng kh') return 2;
    if (roomName == AppStrings.bedRoom) return 1;
    // Add more mappings as needed
    return 1; 
  }

  List<DeviceLocationModel> _getMockDevices(String roomName) {
    final Map<String, List<DeviceLocationModel>> mockData = {
      AppStrings.bedRoom: [
        DeviceLocationModel(id: '1', name: 'Air Condition', roomId: 'bedroom', x: 20, y: 30, status: 'Connected', isOn: true, icon: 'ac'),
        DeviceLocationModel(id: '2', name: 'Lamp Light', roomId: 'bedroom', x: 70, y: 25, status: 'Connected', isOn: false, icon: 'lamp'),
      ],
      AppStrings.livingRoom: [
        DeviceLocationModel(id: '6', name: 'TV', roomId: 'living', x: 50, y: 35, status: 'Connected', isOn: true, icon: 'tv'),
      ],
    };
    return mockData[roomName] ?? [];
  }
}
