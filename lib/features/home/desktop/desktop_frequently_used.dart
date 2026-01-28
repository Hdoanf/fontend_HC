import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import 'package:thuctap/features/home/mobile/device_card.dart';

class FrequentlyUsedSection extends StatelessWidget {
  const FrequentlyUsedSection({Key? key}) : super(key: key);

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
                  fontSize: AppSizes.fontXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          DeviceCard(
            deviceName: AppStrings.airCondition,
            status: AppStrings.connected,
            isConnected: true,
            icon: Icons.air,
            initialIsOn: true,
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          DeviceCard(
            deviceName: AppStrings.ceilingFan,
            status: AppStrings.disconnected,
            isConnected: true,
            icon: Icons.wind_power,
            initialIsOn: false,
          ),
        ],
      ),
    );
  }
}
