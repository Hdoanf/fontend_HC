import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thuctap/core/services/api_client.dart';
import '../models/auth_session.dart';

class AuthApi {
  const AuthApi(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email/password không được để trống');
    }

    if (password.length < 6) {
      throw const AuthException('Mật khẩu tối thiểu 6 ký tự');
    }

    final uri = Uri.parse(_joinUrl(_apiClient.baseUrl, '/auth/login'));
    late final http.Response response;
    try {
      response = await _postJsonWithRedirect(
        uri: uri,
        body: {'email': email, 'password': password},
      );
    } catch (e) {
      throw AuthException(_networkErrorMessage(e, uri));
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          _tryReadMessage(response.body) ??
          'Đăng nhập thất bại (HTTP ${response.statusCode}) tại $uri: ${_compactBody(response.body)}';
      throw AuthException(message);
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final token = payload['token'] as String?;
    final name = payload['name'] as String?;

    return AuthSession(
      accessToken: token ?? '',
      refreshToken: '',
      userId: '',
      name: name ?? email.split('@').first,
      email: email,
    );
  }

  Future<void> signOut() async {
    try {
      final uri = Uri.parse(_joinUrl(_apiClient.baseUrl, '/auth/logout'));
      await _postJsonWithRedirect(uri: uri, body: {});
    } catch (e) {
      print("Logout API error (ignoring): $e");
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty) {
      throw const AuthException('Tên không được để trống');
    }
    if (email.trim().isEmpty || password.isEmpty) {
      throw const AuthException('Email/password không được để trống');
    }
    if (password.length < 6) {
      throw const AuthException('Mật khẩu tối thiểu 6 ký tự');
    }

    final uri = Uri.parse(_joinUrl(_apiClient.baseUrl, '/auth/register'));
    late final http.Response response;
    try {
      response = await _postJsonWithRedirect(
        uri: uri,
        body: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        },
      );
    } catch (e) {
      throw AuthException(_networkErrorMessage(e, uri));
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          _tryReadMessage(response.body) ??
          'Đăng ký thất bại (HTTP ${response.statusCode}) tại $uri: ${_compactBody(response.body)}';
      throw AuthException(message);
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

String _joinUrl(String baseUrl, String path) {
  if (baseUrl.endsWith('/')) {
    return path.startsWith('/')
        ? '$baseUrl${path.substring(1)}'
        : '$baseUrl$path';
  }
  return path.startsWith('/') ? '$baseUrl$path' : '$baseUrl/$path';
}

Map<String, dynamic> _decodePayload(String body) {
  try {
    final jsonValue = jsonDecode(body);
    if (jsonValue is Map<String, dynamic>) {
      final data = jsonValue['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return jsonValue;
    }
  } catch (_) {}
  return <String, dynamic>{};
}

String? _readString(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
  }
  return null;
}

String? _readStringOrInt(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    if (value is int) {
      return value.toString();
    }
  }
  return null;
}

String? _tryReadMessage(String body) {
  try {
    final jsonValue = jsonDecode(body);
    if (jsonValue is Map<String, dynamic>) {
      final message = jsonValue['message'] ?? jsonValue['error'];
      if (message is String && message.isNotEmpty) return message;
      final data = jsonValue['data'];
      if (data is Map<String, dynamic>) {
        final nested = data['message'] ?? data['error'];
        if (nested is String && nested.isNotEmpty) return nested;
      }
    }
  } catch (_) {}
  return null;
}

String _compactBody(String body) {
  final trimmed = body.trim();
  if (trimmed.isEmpty) return 'empty response';
  if (trimmed.length <= 160) return trimmed;
  return '${trimmed.substring(0, 160)}...';
}

String _networkErrorMessage(Object error, Uri uri) {
  final raw = error.toString();
  if (raw.contains('HandshakeException')) {
    return 'API ($uri) đã redirect sang HTTPS nhưng chứng chỉ chưa hợp lệ trên điện thoại.';
  }
  if (raw.contains('XMLHttpRequest error')) {
    return 'Không kết nối được API tại $uri từ web (thường do CORS hoặc API chưa mở mạng).';
  }
  return 'Lỗi kết nối API tại $uri: $raw';
}

Future<http.Response> _postJsonWithRedirect({
  required Uri uri,
  required Map<String, dynamic> body,
}) async {
  var target = uri;
  late http.Response response;
  const redirectCodes = <int>{301, 302, 307, 308};

  for (var attempt = 0; attempt < 3; attempt++) {
    response = await http.post(
      target,
      headers: const {'Accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (!redirectCodes.contains(response.statusCode)) {
      return response;
    }

    final location = response.headers['location'];
    if (location == null || location.trim().isEmpty) {
      return response;
    }
    target = target.resolve(location);
  }

  return response;
}
