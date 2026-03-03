import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/services/fire_signalr_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class FireAlertScreen extends ConsumerWidget {
  const FireAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempAsync = ref.watch(temperatureStreamProvider);
    final statusAsync = ref.watch(connectionStatusProvider);

    // Listen for fire alerts to show dialog
    ref.listen(fireAlertStreamProvider, (previous, next) {
      if (next.hasValue) {
        _showFireDialog(context, ref, next.value!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Fire Monitoring', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Connection Status Badge
            statusAsync.when(
              data: (status) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: status == "Connected" ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: status == "Connected" ? Colors.green : Colors.red, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(status, style: TextStyle(color: status == "Connected" ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              loading: () => const Text("Connecting..."),
              error: (_, __) => const Text("SignalR Error"),
            ),
            const Spacer(),
            // Temperature Display
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.textPrimary.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 15))],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.thermostat_rounded, color: AppColors.primary, size: 36),
                    tempAsync.when(
                      data: (temp) => Text('${temp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text("--°C"),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            tempAsync.when(
              data: (temp) => _StatusCard(temp: temp),
              loading: () => const _StatusCard(temp: null),
              error: (_, __) => const _StatusCard(temp: null, isError: true),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ref.read(fireSignalRServiceProvider).setPopupInactive(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: const Text("Xác nhận trạng thái", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showFireDialog(BuildContext context, WidgetRef ref, double temp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Center(child: Text("🔥 FIRE ALERT! 🔥", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.yellow, size: 80),
            const SizedBox(height: 16),
            Text("High Temp Detected: ${temp.toStringAsFixed(1)}°C", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red.shade900),
              onPressed: () {
                ref.read(fireSignalRServiceProvider).setPopupInactive();
                Navigator.of(context).pop();
              },
              child: const Text("Đã xác nhận", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final double? temp;
  final bool isError;
  const _StatusCard({required this.temp, this.isError = false});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.success;
    String title = "Trạng thái: An toàn";
    String sub = "Nhiệt độ trong mức bình thường";
    
    if (isError) { color = Colors.grey; title = "Lỗi cảm biến"; sub = "Không lấy được dữ liệu"; }
    else if (temp == null) { color = Colors.blue; title = "Đang kết nối..."; sub = "Chờ dữ liệu"; }
    else if (temp! >= 60) { color = Colors.red; title = "NGUY HIỂM 🔥"; sub = "Phát hiện dấu hiệu cháy!"; }
    else if (temp! >= 50) { color = Colors.orange; title = "Cảnh báo nhẹ"; sub = "Nhiệt độ đang tăng cao"; }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(temp != null && temp! >= 60 ? Icons.local_fire_department_rounded : Icons.shield_rounded, color: color, size: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 18)), Text(sub, style: TextStyle(color: color.withOpacity(0.7), fontSize: 14))])),
        ],
      ),
    );
  }
}
