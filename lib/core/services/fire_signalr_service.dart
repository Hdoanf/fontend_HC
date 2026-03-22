import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logging/logging.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';

class FireSignalRService {
  HubConnection? _hubConnection;
  final String _serverUrl = dotenv.get('SIGNALR_URL', fallback: "http://13.250.103.252:5020/temperatureHub");
  final _audioPlayer = AudioPlayer();
  static const String _soundUrl = "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg";
  final String? token;
  
  final _fireEventController = StreamController<(String, double)>.broadcast();
  Stream<(String, double)> get fireEventStream => _fireEventController.stream;

  final _tempDisplayController = StreamController<(String, double)>.broadcast();
  Stream<(String, double)> get tempDisplayStream => _tempDisplayController.stream;

  final _connectionStatusController = StreamController<String>.broadcast();
  Stream<String> get connectionStatusStream => _connectionStatusController.stream;

  bool _isPopupActive = false;

  FireSignalRService({this.token});

  void init() {
    print("--- SignalR: Khởi động kết nối Real-time ---");
    
    final options = HttpConnectionOptions(
      accessTokenFactory: token != null ? () async => token! : null,
    );

    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl, options: options)
        .withAutomaticReconnect()
        .configureLogging(Logger("SignalR"))
        .build();

    // Lắng nghe các sự kiện trạng thái kết nối
    _hubConnection!.onreconnecting(({error}) => _connectionStatusController.add("Reconnecting"));
    _hubConnection!.onreconnected(({connectionId}) => _connectionStatusController.add("Connected"));
    _hubConnection!.onclose(({error}) => _connectionStatusController.add("Disconnected"));

    // ĐĂNG KÝ HÀM CHÍNH XÁC TỪ BACKEND
    _hubConnection!.on("TemperatureUpdated", (args) {
      print("--- [SIGNALR REALTIME]: Nhận dữ liệu mới -> $args ---");
      _handleIncomingData(args);
    });

    // Vẫn giữ các hàm dự phòng khác nếu cần
    _hubConnection!.on("FireAlert", (args) => _handleIncomingData(args, forceAlert: true));

    _startConnection();
  }

  void _handleIncomingData(List<dynamic>? arguments, {bool forceAlert = false}) {
    if (arguments == null || arguments.isEmpty) return;
    
    // BACKEND TRẢ VỀ DẠNG [{...}] nên lấy item đầu tiên
    var data = arguments[0];
    if (data is List && data.isNotEmpty) {
      data = data[0];
    }

    double? temp;
    String? deviceId;
    
    // Xử lý dữ liệu từ Map
    if (data is Map) {
      temp = (data['temperature'] ?? data['Temperature'] ?? data['value'] ?? data['Value'] as num?)?.toDouble();
      deviceId = (data['deviceId'] ?? data['DeviceId'])?.toString();
    } else if (data is num) {
      temp = data.toDouble();
    }

    if (temp != null) {
      final devId = deviceId ?? "unknown";
      _tempDisplayController.add((devId, temp));
      
      // Ngưỡng báo động: Hoặc là hàm FireAlert, hoặc nhiệt độ quá cao (>60)
      if (forceAlert || temp >= 60) {
        _triggerAlert(devId, temp);
      }
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
      print("Lỗi âm thanh: $e");
    }
  }

  Future<void> stopAlarm() async {
    try {
      await _audioPlayer.stop();
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
      if (_hubConnection?.state == HubConnectionState.Disconnected) {
        await _hubConnection!.start();
        print("--- [SIGNALR]: ĐÃ KẾT NỐI REAL-TIME THÀNH CÔNG ---");
        _connectionStatusController.add("Connected");
      }
    } catch (e) {
      print("--- [SIGNALR ERROR]: Không thể kết nối -> $e ---");
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

final fireSignalRServiceProvider = Provider<FireSignalRService>((ref) {
  final authSession = ref.watch(authControllerProvider).valueOrNull;
  final token = authSession?.accessToken;
  
  final service = FireSignalRService(token: token);
  service.init();
  
  ref.onDispose(() => service.dispose());
  return service;
});

final temperatureStreamProvider = StreamProvider<(String, double)>((ref) => ref.watch(fireSignalRServiceProvider).tempDisplayStream);
final fireAlertStreamProvider = StreamProvider<(String, double)>((ref) => ref.watch(fireSignalRServiceProvider).fireEventStream);
final connectionStatusProvider = StreamProvider<String>((ref) => ref.watch(fireSignalRServiceProvider).connectionStatusStream);
