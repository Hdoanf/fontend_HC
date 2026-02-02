import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MobileDevicesPage extends StatefulWidget {
  const MobileDevicesPage({super.key});

  @override
  State<MobileDevicesPage> createState() => _MobileDevicesPageState();
}

class _MobileDevicesPageState extends State<MobileDevicesPage> {
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
      'icon': Icons.settings_remote,
      'isOn': false,
    },
    {
      'name': 'Homepod Mini',
      'isConnected': true,
      'icon': Icons.speaker,
      'isOn': false,
    },
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: GestureDetector(
        //   onTap: () => Navigator.pop(context),
        //   child: const Icon(Icons.arrow_back, color: Colors.black),
        // ),
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
            /// 🎥 VIDEO ROOM
            _buildRoomVideo(),

            const SizedBox(height: 24),

            /// DEVICES HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Devices',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// GRID DEVICES
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
                  return _buildDeviceCard(index);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ================= VIDEO =================
  Widget _buildRoomVideo() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        height: 200,
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
                      iconSize: 56,
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
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      ),
    );
  }

  /// ================= DEVICE CARD =================
  Widget _buildDeviceCard(int index) {
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  device['icon'],
                  size: 24,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              device['name'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                fontSize: 12,
                color: isConnected ? Colors.green : Colors.grey,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
