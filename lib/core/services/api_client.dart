import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';

class ApiClient {
  final String baseUrl;
  String? _authToken;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? dotenv.get('API_BASE_URL', fallback: AppConstants.baseUrl);

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
    final uri = Uri.parse('$baseUrl$endpoint');
    print('GET: $uri (Auth: ${_authToken != null})');
    try {
      final response = await http.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode} at $uri\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error GET $uri: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(uri, headers: _headers, body: json.encode(data));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode} at $uri\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error POST $uri: $e');
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.put(uri, headers: _headers, body: json.encode(data));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      }
      throw Exception('Failed to put data: ${response.statusCode} at $uri\nBody: ${response.body}');
    } catch (e) {
      print('Error PUT $uri: $e');
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.patch(uri, headers: _headers, body: json.encode(data));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      }
      throw Exception('Failed to patch: ${response.statusCode} at $uri\nBody: ${response.body}');
    } catch (e) {
      print('Error PATCH $uri: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.delete(uri, headers: _headers);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      }
      throw Exception('Failed to delete: ${response.statusCode} at $uri\nBody: ${response.body}');
    } catch (e) {
      print('Error DELETE $uri: $e');
      rethrow;
    }
  }
}
