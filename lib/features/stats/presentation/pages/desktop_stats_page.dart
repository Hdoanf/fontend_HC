import 'package:flutter/material.dart';

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

class DesktopStatsPage extends StatelessWidget {
  const DesktopStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Device> devices = [
      Device(
        name: 'Smart Light',
        type: 'Light',
        energyConsumption: 15.5,
        usageHours: 60.2,
      ),
      Device(
        name: 'Living Room TV',
        type: 'TV',
        energyConsumption: 45.2,
        usageHours: 30.5,
      ),
      Device(
        name: 'Kitchen Fridge',
        type: 'Appliance',
        energyConsumption: 120.0,
        usageHours: 720.0,
      ),
      Device(
        name: 'Bedroom AC',
        type: 'AC',
        energyConsumption: 250.8,
        usageHours: 120.7,
      ),
      Device(
        name: 'Laptop Charger',
        type: 'Electronics',
        energyConsumption: 25.0,
        usageHours: 80.0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Device Statistics')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                device.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(device.type),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${device.energyConsumption} kWh',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${device.usageHours} hours'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
