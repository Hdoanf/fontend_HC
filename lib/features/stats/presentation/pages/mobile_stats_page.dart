import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

// Data class for a device
class Device {
  final String name;
  final String type;
  final double energyConsumption;
  final double usageHours;

  Device({
    required this.name,
    required this.type,
    required this.energyConsumption,
    required this.usageHours,
  });
}

class MobileStatsPage extends StatelessWidget {
  const MobileStatsPage({super.key});

  // Generates mock data for a given period
  List<Device> _getDeviceDataForPeriod(String period) {
    switch (period) {
      case 'Day':
        return [
          Device(name: 'Smart Light', type: 'Light', energyConsumption: 1.2, usageHours: 5.0),
          Device(name: 'Living Room TV', type: 'TV', energyConsumption: 3.5, usageHours: 2.5),
          Device(name: 'Kitchen Fridge', type: 'Appliance', energyConsumption: 10.0, usageHours: 24.0),
          Device(name: 'Bedroom AC', type: 'AC', energyConsumption: 12.0, usageHours: 8.0),
          Device(name: 'Laptop Charger', type: 'Electronics', energyConsumption: 2.0, usageHours: 6.0),
        ];
      case 'Week':
        return [
          Device(name: 'Smart Light', type: 'Light', energyConsumption: 8.4, usageHours: 35.0),
          Device(name: 'Living Room TV', type: 'TV', energyConsumption: 24.5, usageHours: 17.5),
          Device(name: 'Kitchen Fridge', type: 'Appliance', energyConsumption: 70.0, usageHours: 168.0),
          Device(name: 'Bedroom AC', type: 'AC', energyConsumption: 84.0, usageHours: 56.0),
          Device(name: 'Laptop Charger', type: 'Electronics', energyConsumption: 14.0, usageHours: 42.0),
        ];
      case 'Month':
        return [
          Device(name: 'Smart Light', type: 'Light', energyConsumption: 36.0, usageHours: 150.0),
          Device(name: 'Living Room TV', type: 'TV', energyConsumption: 105.0, usageHours: 75.0),
          Device(name: 'Kitchen Fridge', type: 'Appliance', energyConsumption: 300.0, usageHours: 720.0),
          Device(name: 'Bedroom AC', type: 'AC', energyConsumption: 360.0, usageHours: 240.0),
          Device(name: 'Laptop Charger', type: 'Electronics', energyConsumption: 60.0, usageHours: 180.0),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Energy Statistics',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: AppSizes.paddingMedium, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Day'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildStatsForPeriod('Day'),
            _buildStatsForPeriod('Week'),
            _buildStatsForPeriod('Month'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsForPeriod(String period) {
    final devices = _getDeviceDataForPeriod(period);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummary(devices),
          const SizedBox(height: 24),
          _buildSectionTitle('Usage by Device'),
          const SizedBox(height: 12),
          _buildDeviceList(devices),
          const SizedBox(height: 32),
          _buildSectionTitle('Usage by Type'),
          const SizedBox(height: 12),
          _buildPieChart(devices),
          const SizedBox(height: 32),
          _buildSectionTitle('Energy Overview'),
          const SizedBox(height: 12),
          _buildBarChart(devices),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildDeviceList(List<Device> devices) {
    return Column(
      children: devices.map((device) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getColorForType(device.type).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(device.type),
                  color: _getColorForType(device.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${device.usageHours.toStringAsFixed(1)} hours used',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${device.energyConsumption.toStringAsFixed(1)} kWh',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Light': return Icons.lightbulb_rounded;
      case 'TV': return Icons.tv_rounded;
      case 'Appliance': return Icons.kitchen_rounded;
      case 'AC': return Icons.ac_unit_rounded;
      case 'Electronics': return Icons.power_rounded;
      default: return Icons.device_hub_rounded;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSummary(List<Device> devices) {
    double totalConsumption = devices.map((d) => d.energyConsumption).reduce((a, b) => a + b);
    Device highestConsumer = devices.reduce((a, b) => a.energyConsumption > b.energyConsumption ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF5D7EFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Consumption',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalConsumption.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 8),
                child: Text(
                  'kWh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      children: [
                        const TextSpan(text: 'Highest: '),
                        TextSpan(text: highestConsumer.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(List<Device> devices) {
    final Map<String, double> consumptionByType = {};
    for (var device in devices) {
      consumptionByType[device.type] = (consumptionByType[device.type] ?? 0) + device.energyConsumption;
    }

    final total = devices.map((d) => d.energyConsumption).reduce((a, b) => a + b);

    final List<PieChartSectionData> sections = consumptionByType.entries.map((entry) {
      return PieChartSectionData(
        color: _getColorForType(entry.key),
        value: entry.value,
        title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      );
    }).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: consumptionByType.keys.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getColorForType(type),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
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
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Light': return const Color(0xFFFFB236);
      case 'TV': return const Color(0xFF9D63F4);
      case 'Appliance': return const Color(0xFF22C55E);
      case 'AC': return const Color(0xFFFF5252);
      case 'Electronics': return const Color(0xFF2E5BFF);
      default: return AppColors.disabled;
    }
  }

  Widget _buildBarChart(List<Device> devices) {
    double maxEnergy = devices.map((d) => d.energyConsumption).reduce(max);
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxEnergy * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Text(
                      devices[value.toInt()].name.split(' ').last.substring(0, 2),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: devices.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.energyConsumption,
                  color: AppColors.primary,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
