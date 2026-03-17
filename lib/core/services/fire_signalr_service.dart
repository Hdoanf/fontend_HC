import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logging/logging.dart';

class FireSignalRService {
  HubConnection? _hubConnection;
  final String _serverUrl = dotenv.get('SIGNALR_URL', fallback: "http://13.250.103.252:5020/temperatureHub");
  final _audioPlayer = AudioPlayer();
  static const String _soundUrl = "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg";
  
  final _fireEventController = StreamController<(String, double)>.broadcast();
  Stream<(String, double)> get fireEventStream => _fireEventController.stream;

  final _tempDisplayController = StreamController<(String, double)>.broadcast();
  Stream<(String, double)> get tempDisplayStream => _tempDisplayController.stream;

  final _connectionStatusController = StreamController<String>.broadcast();
  Stream<String> get connectionStatusStream => _connectionStatusController.stream;

  bool _isPopupActive = false;

  void init() {
    print("--- SignalR: Khởi động chế độ GIÁM SÁT TOÀN DIỆN ---");
    
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // In ra mọi thông điệp từ thư viện
      if (record.message.contains("Handle message")) {
         print('--- [SIGNALR DỮ LIỆU THÔ]: ${record.message} ---');
      }
    });

    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl)
        .withAutomaticReconnect()
        .configureLogging(Logger("SignalR"))
        .build();

    // BẮT THÊM CÁC TÊN HÀM KHẢ NGHI KHÁC
    final methods = [
      "ReceiveTemperature", "receiveTemperature", 
      "FireAlert", "fireAlert",
      "UpdateTemperature", "UpdateData", "ReceiveData",
      "MqttMessage", "MessageReceived", "SendMessage"
    ];

    for (var m in methods) {
      _hubConnection!.on(m, (args) {
        print("--- [BẮT ĐƯỢC]: Hàm '$m' gửi dữ liệu: $args ---");
        _handleIncomingData(args, isUrgent: m.toLowerCase().contains("fire"));
      });
    }

    _startConnection();
  }

  void _handleIncomingData(List<dynamic>? arguments, {required bool isUrgent}) {
    if (arguments == null || arguments.isEmpty) return;
    final data = arguments[0];
    double? temp;
    String? deviceId;
    
    if (data is Map) {
      temp = (data['temperature'] ?? data['Temperature'] as num?)?.toDouble();
      deviceId = (data['deviceId'] ?? data['DeviceId'])?.toString();
    } else if (data is num) {
      temp = data.toDouble();
    }

    if (temp != null) {
      _tempDisplayController.add((deviceId ?? "unknown", temp));
      if (isUrgent || temp >= 60) _triggerAlert(deviceId ?? "unknown", temp);
    }
  }

  void _triggerAlert(String deviceId, double temp) {
    if (!_isPopupActive) {
      _fireEventController.add((deviceId, temp));
      _isPopupActive = true;
      _playAlarm();
    }
  }

  Future<void> _playAlarm() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(UrlSource(_soundUrl));
    } catch (e) {
      print("Lỗi phát âm thanh: $e");
    }
  }

  Future<void> stopAlarm() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
    } catch (e) {
      print("Lỗi dừng âm thanh: $e");
    }
  }

  void setPopupInactive() {
    _isPopupActive = false;
    stopAlarm();
  }

  Future<void> _startConnection() async {
    try {
      await _hubConnection!.start();
      print("--- [KẾT NỐI HUB THÀNH CÔNG] ---");
      _connectionStatusController.add("Connected");
    } catch (e) {
      print("--- [KẾT NỐI THẤT BẠI]: $e ---");
      _connectionStatusController.add("Disconnected");
    }
  }

  void dispose() {
    _hubConnection?.stop();
    _fireEventController.close();
    _tempDisplayController.close();
    _connectionStatusController.close();
    _audioPlayer.dispose();
  }
}

final fireSignalRServiceProvider = Provider((ref) {
  final service = FireSignalRService();
  service.init();
  return service;
});

final temperatureStreamProvider = StreamProvider<(String, double)>((ref) => ref.watch(fireSignalRServiceProvider).tempDisplayStream);
final fireAlertStreamProvider = StreamProvider<(String, double)>((ref) => ref.watch(fireSignalRServiceProvider).fireEventStream);
final connectionStatusProvider = StreamProvider<String>((ref) => ref.watch(fireSignalRServiceProvider).connectionStatusStream);
