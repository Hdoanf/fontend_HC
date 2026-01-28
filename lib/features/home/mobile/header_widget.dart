import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.profileAvatarSize / 2,
            backgroundColor: AppColors.surfaceGray,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppSizes.profileAvatarSize / 2,
              ),
              child: Image.network(
                'https://scontent.fhan19-1.fna.fbcdn.net/v/t39.30808-6/480687439_997331652508361_7218280523185220920_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeHMlg0OzlB3v-_6hDYcMD1EjP0bODaIebmM_Rs4Noh5uToEf218ndixjOCvYE883Al_tzYdV9XlSw8EBjNKdvhw&_nc_ohc=4KNq08NCV2EQ7kNvwEnf5z8&_nc_oc=AdlZm3-XbWS9wUTMn6yG-PPtXJEDHTWSicQ-ame6EL57lAq48OuTF3iKpxeAs1_cT6s&_nc_zt=23&_nc_ht=scontent.fhan19-1.fna&_nc_gid=oD2HaRilSSwSImxXAL9RLQ&oh=00_AfoCmenKOfxUe5915P18MWyJxBYQz8e_nH0wyLW6BdQrYw&oe=697F507D',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.hiGreeting,
                  style: const TextStyle(
                    fontSize: AppSizes.fontXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXSmall),
                Text(
                  AppStrings.welcomeBack,
                  style: const TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
