import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/features/scheduler/presentation/pages/device_scheduler_page.dart';
import 'package:thuctap/features/scheduler/presentation/pages/mobile_scheduler_page.dart';
import 'package:thuctap/features/home/desktop/desktop_shell_page.dart';
import 'package:thuctap/features/location/presentation/pages/desktop_location_page.dart';
import 'package:thuctap/features/location/presentation/pages/mobile_location_page.dart';
import 'package:thuctap/features/settings/presentation/pages/settings_page_desktop.dart';
import 'package:thuctap/features/stats/presentation/pages/desktop_stats_page.dart';
import 'package:thuctap/features/stats/presentation/pages/mobile_stats_page.dart';
import 'package:thuctap/features/settings/presentation/pages/mobile_settings_page.dart';
import 'package:thuctap/features/auth/auth_routes.dart';
import 'package:thuctap/features/auth/presentation/login_screen.dart';
import 'package:thuctap/features/device/device_routes.dart';
import 'package:thuctap/features/device/presentation/device_screen.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_screen.dart';

import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/home/home_page.dart';
import '../features/home/mobile/mobile_shell_page.dart';
import '../features/home/presentation/pages/my_homes_page.dart';
import '../core/utils/responsive_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AuthRoutes.signIn,
  routes: [
    /// AUTH (không shell)
    GoRoute(
      path: AuthRoutes.signIn,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AuthRoutes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),

    /// APP (có shell)
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveLayout(
          mobile: MobileShellPage(child: child),
          tablet: MobileShellPage(child: child),
          web: DesktopShellPage(child: child),
        );
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/my-homes', builder: (context, state) => const MyHomesPage()),
        GoRoute(
          path: DeviceRoutes.devices,
          builder: (context, state) => const DeviceScreen(),
        ),
        GoRoute(
          path: '/rooms',
          builder: (context, state) {
            final roomData = state.extra as Map<String, dynamic>?;
            return ResponsiveLayout(
              mobile: MobileLocationPage(initialRoomData: roomData),
              tablet: MobileLocationPage(initialRoomData: roomData),
              web: MobileLocationPage(initialRoomData: roomData),
            );
          },
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) {
            return const ResponsiveLayout(
              mobile: MobileStatsPage(),
              tablet: StatEnergyPage(),
              web: StatEnergyPage(),
            );
          },
        ),
        GoRoute(
          path: '/scheduler',
          builder: (context, state) {
            return const ResponsiveLayout(
              mobile: MobileSchedulerPage(),
              tablet:
                  DeviceSchedulerPage(), // Placeholder for desktop scheduler
              web: DeviceSchedulerPage(), // Placeholder for desktop scheduler
            );
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) {
            return const ResponsiveLayout(
              mobile: MobileSettingsPage(),
              tablet: SettingsPageDesktop(),
              web: SettingsPageDesktop(),
            );
          },
        ),
        GoRoute(
          path: FireAlertRoutes.alerts,
          builder: (context, state) => const FireAlertScreen(),
        ),
      ],
    ),
  ],
);
