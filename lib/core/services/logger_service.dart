import 'package:flutter/foundation.dart';

class LoggerService {
  const LoggerService();

  void log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
