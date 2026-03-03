import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/features/fire_alert/fire_alert_routes.dart';
import 'package:thuctap/core/services/fire_signalr_service.dart';
import 'bottom_nav_bar.dart';

class MobileShellPage extends ConsumerWidget {
  final Widget child;

  const MobileShellPage({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/devices')) return 1;
    if (location.startsWith('/rooms')) return 2;
    if (location.startsWith('/stats')) return 3;
    if (location.startsWith('/scheduler')) return 4;
    if (location.startsWith(FireAlertRoutes.alerts)) return 5;
    if (location.startsWith('/settings')) return 6;
    return 0;
  }

  void _showGlobalFireAlert(BuildContext context, WidgetRef ref, double temp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        title: const Center(
          child: Text("🔥 FIRE ALERT! 🔥", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.yellow, size: 80),
            const SizedBox(height: 16),
            Text(
              "High Temperature Detected: ${temp.toStringAsFixed(1)}°C",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  ref.read(fireSignalRServiceProvider).setPopupInactive();
                  Navigator.pop(context);
                },
                child: const Text("Dismiss", style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red.shade900),
                onPressed: () {
                  ref.read(fireSignalRServiceProvider).setPopupInactive();
                  Navigator.pop(context);
                  context.go(FireAlertRoutes.alerts);
                },
                child: const Text("View Details", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();

    // GLOBAL FIRE LISTENER
    ref.listen(fireAlertStreamProvider, (previous, next) {
      if (next.hasValue) {
        _showGlobalFireAlert(context, ref, next.value!);
      }
    });

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _locationToIndex(location),
        fireAlertBadgeCount: 0,
        onItemSelected: (index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/devices'); break;
            case 2: context.go('/rooms'); break;
            case 3: context.go('/stats'); break;
            case 4: context.go('/scheduler'); break;
            case 5: context.go(FireAlertRoutes.alerts); break;
            case 6: context.go('/settings'); break;
          }
        },
      ),
    );
  }
}
