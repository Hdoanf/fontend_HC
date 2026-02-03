import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/features/devices/desktop_devices_page.dart';
import 'package:thuctap/features/profile/desktop/change_pass.dart';
import 'package:thuctap/features/scheduler/presentation/pages/device_scheduler_page.dart';
import 'package:thuctap/features/scheduler/presentation/pages/mobile_scheduler_page.dart';
import 'package:thuctap/features/home/desktop/desktop_shell_page.dart';
import 'package:thuctap/features/location/presentation/pages/desktop_location_page.dart';
import 'package:thuctap/features/location/presentation/pages/mobile_location_page.dart';
import 'package:thuctap/features/profile/desktop/profile_edit_desktop.dart';
import 'package:thuctap/features/profile/mobile/profile_edit_mobile.dart';
import 'package:thuctap/features/settings/presentation/pages/settings_page_desktop.dart';
import 'package:thuctap/features/stats/presentation/pages/desktop_stats_page.dart';
import 'package:thuctap/features/stats/presentation/pages/mobile_stats_page.dart';
import 'package:thuctap/features/settings/presentation/pages/mobile_settings_page.dart';

import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/home/home_page.dart';
import '../features/home/mobile/mobile_shell_page.dart';
import '../features/devices/mobile_devices_page.dart';
import '../shared/responsive/responsive_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    /// AUTH (không shell)
    GoRoute(path: '/sign-in', builder: (context, state) => const SignInPage()),
    GoRoute(path: '/sign-up', builder: (context, state) => const SignUpPage()),

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
        GoRoute(
          path: '/devices',
          builder: (context, state) {
            return ResponsiveLayout(
              mobile: MobileDevicesPage(),
              tablet: DesktopDevicesPage(),
              web: DesktopDevicesPage(),
            );
          },
        ),
        GoRoute(
          path: '/rooms',
          builder: (context, state) {
            return ResponsiveLayout(
              mobile: MobileLocationPage(),
              tablet: DesktopLocationPage(),
              web: DesktopLocationPage(),
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
          path: '/profile-edit-mobile',
          builder: (context, state) {
            return const ResponsiveLayout(
              mobile: ProfileEditDesktop(),
              tablet: ProfileEditDesktop(),
              web: ProfileEditDesktop(),
            );
          },
        ),
        GoRoute(
          path: '/change-pass',
          builder: (context, state) => const ChangePass(),
        ),
      ],
    ),
  ],
);
