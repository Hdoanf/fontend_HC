import 'package:flutter/material.dart';

class MobileDevicesPage extends StatefulWidget {
  const MobileDevicesPage({super.key});

  @override
  State<MobileDevicesPage> createState() => _MobileDevicesPageState();
}

class _MobileDevicesPageState extends State<MobileDevicesPage> {
  final List<Map<String, dynamic>> devices = [
    {
      'name': 'Air Condition',
      'status': 'Connected',
      'isConnected': true,
      'icon': Icons.ac_unit,
      'isOn': true,
    },
    {
      'name': 'Lamp Light',
      'status': 'Disconnected',
      'isConnected': false,
      'icon': Icons.lightbulb,
      'isOn': false,
    },
    {
      'name': 'Ceiling Fan',
      'status': 'Disconnected',
      'isConnected': false,
      'icon': Icons.settings_remote,
      'isOn': false,
    },
    {
      'name': 'Homepod Mini',
      'status': 'Connected',
      'isConnected': true,
      'icon': Icons.speaker,
      'isOn': false,
    },
  ];

  void _toggleDevice(int index) {
    setState(() {
      if (devices[index]['isConnected']) {
        devices[index]['isOn'] = !devices[index]['isOn'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Master Bedroom',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: Image.network(
                  'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 48),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Devices Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Devices',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add new device'),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Devices Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return _buildDeviceCard(context, index);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, int index) {
    final device = devices[index];
    final isConnected = device['isConnected'] as bool;
    final isOn = device['isOn'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: isConnected && isOn
            ? const Color(0xFF2563EB).withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected && isOn
              ? const Color(0xFF2563EB).withOpacity(0.3)
              : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon and Toggle
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isConnected && isOn
                        ? const Color(0xFF2563EB)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    device['icon'] as IconData,
                    color: isConnected && isOn
                        ? Colors.white
                        : Colors.grey[600],
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 24,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isOn && isConnected,
                      onChanged: isConnected
                          ? (value) => _toggleDevice(index)
                          : null,
                      activeColor: const Color(0xFF2563EB),
                      inactiveThumbColor: Colors.grey[400],
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Device Name and Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isConnected ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
