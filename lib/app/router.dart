import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:thuctap/features/auth/presentation/pages/desktop_shell_page.dart';
import 'package:thuctap/features/auth/presentation/widgets/profile/desktop/profile_edit_desktop.dart';

import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/auth/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/mobile_shell_page.dart';
import '../features/auth/presentation/widgets/devices/mobile_devices_page.dart';
import '../shared/responsive/responsive_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    /// 🔐 AUTH (không shell)
    GoRoute(path: '/sign-in', builder: (context, state) => const SignInPage()),
    GoRoute(path: '/sign-up', builder: (context, state) => const SignUpPage()),

    /// 📱 APP (có shell)
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
          builder: (context, state) => const MobileDevicesPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const ProfileEditDesktop(),
        ),
      ],
    ),
  ],
);
