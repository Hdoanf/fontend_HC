import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import 'package:thuctap/features/home/mobile/device_card.dart';

class MobileDevicesPage extends StatelessWidget {
  const MobileDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = const [
      DeviceCard(
        deviceName: 'Living Room Light',
        status: AppStrings.connected,
        isConnected: true,
        icon: Icons.lightbulb,
        initialIsOn: true,
      ),
      DeviceCard(
        deviceName: 'Living Room Light',
        status: AppStrings.connected,
        isConnected: true,
        icon: Icons.lightbulb,
        initialIsOn: false,
      ),
      DeviceCard(
        deviceName: 'Living Room Light',
        status: AppStrings.connected,
        isConnected: true,
        icon: Icons.lightbulb,
        initialIsOn: false,
      ),
      DeviceCard(
        deviceName: 'Living Room Light',
        status: AppStrings.connected,
        isConnected: false,
        icon: Icons.lightbulb,
        initialIsOn: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Devices')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (context, index) => devices[index],
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}
