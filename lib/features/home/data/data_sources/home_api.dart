import 'package:thuctap/core/services/api_client.dart';

class HomeApi {
  final ApiClient _apiClient;

  HomeApi(this._apiClient);

  Future<Map<String, dynamic>> createHome(String name) async {
    final response = await _apiClient.post('/Home', {'name': name});
    return response as Map<String, dynamic>;
  }

  Future<List<dynamic>> getHomes() async {
    final response = await _apiClient.get('/Home');
    return response as List<dynamic>;
  }

  // Bổ sung các phương thức xóa/sửa nếu cần (dựa trên Swagger hiện tại mới thấy GET/POST)
}
