import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = 'http://192.168.1.51:7156/api'});

  Future<dynamic> get(String endpoint) async {
    print('GET: $baseUrl$endpoint');
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      print('Response Status: ${response.statusCode}');
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
    print('POST: $baseUrl$endpoint, Body: $data');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error POST: $e');
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    print('PUT: $baseUrl$endpoint, Body: $data');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      } else {
        throw Exception('Failed to put data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error PUT: $e');
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    print('PATCH: $baseUrl$endpoint, Body: $data');
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      } else {
        throw Exception('Failed to patch: ${response.statusCode}');
      }
    } catch (e) {
      print('Error PATCH: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    print('DELETE: $baseUrl$endpoint');
    try {
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty ? json.decode(response.body) : null;
      } else {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      print('Error DELETE: $e');
      rethrow;
    }
  }
}
