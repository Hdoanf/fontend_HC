import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';

import 'room_card.dart';

class RoomsSection extends StatelessWidget {
  const RoomsSection({super.key});

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
                onTap: () {
                  // Handle add new room
                },
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
                      Icon(
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
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.paddingMedium,
            mainAxisSpacing: AppSizes.paddingMedium,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.8,
            children: [
              RoomCard(
                roomName: AppStrings.bedRoom,
                roomDetails: AppStrings.fiveRooms,
                backgroundColor: AppColors.roomCardBed,
                image: 'https://img.icons8.com/color/96/sofa.png',
              ),
              RoomCard(
                roomName: AppStrings.livingRoom,
                roomDetails: AppStrings.twoRooms,
                backgroundColor: AppColors.roomCardLiving,
                image: 'https://img.icons8.com/color/240/living-room.png',
              ),
              RoomCard(
                roomName: AppStrings.studyRoom,
                roomDetails: AppStrings.oneRoom,
                backgroundColor: AppColors.roomCardStudy,
                image: 'https://img.icons8.com/color/240/living-room.png',
              ),
              RoomCard(
                roomName: AppStrings.guestRoom,
                roomDetails: AppStrings.twoRooms,
                backgroundColor: AppColors.roomCardGuest,
                image: 'https://img.icons8.com/color/240/living-room.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
