import '../data_sources/home_api.dart';

class HomeRepository {
  final HomeApi _homeApi;

  HomeRepository(this._homeApi);

  Future<Map<String, dynamic>> createHome(String name) => _homeApi.createHome(name);
  Future<List<dynamic>> getHomes() => _homeApi.getHomes();
}
