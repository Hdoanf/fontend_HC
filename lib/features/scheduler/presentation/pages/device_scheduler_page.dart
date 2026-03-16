import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/location/presentation/providers/location_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../model/device_schedule.dart';

class DeviceSchedulerPage extends ConsumerStatefulWidget {
  const DeviceSchedulerPage({super.key});
  @override
  ConsumerState<DeviceSchedulerPage> createState() => _DeviceSchedulerPageState();
}

class _DeviceSchedulerPageState extends ConsumerState<DeviceSchedulerPage> {
  List<DeviceSchedule> schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDevices());
  }

  Future<void> _loadDevices() async {
    final selectedHome = ref.read(selectedHomeProvider);
    if (selectedHome == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final token = ref.read(authControllerProvider).value?.token ?? '';
    final roomApi = ref.read(roomApiProvider);
    if (mounted) setState(() => _isLoading = true);
    try {
      final rooms = await roomApi.fetchRooms(homeId: selectedHome.homeId, token: token);
      List<DeviceSchedule> tempSchedules = [];
      for (final room in rooms) {
        try {
          final devices = await roomApi.fetchDevicesByRoom(room.roomId, token: token);
          for (final d in devices) {
            tempSchedules.add(DeviceSchedule(
              deviceName: d.name,
              startTime: const TimeOfDay(hour: 18, minute: 0),
              endTime: const TimeOfDay(hour: 22, minute: 0),
              enabled: d.status,
            ));
          }
        } catch (_) {}
      }
      if (mounted) setState(() { schedules = tempSchedules; _isLoading = false; });
    } catch (_) { if (mounted) setState(() => _isLoading = false); }
  }

  Future<void> _pickTime(int index, bool isStart) async {
    final current = isStart ? schedules[index].startTime : schedules[index].endTime;
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) {
      setState(() {
        schedules[index] = schedules[index].copyWith(
          startTime: isStart ? picked : null,
          endTime: isStart ? null : picked,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(selectedHomeProvider, (_, __) => _loadDevices());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.t('Device Scheduler'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.desktopTextPrimary)),
            const SizedBox(height: 32),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : schedules.isEmpty
                  ? const Center(child: Text('Không tìm thấy thiết bị nào để đặt lịch.', style: TextStyle(color: AppColors.desktopTextSecondary)))
                  : _buildScheduleGrid(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGrid(AppLocalizations l10n) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 24, mainAxisSpacing: 24, childAspectRatio: 2.5,
      ),
      itemCount: schedules.length,
      itemBuilder: (context, i) => _buildScheduleCard(schedules[i], i, l10n),
    );
  }

  Widget _buildScheduleCard(DeviceSchedule s, int i, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(s.deviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.desktopTextPrimary))),
              Switch(
                value: s.enabled, activeColor: AppColors.primary,
                onChanged: (v) => setState(() => schedules[i] = s.copyWith(enabled: v)),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _TimeDisplay(label: l10n.t('Start'), time: s.startTime, onTap: () => _pickTime(i, true)),
              const SizedBox(width: 16),
              _TimeDisplay(label: l10n.t('End'), time: s.endTime, onTap: () => _pickTime(i, false)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;
  const _TimeDisplay({required this.label, required this.time, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.desktopTextSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(time.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.desktopTextPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
