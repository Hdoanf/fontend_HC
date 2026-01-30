import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DesktopDevicesPage extends StatefulWidget {
  const DesktopDevicesPage({super.key});

  @override
  State<DesktopDevicesPage> createState() => _DesktopDevicesPageState();
}

class _DesktopDevicesPageState extends State<DesktopDevicesPage> {
  late VideoPlayerController _videoController;

  final List<Map<String, dynamic>> devices = [
    {
      'name': 'Air Condition',
      'isConnected': true,
      'icon': Icons.ac_unit,
      'isOn': true,
    },
    {
      'name': 'Lamp Light',
      'isConnected': false,
      'icon': Icons.lightbulb,
      'isOn': false,
    },
    {
      'name': 'Ceiling Fan',
      'isConnected': false,
      'icon': Icons.toys,
      'isOn': false,
    },
    {
      'name': 'Homepod Mini',
      'isConnected': true,
      'icon': Icons.speaker,
      'isOn': false,
    },
    {'name': 'Smart TV', 'isConnected': true, 'icon': Icons.tv, 'isOn': true},
    {'name': 'Router', 'isConnected': true, 'icon': Icons.router, 'isOn': true},
  ];

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
          )
          ..initialize().then((_) => setState(() {}))
          ..setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _toggleDevice(int index) {
    setState(() {
      if (devices[index]['isConnected']) {
        devices[index]['isOn'] = !devices[index]['isOn'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🎥 VIDEO CAMERA
          _buildCameraVideo(),

          const SizedBox(height: 32),

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Devices',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Device'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// GRID DEVICES
          Expanded(
            child: GridView.builder(
              itemCount: devices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                return _buildDesktopDeviceCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ================= VIDEO WIDGET =================
  Widget _buildCameraVideo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 240,
        width: double.infinity,
        color: Colors.black,
        child: _videoController.value.isInitialized
            ? Stack(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                  Center(
                    child: IconButton(
                      iconSize: 64,
                      icon: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _videoController.value.isPlaying
                              ? _videoController.pause()
                              : _videoController.play();
                        });
                      },
                    ),
                  ),
                  const Positioned(
                    left: 16,
                    bottom: 16,
                    child: Text(
                      'Master Bedroom Camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      ),
    );
  }

  /// ================= DEVICE CARD =================
  Widget _buildDesktopDeviceCard(int index) {
    final device = devices[index];
    final bool isConnected = device['isConnected'];
    final bool isOn = device['isOn'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isConnected && isOn
            ? const Color(0xFF2563EB).withOpacity(0.08)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isConnected && isOn
              ? const Color(0xFF2563EB).withOpacity(0.3)
              : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                device['icon'],
                size: 28,
                color: isConnected && isOn
                    ? const Color(0xFF2563EB)
                    : Colors.grey,
              ),
              Switch(
                value: isOn && isConnected,
                onChanged: isConnected ? (_) => _toggleDevice(index) : null,
                activeColor: const Color(0xFF2563EB),
              ),
            ],
          ),
          const Spacer(),
          Text(
            device['name'],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              fontSize: 12,
              color: isConnected ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
