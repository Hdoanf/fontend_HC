import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../mobile/bottom_nav_bar.dart';

class DesktopShellPage extends StatefulWidget {
  final Widget child;

  const DesktopShellPage({super.key, required this.child});

  @override
  State<DesktopShellPage> createState() => _DesktopShellPageState();
}

class _DesktopShellPageState extends State<DesktopShellPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          BottomNavBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);

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
                  context.go('/history');
                  break;
                case 5:
                  context.go('/settings');
                  break;
              }
            },
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
