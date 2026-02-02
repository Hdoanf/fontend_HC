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
      'image': 'https://img.icons8.com/color/96/sofa.png',
    },
    {
      'roomName': AppStrings.livingRoom,
      'roomDetails': AppStrings.twoRooms,
      'backgroundColor': AppColors.roomCardLiving,
      'image': 'https://img.icons8.com/color/240/living-room.png',
    },
    {
      'roomName': AppStrings.studyRoom,
      'roomDetails': AppStrings.oneRoom,
      'backgroundColor': AppColors.roomCardStudy,
      'image': 'https://img.icons8.com/color/240/living-room.png',
    },
    {
      'roomName': AppStrings.guestRoom,
      'roomDetails': AppStrings.twoRooms,
      'backgroundColor': AppColors.roomCardGuest,
      'image': 'https://img.icons8.com/color/240/living-room.png',
    },
  ];

  void _addNewRoom(String roomName) {
    setState(() {
      _rooms.add({
        'roomName': roomName,
        'roomDetails': '1 devices',
        'backgroundColor': AppColors.roomCardGuest,
        'image': 'https://img.icons8.com/color/240/living-room.png',
      });
    });
  }

  void _showAddRoomDialog() {
    final TextEditingController roomNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Room'),
          content: TextField(
            controller: roomNameController,
            decoration: const InputDecoration(hintText: "Enter room name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (roomNameController.text.isNotEmpty) {
                  _addNewRoom(roomNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
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
                  fontSize: AppSizes.fontXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _showAddRoomDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                    vertical: AppSizes.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: AppSizes.iconMedium,
                      ),
                      const SizedBox(width: AppSizes.paddingSmall),
                      const Text(
                        AppStrings.addNew,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
              crossAxisSpacing: AppSizes.paddingMedium,
              mainAxisSpacing: AppSizes.paddingMedium,
              childAspectRatio: 0.8,
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
                image: room['image'],
                onTap: () => GoRouter.of(context).go('/devices'),
              );
            },
          ),
        ],
      ),
    );
  }
}
