import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String roomDetails;
  final Color backgroundColor;
  final Color iconColor;
  final String image;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.roomName,
    required this.roomDetails,
    required this.backgroundColor,
    required this.iconColor,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: image.startsWith('http')
                          ? Image.network(
                              image,
                              fit: BoxFit.contain,
                              color: iconColor,
                              errorBuilder: (context, error, stack) {
                                return Icon(Icons.meeting_room, color: iconColor);
                              },
                            )
                          : Image.asset(
                              image,
                              fit: BoxFit.contain,
                              color: iconColor,
                              errorBuilder: (context, error, stack) {
                                return Icon(Icons.meeting_room, color: iconColor);
                              },
                            ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.textLight.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roomDetails,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
