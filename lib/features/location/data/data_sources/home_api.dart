import 'package:thuctap/core/services/api_client.dart';
import '../models/home_model.dart';

class HomeApi {
  final ApiClient _apiClient;

  HomeApi(this._apiClient);

  Future<List<HomeModel>> fetchHomes({String token = ''}) async {
    // Note: token is handled by ApiClient via setToken/interceptor
    final data = await _apiClient.get('/Home');
    if (data is! List) return [];
    return data.map((e) => HomeModel.fromJson(e)).toList();
  }

  Future<void> createHome({required String name, String token = ''}) async {
    await _apiClient.post('/Home', {
      'name': name,
      'address': '', 
    });
  }

  Future<void> updateHome({required int homeId, required String name, String token = ''}) async {
    await _apiClient.put('/Home/$homeId', {'id': homeId, 'name': name, 'address': ''});
  }

  Future<void> deleteHome(int homeId, {String token = ''}) async {
    await _apiClient.delete('/Home/$homeId');
  }
}
