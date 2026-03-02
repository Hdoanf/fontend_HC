import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';

import 'device_card.dart';

class FrequentlyUsedSection extends StatelessWidget {
  const FrequentlyUsedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.frequentlyUsed,
                style: TextStyle(
                  fontSize: AppSizes.fontXXLarge,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle see all
                },
                child: const Text(
                  AppStrings.seeAll,
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          const DeviceCard(
            deviceName: AppStrings.airCondition,
            status: AppStrings.connected,
            isConnected: true,
            icon: Icons.ac_unit_rounded,
            initialIsOn: true,
          ),
          const SizedBox(height: 16),
          const DeviceCard(
            deviceName: AppStrings.ceilingFan,
            status: AppStrings.disconnected,
            isConnected: true,
            icon: Icons.mode_fan_off_rounded,
            initialIsOn: false,
          ),
        ],
      ),
    );
  }
}
