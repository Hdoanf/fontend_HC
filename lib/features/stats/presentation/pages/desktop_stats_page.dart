import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/location/presentation/providers/location_providers.dart';
import '../../../../core/constants/app_colors.dart';

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

class StatEnergyPage extends ConsumerStatefulWidget {
  const StatEnergyPage({super.key});

  @override
  ConsumerState<StatEnergyPage> createState() => _StatEnergyPageState();
}

class _StatEnergyPageState extends ConsumerState<StatEnergyPage> {
  EnergyFilter filter = EnergyFilter.week;
  List<EnergyDevice> devices = [];
  bool _isLoadingDevices = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRealDevices());
  }

  Future<void> _loadRealDevices() async {
    final selectedHome = ref.read(selectedHomeProvider);
    if (selectedHome == null) {
      if (mounted) setState(() => _isLoadingDevices = false);
      return;
    }

    final roomApi = ref.read(roomApiProvider);
    final token = ref.read(authControllerProvider).value?.token ?? '';
    if (mounted) setState(() => _isLoadingDevices = true);
    
    try {
      final rooms = await roomApi.fetchRooms(homeId: selectedHome.homeId, token: token);
      List<EnergyDevice> tempDevices = [];
      
      // Mock energy data for real devices
      final mockEnergies = [12.5, 35.2, 22.8, 8.1, 15.4, 10.2, 5.5];
      int energyIdx = 0;

      for (final room in rooms) {
        try {
          final roomDevices = await roomApi.fetchDevicesByRoom(room.roomId, token: token);
          for (var d in roomDevices) {
            tempDevices.add(EnergyDevice(
              name: d.name, 
              energy: mockEnergies[energyIdx % mockEnergies.length],
            ));
            energyIdx++;
          }
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          devices = tempDevices;
          _isLoadingDevices = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingDevices = false);
    }
  }

  List<EnergyPoint> get chartData {
    switch (filter) {
      case EnergyFilter.day:
        return [
          EnergyPoint('0h', 1.2), EnergyPoint('6h', 2.5), EnergyPoint('12h', 3.8), EnergyPoint('18h', 2.9), EnergyPoint('24h', 1.6),
        ];
      case EnergyFilter.week:
        return [
          EnergyPoint('W1', 6), EnergyPoint('W2', 12), EnergyPoint('W3', 18), EnergyPoint('W4', 22),
        ];
      case EnergyFilter.month:
        return List.generate(12, (i) => EnergyPoint('M${i + 1}', (i + 1) * 4.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedHomeProvider, (_, __) => _loadRealDevices());
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(filter: filter, onChanged: (f) => setState(() => filter = f)),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _GlassContainer(child: _EnergyChart(data: chartData))),
                  const SizedBox(width: 32),
                  Expanded(flex: 2, child: _GlassContainer(
                    child: _isLoadingDevices 
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : _DeviceEnergyList(devices: devices)
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  const _GlassContainer({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  final EnergyFilter filter;
  final ValueChanged<EnergyFilter> onChanged;
  const _Header({required this.filter, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Text(l10n.t('Energy Statistics'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.desktopTextPrimary)),
        const Spacer(),
        _FilterToggle(filter: filter, onChanged: onChanged),
      ],
    );
  }
}

class _FilterToggle extends StatelessWidget {
  final EnergyFilter filter;
  final ValueChanged<EnergyFilter> onChanged;
  const _FilterToggle({required this.filter, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: EnergyFilter.values.map((f) {
          final active = filter == f;
          return GestureDetector(
            onTap: () => onChanged(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                f.name.toUpperCase(),
                style: TextStyle(color: active ? Colors.white : AppColors.desktopTextSecondary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EnergyChart extends StatelessWidget {
  final List<EnergyPoint> data;
  const _EnergyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maxValue = data.isEmpty ? 1.0 : data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('Energy Usage (kWh)'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.desktopTextPrimary)),
        const SizedBox(height: 32),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((e) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(e.value.toStringAsFixed(1), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: (e.value / maxValue).clamp(0.05, 1.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.primary, AppColors.primary.withOpacity(0.3)],
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(e.label, style: const TextStyle(fontSize: 12, color: AppColors.desktopTextSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DeviceEnergyList extends StatelessWidget {
  final List<EnergyDevice> devices;
  const _DeviceEnergyList({required this.devices});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('Devices'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.desktopTextPrimary)),
        const SizedBox(height: 24),
        Expanded(
          child: devices.isEmpty 
            ? const Center(child: Text('Chưa có thiết bị nào.', style: TextStyle(color: AppColors.desktopTextSecondary)))
            : ListView.separated(
                itemCount: devices.length,
                separatorBuilder: (_, __) => const Divider(height: 32, color: Colors.white10),
                itemBuilder: (_, i) {
                  final d = devices[i];
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Text(d.name, style: const TextStyle(color: AppColors.desktopTextPrimary, fontWeight: FontWeight.w500))),
                      Text('${d.energy.toStringAsFixed(1)} kWh', style: const TextStyle(color: AppColors.desktopTextSecondary, fontWeight: FontWeight.bold)),
                    ],
                  );
                },
              ),
        ),
      ],
    );
  }
}
