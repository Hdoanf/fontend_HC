import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopSidebar extends StatelessWidget {
  final String currentRoute;

  const DesktopSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFFF8F9FB),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          /// LOGO / APP NAME
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.home_filled, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'SmartHome',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// MENU
          _SidebarItem(
            icon: Icons.home_filled,
            label: 'Home',
            isActive: currentRoute == '/',
            onTap: () => context.go('/'),
          ),
          _SidebarItem(
            icon: Icons.location_on,
            label: 'Rooms',
            isActive: currentRoute == '/rooms',
            onTap: () => context.go('/rooms'),
          ),
          _SidebarItem(
            icon: Icons.bar_chart,
            label: 'Stats',
            isActive: currentRoute == '/stats',
            onTap: () => context.go('/stats'),
          ),
          _SidebarItem(
            icon: Icons.history,
            label: 'History',
            isActive: currentRoute == '/history',
            onTap: () => context.go('/history'),
          ),
          _SidebarItem(
            icon: Icons.settings,
            label: 'Settings',
            isActive: currentRoute == '/settings',
            onTap: () => context.go('/settings'),
          ),

          const Spacer(),

          /// USER
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(radius: 16),
                SizedBox(width: 8),
                Text('Username'),
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.blue : Colors.grey),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
