import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../features/location/presentation/providers/location_providers.dart';
import '../../../home/presentation/providers/home_providers.dart' hide roomApiProvider; // Hide to prevent ambiguous import
import '../providers/scheduler_provider.dart';
import '../../model/device_schedule.dart';

class MobileSchedulerPage extends ConsumerStatefulWidget {
  const MobileSchedulerPage({super.key});

  @override
  ConsumerState<MobileSchedulerPage> createState() => _MobileSchedulerPageState();
}

class _MobileSchedulerPageState extends ConsumerState<MobileSchedulerPage> {
  List<DeviceSchedule> localSchedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDevices());
  }

  Future<void> _loadDevices() async {
    final currentHomeId = ref.read(currentHomeIdProvider);
    
    // Nếu chưa chọn nhà, thử lấy nhà đầu tiên từ danh sách
    int? targetHomeId = currentHomeId;
    if (targetHomeId == null) {
      final homesAsync = ref.read(homesProvider);
      homesAsync.whenData((homes) {
        if (homes.isNotEmpty) {
          final firstHome = homes.first;
          final dynamic rawId = firstHome['homeId'] ?? firstHome['HomeId'] ?? firstHome['id'] ?? firstHome['Id'];
          targetHomeId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
          if (targetHomeId != null) {
            ref.read(currentHomeIdProvider.notifier).state = targetHomeId;
          }
        }
      });
    }

    if (targetHomeId == null) {
      print('Scheduler: Still no home selected after checking list');
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final token = ref.read(authControllerProvider).value?.token ?? '';
    final roomApi = ref.read(roomApiProvider);
    final savedSchedules = ref.read(schedulerProvider);

    if (mounted) setState(() => _isLoading = true);
    try {
      print('Scheduler: Fetching rooms for home $targetHomeId');
      final rooms = await roomApi.fetchRooms(homeId: targetHomeId!, token: token);
      List<DeviceSchedule> tempSchedules = [];
      
      // Khởi tạo danh sách từ những gì đã lưu trước đó
      tempSchedules.addAll(savedSchedules);

      for (final room in rooms) {
        try {
          final devices = await roomApi.fetchDevicesByRoom(room.roomId, token: token);
          for (final d in devices) {
            // Nếu thiết bị từ API chưa có trong danh sách hiển thị, thì thêm vào
            if (!tempSchedules.any((s) => s.deviceId == d.deviceId)) {
              tempSchedules.add(DeviceSchedule(
                deviceId: d.deviceId,
                deviceName: d.name,
                startTime: const TimeOfDay(hour: 18, minute: 0),
                endTime: const TimeOfDay(hour: 22, minute: 0),
                enabled: false,
              ));
            }
          }
        } catch (e) {
          print('Scheduler: Error fetching devices for room ${room.roomId}: $e');
        }
      }
      
      print('Scheduler: UI will display ${tempSchedules.length} devices');
      if (mounted) setState(() { localSchedules = tempSchedules; _isLoading = false; });
    } catch (e) { 
      print('Scheduler: General error loading devices: $e');
      if (mounted) setState(() => _isLoading = false); 
    }

  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    await ref.read(schedulerProvider.notifier).saveSchedules(localSchedules);
    if (mounted) {
      setState(() => _isLoading = false);
      showTopNotice(
        context: context,
        message: 'Lịch trình đã được lưu thành công!',
        type: TopNoticeType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHomeId = ref.watch(currentHomeIdProvider);
    // Lắng nghe sự thay đổi của nhà để tải lại thiết bị
    ref.listen(currentHomeIdProvider, (prev, next) {
      if (prev != next) _loadDevices();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Scheduler',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          if (localSchedules.isNotEmpty)
            IconButton(
              onPressed: _isLoading ? null : _saveChanges,
              icon: const Icon(Icons.check_rounded, color: AppColors.primary),
            ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSizes.paddingMedium, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : currentHomeId == null 
          ? _buildEmptyState('Please select a home first.')
          : localSchedules.isEmpty
            ? _buildEmptyState('No devices found in this home.')
            : _buildScheduledActionList(localSchedules),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_work_outlined, size: 64, color: AppColors.textLight.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadDevices,
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

  Widget _buildScheduledActionList(List<DeviceSchedule> actions) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final result = await showDialog<DeviceSchedule>(
                  context: context,
                  builder: (context) => _EditScheduleDialog(initialAction: action),
                );
                if (result != null) {
                  setState(() => localSchedules[index] = result);
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.timer_outlined, color: AppColors.primary, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action.deviceName,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 16, letterSpacing: -0.3),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start: ${action.startTime.format(context)} | End: ${action.endTime.format(context)}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: action.enabled,
                      onChanged: (val) {
                        setState(() => localSchedules[index] = action.copyWith(enabled: val));
                      },
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EditScheduleDialog extends StatefulWidget {
  final DeviceSchedule initialAction;
  const _EditScheduleDialog({required this.initialAction});

  @override
  State<_EditScheduleDialog> createState() => _EditScheduleDialogState();
}

class _EditScheduleDialogState extends State<_EditScheduleDialog> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialAction.startTime;
    _endTime = widget.initialAction.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Text('Edit Schedule', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeTile('Start Time', _startTime, (t) => setState(() => _startTime = t)),
          const SizedBox(height: 16),
          _buildTimeTile('End Time', _endTime, (t) => setState(() => _endTime = t)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(widget.initialAction.copyWith(startTime: _startTime, endTime: _endTime));
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTimeTile(String label, TimeOfDay time, Function(TimeOfDay) onPicked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        trailing: Text(time.format(context), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
        onTap: () async {
          final picked = await showTimePicker(context: context, initialTime: time);
          if (picked != null) onPicked(picked);
        },
      ),
    );
  }
}
