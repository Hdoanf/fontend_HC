import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'core/services/fire_signalr_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  final container = ProviderContainer();
  // Khởi tạo service báo cháy ngay khi app mở
  container.read(fireSignalRServiceProvider);
  
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}
