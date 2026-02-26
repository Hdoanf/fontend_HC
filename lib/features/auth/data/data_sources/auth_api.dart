import 'dart:async';

import '../models/auth_session.dart';

class AuthApi {
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email/password không được để trống');
    }

    if (password.length < 6) {
      throw const AuthException('Mật khẩu tối thiểu 6 ký tự');
    }

    return AuthSession(
      accessToken: _hardcodedJwtToken,
      refreshToken: _hardcodedRefreshToken,
      userId: 'u_001',
      email: email,
    );
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

const String _hardcodedJwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
    'eyJzdWIiOiJ1XzAwMSIsImVtYWlsIjoiZGVtb0BleGFtcGxlLmNvbSIsImlhdCI6MTcwMDAwMDAwMCwiZXhwIjoxOTAwMDAwMDAwfQ.'
    'hardcoded-signature';

const String _hardcodedRefreshToken = 'hardcoded-refresh-token-001';
