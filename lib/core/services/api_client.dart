import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final String baseUrl;
  String? _authToken;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? dotenv.get('API_BASE_URL', fallback: 'http://localhost:7156/api');

  // Getter để các Provider có thể theo dõi sự thay đổi của Token
  String? get token => _authToken;

  void setToken(String? token) {
    print("Setting API Token: ${token != null ? 'PRESENT' : 'NULL'}");
    _authToken = token;
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<dynamic> get(String endpoint) async {
    print('GET: $baseUrl$endpoint (Auth: ${_authToken != null})');
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: _headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error GET: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl$endpoint'), headers: _headers, body: json.encode(data));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(Uri.parse('$baseUrl$endpoint'), headers: _headers, body: json.encode(data));
    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isNotEmpty ? json.decode(response.body) : null;
    }
    throw Exception('Failed to put data: ${response.statusCode}');
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    final response = await http.patch(Uri.parse('$baseUrl$endpoint'), headers: _headers, body: json.encode(data));
    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isNotEmpty ? json.decode(response.body) : null;
    }
    throw Exception('Failed to patch: ${response.statusCode}');
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: _headers);
    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isNotEmpty ? json.decode(response.body) : null;
    }
    throw Exception('Failed to delete: ${response.statusCode}');
  }
}
