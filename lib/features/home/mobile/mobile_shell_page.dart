import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';

class MobileShellPage extends StatelessWidget {
  final Widget child;

  const MobileShellPage({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/devices')) return 1;
    if (location.startsWith('/rooms')) return 2;
    if (location.startsWith('/stats')) return 3;
    if (location.startsWith('/scheduler')) return 4;
    if (location.startsWith('/settings')) return 5;
    if (location.startsWith('/profile-edit-mobile')) return 5;
    return 0; // home
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _locationToIndex(location),
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
              context.go('/settings');
              break;
          }
        },
      ),
    );
  }
}
