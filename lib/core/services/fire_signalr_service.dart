import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FireSignalRService {
  HubConnection? _hubConnection;
  final String _serverUrl = dotenv.get('SIGNALR_URL', fallback: "http://localhost:5020/temperatureHub");
  
  final _fireEventController = StreamController<double>.broadcast();
  Stream<double> get fireEventStream => _fireEventController.stream;

  final _tempDisplayController = StreamController<double>.broadcast();
  Stream<double> get tempDisplayStream => _tempDisplayController.stream;

  final _connectionStatusController = StreamController<String>.broadcast();
  Stream<String> get connectionStatusStream => _connectionStatusController.stream;

  bool _isPopupActive = false;

  void init() {
    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl)
        .withAutomaticReconnect()
        .build();

    _hubConnection!.on("ReceiveTemperature", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        final temp = (data['temperature'] as num?)?.toDouble() ?? 0.0;
        _tempDisplayController.add(temp);
        if (temp >= 60) _triggerAlert(temp);
      }
    });

    _hubConnection!.on("FireAlert", (arguments) {
      double temp = 99.0;
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        temp = (data['temperature'] as num?)?.toDouble() ?? 99.0;
      }
      _triggerAlert(temp);
    });

    _startConnection();
  }

  void _triggerAlert(double temp) {
    if (!_isPopupActive) {
      _fireEventController.add(temp);
      _isPopupActive = true;
    }
  }

  void setPopupInactive() {
    _isPopupActive = false;
  }

  Future<void> _startConnection() async {
    try {
      await _hubConnection!.start();
      _connectionStatusController.add("Connected");
    } catch (e) {
      _connectionStatusController.add("Disconnected");
    }
  }

  void dispose() {
    _hubConnection?.stop();
    _fireEventController.close();
    _tempDisplayController.close();
    _connectionStatusController.close();
  }
}

final fireSignalRServiceProvider = Provider((ref) {
  final service = FireSignalRService();
  service.init();
  return service;
});

final temperatureStreamProvider = StreamProvider<double>((ref) => ref.watch(fireSignalRServiceProvider).tempDisplayStream);
final fireAlertStreamProvider = StreamProvider<double>((ref) => ref.watch(fireSignalRServiceProvider).fireEventStream);
final connectionStatusProvider = StreamProvider<String>((ref) => ref.watch(fireSignalRServiceProvider).connectionStatusStream);
