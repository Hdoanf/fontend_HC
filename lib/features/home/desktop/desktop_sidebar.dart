import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

class DesktopSidebar extends StatelessWidget {
  final String currentRoute;

  const DesktopSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.desktopSidebar,
        border: Border(
          right: BorderSide(color: AppColors.desktopBorderColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingMedium,
      ),
      child: Column(
        children: [
          /// LOGO / APP NAME
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.hub_rounded, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Text(
                  'SmartHome',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.w800,
                    color: AppColors.desktopTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// MENU
          _SidebarItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentRoute == '/',
            onTap: () => context.go('/'),
          ),
          _SidebarItem(
            icon: Icons.location_on_rounded,
            label: 'Rooms',
            isActive: currentRoute.startsWith('/rooms'),
            onTap: () => context.go('/rooms'),
          ),
          _SidebarItem(
            icon: Icons.bar_chart_rounded,
            label: 'Stats',
            isActive: currentRoute.startsWith('/stats'),
            onTap: () => context.go('/stats'),
          ),
          _SidebarItem(
            icon: Icons.access_time_filled_rounded,
            label: 'Scheduler',
            isActive: currentRoute.startsWith('/scheduler'),
            onTap: () => context.go('/scheduler'),
          ),
          _SidebarItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            isActive: currentRoute.startsWith('/settings'),
            onTap: () => context.go('/settings'),
          ),

          const Spacer(),

          /// USER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.desktopCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.OmJICjo6Xt-Ay8oWfxkGNQHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3'),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User',
                        style: TextStyle(
                          color: AppColors.desktopTextPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'View Profile',
                        style: TextStyle(
                          color: AppColors.desktopTextSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
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

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isActive ? AppColors.primary : AppColors.desktopTextTertiary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.desktopTextSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
