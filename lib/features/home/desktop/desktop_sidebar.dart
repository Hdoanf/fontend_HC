import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/features/auth/presentation/login_controller.dart';

class DesktopSidebar extends ConsumerWidget {
  final String currentRoute;
  final int fireAlertBadgeCount;

  const DesktopSidebar({
    super.key,
    required this.currentRoute,
    this.fireAlertBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isHome = currentRoute == '/';
    final isDevices = currentRoute.startsWith('/devices');
    final isRooms = currentRoute.startsWith('/rooms');
    final isStats = currentRoute.startsWith('/stats');
    final isScheduler = currentRoute.startsWith('/scheduler');
    final isAlerts = currentRoute.startsWith(FireAlertRoutes.alerts);
    final isSettings = currentRoute.startsWith('/settings');

    final session = ref.watch(authControllerProvider).valueOrNull;
    final displayName = session?.name.isNotEmpty == true
        ? session!.name
        : session?.email;
    final initials = _initials(session?.name, session?.email);

    final navItems = [
      _NavItem(Icons.grid_view_rounded, l10n.t('Home'), isHome, () => context.go('/')),
      _NavItem(Icons.devices_other_rounded, l10n.t('Devices'), isDevices, () => context.go('/devices')),
      _NavItem(Icons.meeting_room_rounded, l10n.t('Rooms'), isRooms, () => context.go('/rooms')),
      _NavItem(Icons.analytics_rounded, l10n.t('Stats'), isStats, () => context.go('/stats')),
      _NavItem(Icons.timer_rounded, l10n.t('Scheduler'), isScheduler, () => context.go('/scheduler')),
      _NavItem(Icons.notifications_active_rounded, l10n.t('Alerts'), isAlerts, () => context.go(FireAlertRoutes.alerts), badgeCount: fireAlertBadgeCount),
      _NavItem(Icons.settings_rounded, l10n.t('Settings'), isSettings, () => context.go('/settings')),
    ];

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.desktopSidebar,
        border: Border(right: BorderSide(color: AppColors.borderColor, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// APP LOGO
          _SidebarLogo(label: l10n.t('SmartHome')),

          const SizedBox(height: 48),

          /// NAVIGATION
          ...navItems.map((item) => _SidebarItem(
            icon: item.icon,
            label: item.label,
            isActive: item.isActive,
            onTap: item.onTap,
            badgeCount: item.badgeCount,
          )),

          const Spacer(),

          /// USER PROFILE
          _UserProfileCard(displayName: displayName ?? l10n.t('User'), initials: initials),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;
  _NavItem(this.icon, this.label, this.isActive, this.onTap, {this.badgeCount = 0});
}

class _SidebarLogo extends StatelessWidget {
  final String label;
  const _SidebarLogo({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bolt, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
        ),
      ],
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  final String displayName;
  final String initials;
  const _UserProfileCard({required this.displayName, required this.initials});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const Text('Online', style: TextStyle(color: AppColors.success, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.white54, size: 18),
        ],
      ),
    );
  }
}


String _initials(String? name, String? email) {
  final source = (name?.trim().isNotEmpty == true) ? name!.trim() : email;
  if (source == null || source.trim().isEmpty) return '?';
  final parts = source.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              if (badgeCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white.withOpacity(0.2) : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
