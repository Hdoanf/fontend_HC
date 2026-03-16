import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/widgets/top_notice.dart';
import 'package:thuctap/features/home/presentation/providers/home_providers.dart';
import 'package:thuctap/features/device/presentation/providers/device_providers.dart';

class MobileLocationPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialRoomData;
  const MobileLocationPage({super.key, this.initialRoomData});

  @override
  ConsumerState<MobileLocationPage> createState() => _MobileLocationPageState();
}

class _MobileLocationPageState extends ConsumerState<MobileLocationPage> {
  int? selectedRoomId;
  late String selectedRoomName;

  int? _safeParseId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  @override
  void initState() {
    super.initState();
    _updateSelectedRoom(widget.initialRoomData);
  }

  void _updateSelectedRoom(Map<String, dynamic>? data) {
    if (data != null) {
      selectedRoomId = _safeParseId(
        data['id'] ?? data['Id'] ?? data['roomId'] ?? data['RoomId'],
      );
      selectedRoomName = data['roomName'] ?? data['name'] ?? 'Room';
    } else {
      selectedRoomId = null;
      selectedRoomName = 'Select Room';
    }
  }

  IconData _getDeviceIcon(String type, String name) {
    final lowerName = name.toLowerCase();
    final lowerType = type.toLowerCase();
    if (lowerName.contains('fan') || lowerType.contains('fan'))
      return Icons.toys_rounded;
    if (lowerName.contains('light') ||
        lowerName.contains('bulb') ||
        lowerType.contains('light'))
      return Icons.lightbulb_outline_rounded;
    if (lowerName.contains('ac') ||
        lowerName.contains('air') ||
        lowerType.contains('ac'))
      return Icons.air_rounded;
    if (lowerName.contains('tv') || lowerType.contains('tv'))
      return Icons.tv_rounded;
    if (lowerName.contains('purifier')) return Icons.filter_alt_rounded;
    if (lowerName.contains('temp') || lowerName.contains('climate'))
      return Icons.thermostat_rounded;
    return Icons.devices_other_rounded;
  }

  Future<void> _deleteSelectedRoom() async {
    if (selectedRoomId == null) return;

    final roomId = selectedRoomId!;
    final roomName = selectedRoomName;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Xóa phòng',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Bạn có chắc muốn xóa "$roomName"?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(homeControllerProvider.notifier).deleteRoom(roomId);
      ref.invalidate(roomsProvider);
      setState(() {
        selectedRoomId = null;
        selectedRoomName = 'Select Room';
      });
      showTopNotice(
        context: context,
        message: 'Xóa phòng thành công',
        type: TopNoticeType.success,
      );
    } catch (e) {
      showTopNotice(
        context: context,
        message: 'Xóa phòng thất bại: $e',
        type: TopNoticeType.error,
      );
    }
  }

  Future<void> _deleteDevice(int deviceId, String deviceName) async {
    if (selectedRoomId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Xóa thiết bị',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Bạn có chắc muốn xóa "$deviceName"?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(devicesByRoomProvider(selectedRoomId!).notifier)
          .deleteDevice(deviceId);
      if (!mounted) return;
      showTopNotice(
        context: context,
        message: 'Xóa thiết bị thành công',
        type: TopNoticeType.success,
      );
    } catch (e) {
      if (!mounted) return;
      showTopNotice(
        context: context,
        message: 'Xóa thiết bị thất bại: $e',
        type: TopNoticeType.error,
      );
    }
  }

  void _showAddDeviceDialog() {
    if (selectedRoomId == null) return;
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController typeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Text(
          'Add New Device',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "Device Name",
                hintStyle:
                    TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: typeCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "Type (fan, light...)",
                hintStyle:
                    TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                try {
                  await ref
                      .read(devicesByRoomProvider(selectedRoomId!).notifier)
                      .addDevice(name: nameCtrl.text, type: typeCtrl.text);
                  if (mounted) {
                    Navigator.pop(context);
                    showTopNotice(
                      context: this.context,
                      message: 'Thêm thiết bị thành công',
                      type: TopNoticeType.success,
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showTopNotice(
                      context: context,
                      message: 'Error: $e',
                      type: TopNoticeType.error,
                    );
                  }
                }
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomsProvider);
    final devicesAsync = selectedRoomId != null
        ? ref.watch(devicesByRoomProvider(selectedRoomId!))
        : const AsyncData<List<dynamic>>([]);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          selectedRoomName,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          roomsAsync.when(
            data: (rooms) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: rooms.map((room) {
                  final int? roomId = _safeParseId(
                    room['id'] ??
                        room['Id'] ??
                        room['roomId'] ??
                        room['RoomId'],
                  );
                  final isSelected =
                      selectedRoomId != null &&
                      roomId != null &&
                      selectedRoomId == roomId;
                  return GestureDetector(
                    onTap: roomId == null
                        ? null
                        : () => setState(() {
                            selectedRoomId = roomId;
                            selectedRoomName = room['roomName'] ?? 'Room';
                          }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        room['roomName'] ?? 'Unknown',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error loading rooms: $err'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Devices',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (selectedRoomId != null)
                        Row(
                          children: [
                            _ActionIconButton(
                              onTap: _deleteSelectedRoom,
                              icon: Icons.delete_outline_rounded,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            _ActionIconButton(
                              onTap: _showAddDeviceDialog,
                              icon: Icons.add_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (selectedRoomId != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.borderColor.withValues(alpha: 0.8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.meeting_room_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedRoomName,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Them, bat/tat, hoac xoa thiet bi trong phong nay',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: devicesAsync.when(
                      data: (devices) {
                        if (selectedRoomId == null)
                          return const Center(
                            child: Text("Select a room to see devices"),
                          );
                        if (devices.isEmpty)
                          return const Center(child: Text("No devices found"));
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final device = devices[index];
                            final int? id = _safeParseId(
                              device['deviceId'] ??
                                  device['DeviceId'] ??
                                  device['id'] ??
                                  device['Id'],
                            );
                            final bool status = device['status'] ?? false;
                            if (id == null) return const SizedBox();

                            final deviceName = (device['name'] ?? 'Device')
                                .toString();

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.12,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getDeviceIcon(
                                            device['type'] ?? '',
                                            deviceName,
                                          ),
                                          size: 28,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () =>
                                            _deleteDevice(id, deviceName),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withValues(
                                              alpha: 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.error,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    deviceName,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    (device['type'] ?? 'Unknown').toString(),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: status
                                              ? AppColors.success.withValues(
                                                  alpha: 0.12,
                                                )
                                              : AppColors.textLight.withValues(
                                                  alpha: 0.12,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          status ? "Đang bật" : "Đang tắt",
                                          style: TextStyle(
                                            color: status
                                                ? AppColors.success
                                                : AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.75,
                                        child: Switch(
                                          value: status,
                                          activeColor: AppColors.success,
                                          onChanged: (val) {
                                            ref
                                                .read(
                                                  devicesByRoomProvider(
                                                    selectedRoomId!,
                                                  ).notifier,
                                                )
                                                .toggleDeviceStatus(id, status);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, _) =>
                          Center(child: Text('Error loading devices: $err')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.onTap,
    required this.icon,
    required this.color,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
