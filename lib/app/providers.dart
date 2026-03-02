import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/api_client.dart';
import '../core/services/logger_service.dart';
import '../core/services/storage_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final storageServiceProvider = Provider<StorageService>(
  (ref) => const StorageService(),
);
final loggerServiceProvider = Provider<LoggerService>(
  (ref) => const LoggerService(),
);
