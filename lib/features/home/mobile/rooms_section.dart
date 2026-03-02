import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';

import 'room_card.dart';

class RoomsSection extends StatefulWidget {
  const RoomsSection({super.key});

  @override
  State<RoomsSection> createState() => _RoomsSectionState();
}

class _RoomsSectionState extends State<RoomsSection> {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Room', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: roomNameController,
            decoration: InputDecoration(
              hintText: "Enter room name",
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
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
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text(
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
          const SizedBox(height: AppSizes.paddingMedium),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
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
      ),
    );
  }
}
