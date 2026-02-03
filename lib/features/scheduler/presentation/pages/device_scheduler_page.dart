import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../model/device_schedule.dart';

class DeviceSchedulerPage extends StatefulWidget {
  const DeviceSchedulerPage({super.key});

  @override
  State<DeviceSchedulerPage> createState() => _DeviceSchedulerPageState();
}

class _DeviceSchedulerPageState extends State<DeviceSchedulerPage> {
  final List<DeviceSchedule> schedules = [
    DeviceSchedule(
      deviceName: 'Air Conditioner',
      startTime: const TimeOfDay(hour: 18, minute: 0),
      endTime: const TimeOfDay(hour: 22, minute: 0),
    ),
    DeviceSchedule(
      deviceName: 'Living Room Lamp',
      startTime: const TimeOfDay(hour: 19, minute: 0),
      endTime: const TimeOfDay(hour: 23, minute: 30),
    ),
    DeviceSchedule(
      deviceName: 'Washing Machine',
      startTime: const TimeOfDay(hour: 6, minute: 0),
      endTime: const TimeOfDay(hour: 7, minute: 30),
    ),
  ];

  Future<void> _pickTime(int index, bool isStart) async {
    final current = isStart
        ? schedules[index].startTime
        : schedules[index].endTime;

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
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Device Scheduler'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView.separated(
          itemCount: schedules.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, i) {
            final s = schedules[i];

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 12),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DEVICE NAME + SWITCH
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.deviceName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: s.enabled,
                        activeColor: AppColors.primary,
                        onChanged: (v) {
                          setState(() {
                            schedules[i] = s.copyWith(enabled: v);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// TIME CONTROLS
                  Row(
                    children: [
                      _TimeBox(
                        label: 'Start',
                        time: s.startTime,
                        onTap: () => _pickTime(i, true),
                      ),
                      const SizedBox(width: 16),
                      _TimeBox(
                        label: 'End',
                        time: s.endTime,
                        onTap: () => _pickTime(i, false),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ================= TIME BOX =================

class _TimeBox extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimeBox({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time.format(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
