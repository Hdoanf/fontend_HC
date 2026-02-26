import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_controller.dart';
import 'package:thuctap/features/fire_alert/presentation/widgets/fire_alert_banner.dart';

import '../mobile/bottom_nav_bar.dart';

class DesktopShellPage extends ConsumerWidget {
  final Widget child;

  const DesktopShellPage({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/devices')) return 1;
    if (location.startsWith('/rooms')) return 2;
    if (location.startsWith('/stats')) return 3;
    if (location.startsWith('/scheduler')) return 4;
    if (location.startsWith(FireAlertRoutes.alerts)) return 5;
    if (location.startsWith('/settings')) return 6;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final fireState = ref.watch(fireAlertControllerProvider);

    ref.listen(fireAlertControllerProvider, (previous, next) {
      final previousId = previous?.lastTriggeredEventId;
      final nextId = next.lastTriggeredEventId;
      if (nextId != null && nextId != previousId && next.activeEvent != null) {
        showFireAlertBanner(
          context: context,
          event: next.activeEvent!,
          onViewPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            context.go(FireAlertRoutes.alerts);
          },
        );
      }
    });

    return Scaffold(
      body: Row(
        children: [
          BottomNavBar(
            selectedIndex: _locationToIndex(location),
            fireAlertBadgeCount: fireState.unreadCount,
            onItemSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/devices');
                  break;
                case 2:
                  context.go('/rooms');
                  break;
                case 3:
                  context.go('/stats');
                  break;
                case 4:
                  context.go('/scheduler');
                  break;
                case 5:
                  context.go(FireAlertRoutes.alerts);
                  break;
                case 6:
                  context.go('/settings');
                  break;
              }
            },
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
