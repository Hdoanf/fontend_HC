import 'package:flutter/material.dart';
import 'desktop_header.dart';
import 'desktop_rooms_section.dart';
import 'desktop_frequently_used.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DesktopHeader(),
            const SizedBox(height: 32),
            
            /// DASHBOARD LAYOUT
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT COLUMN: ROOMS (PRIMARY)
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _GlassCard(
                        title: 'Quick Control',
                        child: DesktopRoomsSection(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 32),
                
                /// RIGHT COLUMN: FREQUENTLY USED & STATS SUMMARY
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      _GlassCard(
                        title: 'Frequently Used',
                        child: FrequentlyUsedSection(),
                      ),
                      SizedBox(height: 32),
                      _GlassCard(
                        title: 'System Status',
                        child: _SystemStatusSummary(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final String? title;

  const _GlassCard({required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }
}

class _SystemStatusSummary extends StatelessWidget {
  const _SystemStatusSummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatusItem(icon: Icons.thermostat_rounded, label: 'Temp', value: '24°C', color: Colors.orange),
        _StatusItem(icon: Icons.water_drop_rounded, label: 'Humidity', value: '45%', color: Colors.blue),
        _StatusItem(icon: Icons.bolt_rounded, label: 'Power', value: '1.2 kW', color: Colors.yellow),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusItem({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}
