import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import '../presentation/providers/home_providers.dart';

class RoomsSection extends ConsumerStatefulWidget {
  const RoomsSection({super.key});

  @override
  ConsumerState<RoomsSection> createState() => _RoomsSectionState();
}

class _RoomsSectionState extends ConsumerState<RoomsSection> {
  void _showAddHomeDialog() {
    final TextEditingController homeNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Text('Create Your Home', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: homeNameController,
          decoration: InputDecoration(hintText: "Home Name", filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () async {
            if (homeNameController.text.isNotEmpty) {
              await ref.read(homeControllerProvider.notifier).createHome(homeNameController.text);
              if (mounted) Navigator.pop(context);
            }
          }, child: const Text('Create')),
        ],
      ),
    );
  }

  void _showAddRoomDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Text('Add New Room', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(hintText: "Room Name", filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: InputDecoration(hintText: "Description", filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () async {
            if (nameCtrl.text.isNotEmpty) {
              await ref.read(homeControllerProvider.notifier).addRoom(nameCtrl.text, descCtrl.text);
              if (mounted) Navigator.pop(context);
            }
          }, child: const Text('Add')),
        ],
      ),
    );
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
              const Text(AppStrings.myRooms, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5)),
              InkWell(
                onTap: homeId == null ? _showAddHomeDialog : _showAddRoomDialog,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [Icon(homeId == null ? Icons.home_rounded : Icons.add_rounded, color: AppColors.primary, size: 20), const SizedBox(width: 4), Text(homeId == null ? "Create Home" : AppStrings.addNew, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (homeId == null)
            const Center(child: Padding(padding: EdgeInsets.all(40.0), child: Text("Click 'Create Home' to get started!")))
          else
            roomsAsync.when(
              data: (rooms) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85),
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

                  return GestureDetector(
                    onTap: () => context.push('/rooms', extra: room),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: softBg, shape: BoxShape.circle),
                              child: Icon(icon, color: iconColor, size: 32),
                            ),
                            const Spacer(),
                            Text(name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text(room['description'] ?? 'Smart Room', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
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
