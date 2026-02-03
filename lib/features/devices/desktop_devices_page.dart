import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CameraItem {
  final String name;
  final String url;

  CameraItem({required this.name, required this.url});
}

class DesktopDevicesPage extends StatefulWidget {
  const DesktopDevicesPage({super.key});

  @override
  State<DesktopDevicesPage> createState() => _DesktopDevicesPageState();
}
Key _videoKey = UniqueKey();


class _DesktopDevicesPageState extends State<DesktopDevicesPage> {
  late VideoPlayerController _videoController;

  bool _isFullscreen = false;
  bool _showControls = true;
  Timer? _hideTimer;

  int _currentCameraIndex = 0;

  final List<CameraItem> cameras = [
    CameraItem(
      name: 'Camera 1',
      url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initCamera(0);
  }

  Future<void> _initCamera(int index) async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(cameras[index].url),
    );

    await _videoController.initialize();
    _videoController
      ..setLooping(true)
      ..play();

    if (mounted) setState(() {});
  }
  Future<void> _switchCamera(int index) async {
    if (!mounted || index < 0 || index >= cameras.length) return;

    final oldController = _videoController;

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(cameras[index].url),
    );

    await newController.initialize();
    newController
      ..setLooping(true)
      ..play();

    if (!mounted) {
      newController.dispose();
      return;
    }

    setState(() {
      _currentCameraIndex = index;
      _videoController = newController;
      _videoKey = UniqueKey(); // 🔥 BẮT BUỘC
    });

    // Dispose chậm hơn 1 chút để tránh crash texture
    Future.delayed(const Duration(milliseconds: 300), () {
      oldController.dispose();
    });
  }



  @override
  void dispose() {
    _hideTimer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  void _showTemporarily() {
    setState(() => _showControls = true);

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted && _videoController.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  Widget _playPauseButton() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _showTemporarily,
        child: Center(
          child: AnimatedOpacity(
            opacity: _showControls ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _videoController.value.isPlaying
                      ? _videoController.pause()
                      : _videoController.play();
                });
                _showTemporarily();
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black45,
                ),
                child: Icon(
                  _videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCameraDialog() {
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Camera'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Camera Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Video URL',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final url = urlController.text.trim();

              if (name.isEmpty || url.isEmpty) return;

              final newIndex = cameras.length;

              setState(() {
                cameras.add(
                  CameraItem(
                    name: name,
                    url: url,
                  ),
                );
              });

              await _switchCamera(newIndex);

              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _isFullscreen
          ? null
          : AppBar(
        title: Text(cameras[_currentCameraIndex].name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCameraDialog,
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            /// VIDEO – 1 INSTANCE DUY NHẤT
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              height: _isFullscreen
                  ? MediaQuery.of(context).size.height
                  : 260,
              child: _buildVideo(),
            ),

            /// CAMERA LIST (ẨN KHI FULLSCREEN)
            if (!_isFullscreen) ...[
              const SizedBox(height: 16),
              _buildCameraList(),
            ],
          ],
        ),
      ),

    );
  }

  Widget _buildCameraList() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cameras.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isActive = index == _currentCameraIndex;

          return GestureDetector(
            onTap: () => _switchCamera(index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.blue.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? Colors.blue
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                cameras[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.blue : Colors.black,
                ),
              ),

            ),
          );
        },
      ),
    );
  }

  Widget _buildVideo() {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(_isFullscreen ? 0 : 16),
      clipBehavior: Clip.antiAlias,
      child: _videoController.value.isInitialized
          ? Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(
                  _videoController,
                  key: _videoKey, // 🔥 FIX QUYẾT ĐỊNH
                ),

              ),
            ),
          ),
          _playPauseButton(),
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: Icon(
                _isFullscreen
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isFullscreen = !_isFullscreen;
                });
              },
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
