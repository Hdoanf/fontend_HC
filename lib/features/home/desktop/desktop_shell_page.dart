import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/services/fire_signalr_service.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_dialog.dart';
import 'package:thuctap/features/fire_alert/presentation/fire_alert_controller.dart';
import 'desktop_sidebar.dart';

class DesktopShellPage extends ConsumerStatefulWidget {
  final Widget child;

  const DesktopShellPage({super.key, required this.child});

  @override
  ConsumerState<DesktopShellPage> createState() => _DesktopShellPageState();
}

class _DesktopShellPageState extends ConsumerState<DesktopShellPage> {
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final fireState = ref.watch(fireAlertControllerProvider);

    // Listen for SignalR Fire Alerts
    ref.listen<AsyncValue<(String, double)>>(fireAlertStreamProvider, (prev, next) {
      next.whenData((data) {
        final (deviceId, temperature) = data;
        if (!_isDialogOpen) {
          _isDialogOpen = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FireAlertDialog(
              temperature: temperature,
              onClose: () {
                ref.read(fireSignalRServiceProvider).stopAlarm();
                Navigator.of(context).pop();
                _isDialogOpen = false;
              },
            ),
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 1. BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/living_room.png', // Modern kitchen/living room
              fit: BoxFit.cover,
            ),
          ),

          /// 2. OVERLAY GRADIENT (Warm & Dark)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    const Color(0xFF2D1B00).withOpacity(0.7), // Deep orange-black
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          /// 3. MAIN CONTENT
          Row(
            children: [
              DesktopSidebar(
                currentRoute: location,
                fireAlertBadgeCount: fireState.unreadCount,
              ),
              Expanded(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.white.withOpacity(0.02),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
