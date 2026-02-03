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
      backgroundColor: AppColors.surfaceLight,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              filter: filter,
              onChanged: (f) => setState(() => filter = f),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _EnergyChart(data: chartData),
                  ),
                  const SizedBox(width: 24),
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
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
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
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
    final maxValue =
    data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    const double chartHeight = 320;
    const double labelHeight = 36;
    final double barMaxHeight = chartHeight - labelHeight;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Energy Usage (kWh)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

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
                    final value =
                    (maxValue * (4 - i) / 4).round();
                    return Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),

                /// ===== BARS =====
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: data.map((e) {
                      final targetHeight =
                          (e.value / maxValue) * barMaxHeight;

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: targetHeight,
                              ),
                              duration:
                              const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return Container(
                                  height: value,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 20,
                              child: Text(
                                e.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                  AppColors.textSecondary,
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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Devices',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: devices.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (_, i) {
                final d = devices[i];
                return Row(
                  children: [
                    const Icon(
                      Icons.electrical_services,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(d.name)),
                    Text(
                      '${d.energy.toStringAsFixed(1)} kWh',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
