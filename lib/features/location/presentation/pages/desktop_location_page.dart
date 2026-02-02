import 'package:flutter/material.dart';
import 'package:thuctap/features/location/data/models/device_location_model.dart';
import '../widgets/desktop/desktop_location_map.dart';

class DesktopLocationPage extends StatefulWidget {
  const DesktopLocationPage({super.key});

  @override
  State<DesktopLocationPage> createState() => _DesktopLocationPageState();
}

class _DesktopLocationPageState extends State<DesktopLocationPage> {
  late List<DeviceLocationModel> devices;
  String selectedRoom = 'Master Bedroom';
  String? selectedDeviceId;

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
      DeviceLocationModel(
        id: '6',
        name: 'Refrigerator',
        roomId: 'kitchen',
        x: 45,
        y: 75,
        status: 'Connected',
        isOn: true,
        icon: 'fridge',
      ),
    ],
    'Living Room': [
      DeviceLocationModel(
        id: '7',
        name: 'TV',
        roomId: 'living',
        x: 50,
        y: 35,
        status: 'Connected',
        isOn: true,
        icon: 'tv',
      ),
      DeviceLocationModel(
        id: '8',
        name: 'Speaker',
        roomId: 'living',
        x: 25,
        y: 70,
        status: 'Disconnected',
        isOn: false,
        icon: 'speaker',
      ),
      DeviceLocationModel(
        id: '9',
        name: 'Lights',
        roomId: 'living',
        x: 75,
        y: 45,
        status: 'Connected',
        isOn: true,
        icon: 'light',
      ),
    ],
  };

  final Map<String, String> roomImages = {
    'Master Bedroom':
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
    'Kitchen':
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
    'Living Room':
        'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=800',
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
      selectedDeviceId = null;
    });
  }

  void _toggleDevice(DeviceLocationModel device) {
    setState(() {
      final index = devices.indexWhere((d) => d.id == device.id);
      if (index != -1) {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Home Location Map',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Map Area
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: roomDevices.keys.map((roomName) {
                        final isSelected = selectedRoom == roomName;
                        return GestureDetector(
                          onTap: () => _changeRoom(roomName),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(24),
                              border: isSelected
                                  ? null
                                  : Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              roomName,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Map
                  Expanded(
                    child: DesktopLocationMap(
                      devices: devices,
                      roomImage:
                          roomImages[selectedRoom] ??
                          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Sidebar - Device List
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Devices',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$selectedRoom (${devices.length} devices)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Device List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        final isSelected = selectedDeviceId == device.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDeviceId = isSelected ? null : device.id;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2563EB).withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2563EB).withOpacity(0.3)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: device.isOn
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        device.name,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  device.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: device.status == 'Connected'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF2563EB,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF2563EB,
                                        ).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _toggleDevice(device),
                                        borderRadius: BorderRadius.circular(6),
                                        child: Center(
                                          child: Text(
                                            device.isOn
                                                ? 'Turn Off'
                                                : 'Turn On',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Footer Stats
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${devices.where((d) => d.isOn).length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            Text(
                              'On',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${devices.where((d) => !d.isOn).length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Off',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
