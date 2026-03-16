import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireAlertService {
  HubConnection? _hubConnection;
  final _audioPlayer = AudioPlayer();
  final _logger = Logger('FireAlertService');

  // Stream controllers
  final _temperatureController = StreamController<double>.broadcast();
  final _fireAlertController = StreamController<double>.broadcast();

  Stream<double> get temperatureStream => _temperatureController.stream;
  Stream<double> get fireAlertStream => _fireAlertController.stream;

  // Sử dụng địa chỉ IP bạn đã cung cấp
  static const String _serverUrl = "http://192.168.1.81:7156/temperatureHub";
  static const String _soundUrl = "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg";

  Future<void> initialize() async {
    print("--- SignalR: Đang khởi tạo kết nối tới $_serverUrl ---");
    
    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl)
        .withAutomaticReconnect()
        .build();

    _hubConnection?.onreconnecting(({error}) {
      print("--- SignalR: Đang thử kết nối lại... ($error) ---");
    });

    _hubConnection?.onreconnected(({connectionId}) {
      print("--- SignalR: Đã kết nối lại thành công. ID: $connectionId ---");
    });

    _hubConnection?.onclose(({error}) {
      print("--- SignalR: Kết nối đã đóng. Lỗi: $error ---");
    });

    // Lắng nghe sự kiện ReceiveTemperature
    _hubConnection?.on("ReceiveTemperature", (args) {
      print("--- SignalR: Nhận ReceiveTemperature: $args ---");
      _handleReceiveTemperature(args);
    });

    // Lắng nghe sự kiện FireAlert
    _hubConnection?.on("FireAlert", (args) {
      print("--- SignalR: Nhận FireAlert: $args ---");
      _handleFireAlert(args);
    });

    try {
      await _hubConnection?.start();
      print("--- SignalR: Đã kết nối thành công! Trạng thái: ${_hubConnection?.state} ---");
    } catch (e) {
      print("--- SignalR: Lỗi khi start kết nối: $e ---");
    }
  }

  void _handleReceiveTemperature(List<Object?>? args) {
    if (args != null && args.isNotEmpty) {
      try {
        final data = args[0];
        print("--- SignalR: Parsing Temp Data: $data ---");
        
        double? temp;
        if (data is Map) {
          temp = (data['temperature'] as num?)?.toDouble();
        } else if (data is num) {
          temp = data.toDouble();
        }

        if (temp != null) {
          print("--- SignalR: Cập nhật nhiệt độ mới: $temp ---");
          _temperatureController.add(temp);
        }
      } catch (e) {
        print("--- SignalR: Lỗi parsing nhiệt độ: $e ---");
      }
    }
  }

  void _handleFireAlert(List<Object?>? args) {
    if (args != null && args.isNotEmpty) {
      try {
        final data = args[0];
        print("--- SignalR: Parsing Fire Data: $data ---");
        
        double? temp;
        if (data is Map) {
          temp = (data['temperature'] as num?)?.toDouble();
        } else if (data is num) {
          temp = data.toDouble();
        }

        if (temp != null) {
          print("--- SignalR: PHÁT HIỆN CHÁY! Nhiệt độ: $temp ---");
          _fireAlertController.add(temp);
          _playAlarm();
        }
      } catch (e) {
        print("--- SignalR: Lỗi parsing cảnh báo cháy: $e ---");
      }
    }
  }

  Future<void> _playAlarm() async {
    try {
      print("--- SignalR: Đang phát âm thanh cảnh báo ---");
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(UrlSource(_soundUrl));
    } catch (e) {
      print("--- SignalR: Lỗi phát âm thanh: $e ---");
    }
  }

  Future<void> stopAlarm() async {
    try {
      print("--- SignalR: Tắt âm thanh cảnh báo ---");
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
    } catch (e) {
      print("--- SignalR: Lỗi khi dừng âm thanh: $e ---");
    }
  }

  void dispose() {
    _hubConnection?.stop();
    _temperatureController.close();
    _fireAlertController.close();
    _audioPlayer.dispose();
  }
}

final fireAlertServiceProvider = Provider<FireAlertService>((ref) {
  final service = FireAlertService();
  // Khởi tạo ngay lập tức
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final fireAlertStreamProvider = StreamProvider<double>((ref) {
  // Watch service để đảm bảo nó tồn tại
  final service = ref.watch(fireAlertServiceProvider);
  return service.fireAlertStream;
});
