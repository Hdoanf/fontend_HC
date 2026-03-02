import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import 'package:thuctap/features/auth/presentation/login_controller.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_controller.dart';

class DesktopHeader extends ConsumerWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).valueOrNull;
    final displayName = (session?.name ?? '').trim();
    final greeting = displayName.isEmpty ? 'Hi, User' : 'Hi, $displayName';
    final unreadCount = ref.watch(
      fireAlertControllerProvider.select((state) => state.unreadCount),
    );

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
          ),
          child: CircleAvatar(
            radius: AppSizes.profileAvatarSize / 1.5,
            backgroundColor: AppColors.surfaceGray,
            backgroundImage: const NetworkImage(
              'https://th.bing.com/th/id/OIP.OmJICjo6Xt-Ay8oWfxkGNQHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingLarge),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.welcomeBack,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const Spacer(),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: IconButton(
            padding: const EdgeInsets.all(12),
            onPressed: () => context.go(FireAlertRoutes.alerts),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_rounded, color: AppColors.textPrimary, size: 28),
                if (unreadCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
