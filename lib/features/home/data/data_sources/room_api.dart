import 'package:thuctap/core/services/api_client.dart';

class RoomApi {
  final ApiClient _apiClient;

  RoomApi(this._apiClient);

  Future<List<dynamic>> getRooms(int homeId) async {
    final response = await _apiClient.get('/Room?homeId=$homeId');
    return response as List<dynamic>;
  }

  Future<Map<String, dynamic>> createRoom({
    required int homeId,
    required String roomName,
    String? description,
  }) async {
    final response = await _apiClient.post('/Room', {
      'homeId': homeId,
      'roomName': roomName,
      'description': description ?? '',
    });
    return response as Map<String, dynamic>;
  }
}
