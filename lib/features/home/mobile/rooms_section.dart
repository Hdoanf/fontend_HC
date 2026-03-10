import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import 'package:thuctap/core/widgets/top_notice.dart';
import '../presentation/providers/home_providers.dart';

class RoomsSection extends ConsumerStatefulWidget {
  const RoomsSection({super.key});

  @override
  ConsumerState<RoomsSection> createState() => _RoomsSectionState();
}

class _RoomsSectionState extends ConsumerState<RoomsSection> {
  int? _roomIdOf(Map<String, dynamic> room) {
    final value = room['id'] ?? room['Id'] ?? room['roomId'] ?? room['RoomId'];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  void _showAddHomeDialog() {
    final TextEditingController homeNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Text(
          'Create Your Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: homeNameController,
          decoration: InputDecoration(
            hintText: "Home Name",
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (homeNameController.text.isNotEmpty) {
                try {
                  await ref
                      .read(homeControllerProvider.notifier)
                      .createHome(homeNameController.text);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (mounted) {
                    showTopNotice(
                      context: context,
                      message: 'Tạo nhà thành công',
                      type: TopNoticeType.success,
                    );
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (mounted) {
                    showTopNotice(
                      context: context,
                      message: 'Tạo nhà thất bại: $e',
                      type: TopNoticeType.error,
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddRoomDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Text(
          'Add New Room',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                hintText: "Room Name",
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                hintText: "Description",
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                try {
                  await ref
                      .read(homeControllerProvider.notifier)
                      .addRoom(nameCtrl.text, descCtrl.text);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (mounted) {
                    showTopNotice(
                      context: context,
                      message: 'Thêm phòng thành công',
                      type: TopNoticeType.success,
                    );
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (mounted) {
                    showTopNotice(
                      context: context,
                      message: 'Thêm phòng thất bại: $e',
                      type: TopNoticeType.error,
                    );
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteRoom(Map<String, dynamic> room) async {
    final roomId = _roomIdOf(room);
    final roomName = (room['roomName'] ?? room['name'] ?? 'Phòng').toString();

    if (roomId == null) {
      showTopNotice(
        context: context,
        message: 'Không xác định được phòng để xóa',
        type: TopNoticeType.error,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Xóa phòng',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text('Bạn có chắc muốn xóa "$roomName"?'),
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
      if (!mounted) return;
      showTopNotice(
        context: context,
        message: 'Xóa phòng thành công',
        type: TopNoticeType.success,
      );
    } catch (e) {
      if (!mounted) return;
      showTopNotice(
        context: context,
        message: 'Xóa phòng thất bại: $e',
        type: TopNoticeType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeId = ref.watch(currentHomeIdProvider);
    final roomsAsync = ref.watch(roomsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.myRooms,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.14),
                    ),
                  ),
                  child: InkWell(
                    onTap: homeId == null
                        ? _showAddHomeDialog
                        : _showAddRoomDialog,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            homeId == null
                                ? Icons.home_rounded
                                : Icons.add_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              homeId == null
                                  ? "Create Home"
                                  : AppStrings.addNew,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (homeId == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text("Click 'Create Home' to get started!"),
              ),
            )
          else
            roomsAsync.when(
              data: (rooms) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
                itemCount: rooms.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final name = (room['roomName'] ?? 'Room').toString();

                  IconData icon = Icons.door_front_door_rounded;
                  Color iconColor = Colors.blue;
                  Color softBg = Colors.blue.withOpacity(0.1);

                  if (name.toLowerCase().contains('living')) {
                    icon = Icons.weekend_rounded;
                    iconColor = Colors.orange;
                    softBg = Colors.orange.withOpacity(0.1);
                  } else if (name.toLowerCase().contains('bed')) {
                    icon = Icons.bed_rounded;
                    iconColor = Colors.purple;
                    softBg = Colors.purple.withOpacity(0.1);
                  } else if (name.toLowerCase().contains('kitchen')) {
                    icon = Icons.restaurant_rounded;
                    iconColor = Colors.green;
                    softBg = Colors.green.withOpacity(0.1);
                  } else if (name.toLowerCase().contains('bath')) {
                    icon = Icons.bathtub_rounded;
                    iconColor = Colors.cyan;
                    softBg = Colors.cyan.withOpacity(0.1);
                  }

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.push('/rooms', extra: room),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: softBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: iconColor,
                                      size: 28,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () => _confirmDeleteRoom(room),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
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
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                (room['description'] ?? 'Smart Room')
                                    .toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Tap to manage',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
        ],
      ),
    );
  }
}
