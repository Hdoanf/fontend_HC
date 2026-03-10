import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/fire_alert_state.dart';

OverlayEntry? _activeAlertOverlay;

void showFireAlertBanner({
  required BuildContext context,
  required FireEvent event,
  required VoidCallback onViewPressed,
}) {
  _activeAlertOverlay?.remove();

  final overlay = Overlay.maybeOf(context);
  if (overlay == null) {
    return;
  }

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) => _FireAlertOverlayCard(
      event: event,
      onViewPressed: () {
        entry.remove();
        if (identical(_activeAlertOverlay, entry)) {
          _activeAlertOverlay = null;
        }
        onViewPressed();
      },
      onDismissed: () {
        if (entry.mounted) {
          entry.remove();
        }
        if (identical(_activeAlertOverlay, entry)) {
          _activeAlertOverlay = null;
        }
      },
    ),
  );

  _activeAlertOverlay = entry;
  overlay.insert(entry);
}

class _FireAlertOverlayCard extends StatefulWidget {
  const _FireAlertOverlayCard({
    required this.event,
    required this.onViewPressed,
    required this.onDismissed,
  });

  final FireEvent event;
  final VoidCallback onViewPressed;
  final VoidCallback onDismissed;

  @override
  State<_FireAlertOverlayCard> createState() => _FireAlertOverlayCardState();
}

class _FireAlertOverlayCardState extends State<_FireAlertOverlayCard> {
  Timer? _autoDismissTimer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _visible = true;
      });
    });
    _autoDismissTimer = Timer(const Duration(seconds: 8), _dismiss);
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _severityColor(widget.event.severity);

    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              offset: _visible ? Offset.zero : const Offset(0, -0.18),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _visible ? 1 : 0,
                child: Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFFBFB),
                            severityColor.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: severityColor.withValues(alpha: 0.20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                            blurRadius: 28,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: severityColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.local_fire_department_rounded,
                                    color: severityColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: severityColor.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              _severityLabel(widget.event.severity),
                                              style: TextStyle(
                                                color: severityColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: _dismiss,
                                            visualDensity: VisualDensity.compact,
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Canh bao chay dang kich hoat',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.4,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${widget.event.zoneName} • ${widget.event.sensorName}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _MetricTile(
                                    label: 'Nhiet do',
                                    value:
                                        '${widget.event.temperatureC.toStringAsFixed(1)}°C',
                                    icon: Icons.thermostat_rounded,
                                    color: severityColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _MetricTile(
                                    label: 'Khoi',
                                    value:
                                        '${widget.event.smokePpm.toStringAsFixed(1)} ppm',
                                    icon: Icons.air_rounded,
                                    color: const Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _dismiss,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.textPrimary,
                                      side: BorderSide(
                                        color: AppColors.textPrimary.withValues(alpha: 0.1),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'Dong',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: widget.onViewPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: severityColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'Xem ngay',
                                      style: TextStyle(fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismiss() {
    if (!_visible) {
      widget.onDismissed();
      return;
    }

    _autoDismissTimer?.cancel();
    setState(() {
      _visible = false;
    });
    Future<void>.delayed(const Duration(milliseconds: 220), widget.onDismissed);
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _severityColor(FireSeverity severity) {
  switch (severity) {
    case FireSeverity.critical:
      return const Color(0xFFB91C1C);
    case FireSeverity.high:
      return const Color(0xFFDC2626);
    case FireSeverity.medium:
      return const Color(0xFFEA580C);
    case FireSeverity.low:
      return const Color(0xFFCA8A04);
  }
}

String _severityLabel(FireSeverity severity) {
  switch (severity) {
    case FireSeverity.critical:
      return 'CRITICAL';
    case FireSeverity.high:
      return 'HIGH';
    case FireSeverity.medium:
      return 'MEDIUM';
    case FireSeverity.low:
      return 'LOW';
  }
}
