import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import '../mobile/room_card.dart';

class DesktopRoomsSection extends StatefulWidget {
  const DesktopRoomsSection({super.key});

  @override
  State<DesktopRoomsSection> createState() => _DesktopRoomsSectionState();
}

class _DesktopRoomsSectionState extends State<DesktopRoomsSection> {
  final List<Map<String, dynamic>> _rooms = [
    {
      'roomName': AppStrings.bedRoom,
      'roomDetails': AppStrings.fiveRooms,
      'backgroundColor': AppColors.roomCardBed,
      'iconColor': const Color(0xFF9D63F4),
      'image': 'https://img.icons8.com/fluency/96/bed.png',
    },
    {
      'roomName': AppStrings.livingRoom,
      'roomDetails': AppStrings.twoRooms,
      'backgroundColor': AppColors.roomCardLiving,
      'iconColor': const Color(0xFF488AFA),
      'image': 'https://img.icons8.com/fluency/96/living-room.png',
    },
    {
      'roomName': AppStrings.studyRoom,
      'roomDetails': AppStrings.oneRoom,
      'backgroundColor': AppColors.roomCardStudy,
      'iconColor': const Color(0xFFF4A845),
      'image': 'https://img.icons8.com/fluency/96/desk.png',
    },
    {
      'roomName': AppStrings.guestRoom,
      'roomDetails': AppStrings.twoRooms,
      'backgroundColor': AppColors.roomCardGuest,
      'iconColor': const Color(0xFF2EBA9B),
      'image': 'https://img.icons8.com/fluency/96/armchair.png',
    },
  ];

  void _addNewRoom(String roomName) {
    setState(() {
      _rooms.add({
        'roomName': roomName,
        'roomDetails': '0 devices',
        'backgroundColor': AppColors.roomCardBed,
        'iconColor': AppColors.primary,
        'image': 'https://img.icons8.com/fluency/96/room.png',
      });
    });
  }

  void _showAddRoomDialog() {
    final TextEditingController roomNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Add New Room', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5, color: AppColors.textPrimary)),
          content: TextField(
            controller: roomNameController,
            decoration: InputDecoration(
              hintText: "Enter room name",
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (roomNameController.text.isNotEmpty) {
                  _addNewRoom(roomNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.myRooms,
              style: TextStyle(
                fontSize: AppSizes.fontXXLarge,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            InkWell(
              onTap: _showAddRoomDialog,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 6),
                    Text(
                      AppStrings.addNew,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSizes.fontMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemCount: _rooms.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final room = _rooms[index];
            return RoomCard(
              roomName: room['roomName'],
              roomDetails: room['roomDetails'],
              backgroundColor: room['backgroundColor'],
              iconColor: room['iconColor'] ?? AppColors.primary,
              image: room['image'],
              onTap: () => GoRouter.of(context)
                  .go('/rooms?roomName=${Uri.encodeComponent(room['roomName'])}'),
            );
          },
        ),
      ],
    );
  }
}
