import '../../../../core/services/api_client.dart';
import '../models/home_models.dart';

class HomeRepository {
  final ApiClient _apiClient;

  HomeRepository(this._apiClient);

  Future<List<HomeModel>> getHomes() async {
    final List<dynamic> data = await _apiClient.get('/Home');
    return data.map((json) => HomeModel.fromJson(json)).toList();
  }

  Future<void> createRoom(String roomName, int homeId) async {
    await _apiClient.post('/Room', {
      'roomName': roomName,
      'homeId': homeId,
    });
  }
}
