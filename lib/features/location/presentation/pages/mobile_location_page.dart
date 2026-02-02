import 'package:flutter/material.dart';
import 'package:thuctap/features/location/data/models/device_location_model.dart';
import '../widgets/mobile/mobile_location_map.dart';

class MobileLocationPage extends StatefulWidget {
  const MobileLocationPage({super.key});

  @override
  State<MobileLocationPage> createState() => _MobileLocationPageState();
}

class _MobileLocationPageState extends State<MobileLocationPage> {
  late List<DeviceLocationModel> devices;
  String selectedRoom = 'Master Bedroom';

  final Map<String, List<DeviceLocationModel>> roomDevices = {
    'Master Bedroom': [
      DeviceLocationModel(
        id: '1',
        name: 'Air Condition',
        roomId: 'bedroom',
        x: 20,
        y: 30,
        status: 'Connected',
        isOn: true,
        icon: 'ac',
      ),
      DeviceLocationModel(
        id: '2',
        name: 'Lamp Light',
        roomId: 'bedroom',
        x: 70,
        y: 25,
        status: 'Connected',
        isOn: false,
        icon: 'lamp',
      ),
      DeviceLocationModel(
        id: '3',
        name: 'Ceiling Fan',
        roomId: 'bedroom',
        x: 50,
        y: 50,
        status: 'Connected',
        isOn: true,
        icon: 'fan',
      ),
    ],
    'Kitchen': [
      DeviceLocationModel(
        id: '4',
        name: 'Kitchen Light',
        roomId: 'kitchen',
        x: 30,
        y: 40,
        status: 'Connected',
        isOn: true,
        icon: 'light',
      ),
      DeviceLocationModel(
        id: '5',
        name: 'Oven',
        roomId: 'kitchen',
        x: 70,
        y: 60,
        status: 'Connected',
        isOn: false,
        icon: 'oven',
      ),
    ],
    'Living Room': [
      DeviceLocationModel(
        id: '6',
        name: 'TV',
        roomId: 'living',
        x: 50,
        y: 35,
        status: 'Connected',
        isOn: true,
        icon: 'tv',
      ),
      DeviceLocationModel(
        id: '7',
        name: 'Speaker',
        roomId: 'living',
        x: 25,
        y: 70,
        status: 'Disconnected',
        isOn: false,
        icon: 'speaker',
      ),
    ],
  };

  final Map<String, String> roomImages = {
    'Master Bedroom':
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
    'Kitchen':
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=500',
    'Living Room':
        'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=500',
  };

  @override
  void initState() {
    super.initState();
    devices = roomDevices[selectedRoom] ?? [];
  }

  void _changeRoom(String roomName) {
    setState(() {
      selectedRoom = roomName;
      devices = roomDevices[roomName] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Home Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Selector Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: roomDevices.keys.map((roomName) {
                  final isSelected = selectedRoom == roomName;
                  return GestureDetector(
                    onTap: () => _changeRoom(roomName),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        roomName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Map Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: MobileLocationMap(
                devices: devices,
                roomImage:
                    roomImages[selectedRoom] ??
                    'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
              ),
            ),
            // Devices List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Devices in this room',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(devices.length, (index) {
                    final device = devices[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: device.isOn
                                  ? const Color(0xFF2563EB).withOpacity(0.1)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.devices,
                              color: device.isOn
                                  ? const Color(0xFF2563EB)
                                  : Colors.grey[500],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  device.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: device.status == 'Connected'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: device.status == 'Connected'
                                ? () {
                                    setState(() {
                                      devices[index] = DeviceLocationModel(
                                        id: device.id,
                                        name: device.name,
                                        roomId: device.roomId,
                                        x: device.x,
                                        y: device.y,
                                        status: device.status,
                                        isOn: !device.isOn,
                                        icon: device.icon,
                                      );
                                    });
                                  }
                                : null,
                            child: Container(
                              width: 50,
                              height: 28,
                              decoration: BoxDecoration(
                                color: device.isOn
                                    ? const Color(0xFF2563EB).withOpacity(0.2)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  device.isOn ? 'On' : 'Off',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: device.isOn
                                        ? const Color(0xFF2563EB)
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
