import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/core/utils/desktop_ui_helper.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_controller.dart';
import 'package:thuctap/features/auth/presentation/login_controller.dart';

class DesktopHeader extends ConsumerWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(authControllerProvider).valueOrNull;
    final displayName = session?.name.isNotEmpty == true ? session!.name : session?.email;
    final initials = DesktopUIHelper.getInitials(session?.name, session?.email);
    final unreadCount = ref.watch(fireAlertControllerProvider.select((state) => state.unreadCount));

    return Row(
      children: [
        _HeaderGreeting(displayName: displayName, l10n: l10n),
        const Spacer(),
        const _HeaderSearch(),
        const SizedBox(width: 16),
        _HeaderNotificationIcon(unreadCount: unreadCount),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary,
          child: Text(initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ],
    );
  }
}

class _HeaderGreeting extends StatelessWidget {
  final String? displayName;
  final AppLocalizations l10n;
  const _HeaderGreeting({this.displayName, required this.l10n});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName == null ? l10n.hiGreeting : '${l10n.t('Hi')}, $displayName!',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        Text(l10n.welcomeBack, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _HeaderSearch extends StatelessWidget {
  const _HeaderSearch();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 44,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white54, size: 20),
          SizedBox(width: 12),
          Text('Search...', style: TextStyle(color: Colors.white38, fontSize: 14)),
        ],
      ),
    );
  }
}

class _HeaderNotificationIcon extends StatelessWidget {
  final int unreadCount;
  const _HeaderNotificationIcon({required this.unreadCount});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.go(FireAlertRoutes.alerts),
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
            if (unreadCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              ),
          ],
        ),
      ),
    );
  }
}
