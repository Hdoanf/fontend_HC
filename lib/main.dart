import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'core/services/fire_signalr_service.dart';
import 'features/fire_alert/presentation/providers/fire_sensor_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    try {
      await dotenv.load(fileName: ".env.example");
    } catch (_) {
      print("Error loading environment file: $e");
    }
  }

  print("API_BASE_URL: ${dotenv.get('API_BASE_URL', fallback: 'Not set')}");

  final container = ProviderContainer();
  // Khởi tạo các service báo cháy ngay khi app mở
  container.read(fireSignalRServiceProvider);
  container.read(fireSensorProvider);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
