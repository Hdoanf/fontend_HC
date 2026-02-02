import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../../../core/constants/app_colors.dart';

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
    // This is a mock implementation. In a real app, you would fetch data from a database or API.
    switch (period) {
      case 'Day':
        return [
          Device(
            name: 'Smart Light',
            type: 'Light',
            energyConsumption: 1.2,
            usageHours: 5.0,
          ),
          Device(
            name: 'Living Room TV',
            type: 'TV',
            energyConsumption: 3.5,
            usageHours: 2.5,
          ),
          Device(
            name: 'Kitchen Fridge',
            type: 'Appliance',
            energyConsumption: 10.0,
            usageHours: 24.0,
          ),
          Device(
            name: 'Bedroom AC',
            type: 'AC',
            energyConsumption: 12.0,
            usageHours: 8.0,
          ),
          Device(
            name: 'Laptop Charger',
            type: 'Electronics',
            energyConsumption: 2.0,
            usageHours: 6.0,
          ),
        ];
      case 'Week':
        return [
          Device(
            name: 'Smart Light',
            type: 'Light',
            energyConsumption: 800.4,
            usageHours: 35.0,
          ),
          Device(
            name: 'Living Room TV',
            type: 'TV',
            energyConsumption: 24.5,
            usageHours: 17.5,
          ),
          Device(
            name: 'Kitchen Fridge',
            type: 'Appliance',
            energyConsumption: 70.0,
            usageHours: 168.0,
          ),
          Device(
            name: 'Bedroom AC',
            type: 'AC',
            energyConsumption: 84.0,
            usageHours: 56.0,
          ),
          Device(
            name: 'Laptop Charger',
            type: 'Electronics',
            energyConsumption: 14.0,
            usageHours: 42.0,
          ),
        ];
      case 'Month':
        return [
          Device(
            name: 'Smart Light',
            type: 'Light',
            energyConsumption: 36.0,
            usageHours: 150.0,
          ),
          Device(
            name: 'Living Room TV',
            type: 'TV',
            energyConsumption: 105.0,
            usageHours: 75.0,
          ),
          Device(
            name: 'Kitchen Fridge',
            type: 'Appliance',
            energyConsumption: 300.0,
            usageHours: 720.0,
          ),
          Device(
            name: 'Bedroom AC',
            type: 'AC',
            energyConsumption: 360.0,
            usageHours: 240.0,
          ),
          Device(
            name: 'Laptop Charger',
            type: 'Electronics',
            energyConsumption: 60.0,
            usageHours: 180.0,
          ),
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
          title: const Text(
            'Master Bedroom',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: Colors.black,
            unselectedLabelColor: AppColors.primaryLight,
            tabs: [
              Tab(text: 'Day'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
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

  // Builds the content for each tab
  Widget _buildStatsForPeriod(String period) {
    final devices = _getDeviceDataForPeriod(period);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummary(devices),
          const SizedBox(height: 30),
          _buildSectionTitle('Consumption by Device'),
          _buildDeviceList(devices),
          const SizedBox(height: 30),
          _buildSectionTitle('Consumption by Type'),
          _buildPieChart(devices),
          const SizedBox(height: 30),
          _buildSectionTitle('Consumption Overview'),
          _buildBarChart(devices),
        ],
      ),
    );
  }

  // Builds a list of devices with their consumption
  Widget _buildDeviceList(List<Device> devices) {
    return Column(
      children: devices.map((device) {
        return Card(
          color: AppColors.surfaceLight,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              _getIconForType(device.type),
              color: _getColorForType(device.type),
            ),
            title: Text(
              device.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Text(
              '${device.energyConsumption.toStringAsFixed(2)} kWh',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Gets an icon for a given device type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'Light':
        return Icons.lightbulb_outline;
      case 'TV':
        return Icons.tv_outlined;
      case 'Appliance':
        return Icons.kitchen_outlined;
      case 'AC':
        return Icons.ac_unit_outlined;
      case 'Electronics':
        return Icons.power_outlined;
      default:
        return Icons.device_unknown_outlined;
    }
  }

  // Builds a title widget for a section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Builds the summary section at the top of the page
  Widget _buildSummary(List<Device> devices) {
    double totalConsumption = devices
        .map((d) => d.energyConsumption)
        .reduce((a, b) => a + b);
    Device highestConsumer = devices.reduce(
      (a, b) => a.energyConsumption > b.energyConsumption ? a : b,
    );

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Total Energy Consumption',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.desktopTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${totalConsumption.toStringAsFixed(2)} kWh',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.desktopTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Highest consumer: ${highestConsumer.name} (${highestConsumer.energyConsumption.toStringAsFixed(2)} kWh)',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.desktopTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Builds a pie chart showing energy consumption by device type
  Widget _buildPieChart(List<Device> devices) {
    final Map<String, double> consumptionByType = {};
    for (var device in devices) {
      consumptionByType[device.type] =
          (consumptionByType[device.type] ?? 0) + device.energyConsumption;
    }

    final List<PieChartSectionData> sections = consumptionByType.entries.map((
      entry,
    ) {
      final isTouched = false; // Placeholder for touch interaction
      final double fontSize = isTouched ? 25.0 : 16.0;
      final double radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: _getColorForType(entry.key),
        value: entry.value,
        title:
            '${(entry.value / devices.map((d) => d.energyConsumption).reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.desktopTextPrimary,
        ),
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: AppColors.surfaceLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
      ),
    );
  }

  // Returns a color for a given device type
  Color _getColorForType(String type) {
    switch (type) {
      case 'Light':
        return AppColors.chartOrange;
      case 'TV':
        return AppColors.chartPurple;
      case 'Appliance':
        return AppColors.chartGreen;
      case 'AC':
        return AppColors.chartRed;
      case 'Electronics':
        return AppColors.chartBlue;
      default:
        return AppColors.disabled;
    }
  }

  // Builds a bar chart showing energy consumption by device
  Widget _buildBarChart(List<Device> devices) {
    double maxEnergy = devices.map((d) => d.energyConsumption).reduce(max);
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        color: AppColors.surfaceLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxEnergy * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: Text(
                          devices[value.toInt()].name.substring(0, 3),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: devices.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.energyConsumption,
                      gradient: const LinearGradient(
                        colors: [AppColors.chartBlue, AppColors.primaryLight],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 22,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
