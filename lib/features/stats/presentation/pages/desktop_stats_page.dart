import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// ===================== MODELS =====================

enum EnergyFilter { day, week, month }

class EnergyDevice {
  final String name;
  final double energy;
  EnergyDevice({required this.name, required this.energy});
}

class EnergyPoint {
  final String label;
  final double value;
  EnergyPoint(this.label, this.value);
}

/// ===================== PAGE =====================

class StatEnergyPage extends StatefulWidget {
  const StatEnergyPage({super.key});

  @override
  State<StatEnergyPage> createState() => _StatEnergyPageState();
}

class _StatEnergyPageState extends State<StatEnergyPage> {
  EnergyFilter filter = EnergyFilter.week;

  List<EnergyPoint> get chartData {
    switch (filter) {
      case EnergyFilter.day:
        return [
          EnergyPoint('0h', 1.2),
          EnergyPoint('6h', 2.5),
          EnergyPoint('12h', 3.8),
          EnergyPoint('18h', 2.9),
          EnergyPoint('24h', 1.6),
        ];
      case EnergyFilter.week:
        return [
          EnergyPoint('W1', 6),
          EnergyPoint('W2', 12),
          EnergyPoint('W3', 18),
          EnergyPoint('W4', 22),
        ];
      case EnergyFilter.month:
        return List.generate(
          12,
          (i) => EnergyPoint('M${i + 1}', (i + 1) * 4),
        );
    }
  }

  final List<EnergyDevice> devices = [
    EnergyDevice(name: 'Living Room Lamp', energy: 12.5),
    EnergyDevice(name: 'Air Conditioner', energy: 35.2),
    EnergyDevice(name: 'Kitchen Fridge', energy: 22.8),
    EnergyDevice(name: 'TV', energy: 8.1),
    EnergyDevice(name: 'Washing Machine', energy: 15.4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              filter: filter,
              onChanged: (f) => setState(() => filter = f),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _EnergyChart(data: chartData),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: _DeviceEnergyList(devices: devices),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================== HEADER =====================

class _Header extends StatelessWidget {
  final EnergyFilter filter;
  final ValueChanged<EnergyFilter> onChanged;

  const _Header({
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Energy Statistics',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FilterButton(
                label: 'Day',
                active: filter == EnergyFilter.day,
                onTap: () => onChanged(EnergyFilter.day),
              ),
              _FilterButton(
                label: 'Week',
                active: filter == EnergyFilter.week,
                onTap: () => onChanged(EnergyFilter.week),
              ),
              _FilterButton(
                label: 'Month',
                active: filter == EnergyFilter.month,
                onTap: () => onChanged(EnergyFilter.month),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ===================== FILTER BUTTON =====================

class _FilterButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active ? [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
          ] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// ===================== ENERGY CHART =====================
class _EnergyChart extends StatelessWidget {
  final List<EnergyPoint> data;
  const _EnergyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    const double chartHeight = 400;
    const double labelHeight = 36;
    final double barMaxHeight = chartHeight - labelHeight;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Energy Usage (kWh)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
          ),
          const SizedBox(height: 32),

          /// ===== CHART =====
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// ===== Y AXIS =====
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (i) {
                    final value = (maxValue * (4 - i) / 4).round();
                    return Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 16),

                /// ===== BARS =====
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: data.map((e) {
                      final targetHeight = (e.value / maxValue) * barMaxHeight;

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: targetHeight),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return Container(
                                  height: value,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.primary, Color(0xFF5D7EFF)],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 20,
                              child: Text(
                                e.label,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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

/// ===================== DEVICE LIST =====================

class _DeviceEnergyList extends StatelessWidget {
  final List<EnergyDevice> devices;
  const _DeviceEnergyList({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Devices Top Usage',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: devices.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.borderColor, height: 32),
              itemBuilder: (_, i) {
                final d = devices[i];
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.electrical_services_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        d.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                      )
                    ),
                    Text(
                      '${d.energy.toStringAsFixed(1)} kWh',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
