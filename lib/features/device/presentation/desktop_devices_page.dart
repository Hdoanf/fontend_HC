import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:thuctap/core/widgets/webcam_mjpeg_view.dart';
import 'package:thuctap/core/constants/app_colors.dart';

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
  static const String _localWebcamUrl = 'http://192.168.1.33:8080/video';

  VideoPlayerController? _videoController;
  bool _isMjpegStream = false;

  bool _isFullscreen = false;
  bool _showControls = true;
  Timer? _hideTimer;

  int _currentCameraIndex = 0;

  final List<CameraItem> cameras = [
    CameraItem(name: 'Camera 1', url: _localWebcamUrl),
  ];

  @override
  void initState() {
    super.initState();
    _initCamera(0);
  }

  Future<void> _initCamera(int index) async {
    final url = cameras[index].url;
    _isMjpegStream = _looksLikeMjpeg(url);
    if (_isMjpegStream) {
      _videoController?.dispose();
      _videoController = null;
      if (mounted) setState(() {});
      return;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    controller
      ..setLooping(true)
      ..play();

    _videoController = controller;
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera(int index) async {
    if (!mounted || index < 0 || index >= cameras.length) return;

    final oldController = _videoController;
    final url = cameras[index].url;
    final isMjpeg = _looksLikeMjpeg(url);

    if (isMjpeg) {
      if (!mounted) return;
      setState(() {
        _currentCameraIndex = index;
        _isMjpegStream = true;
        _videoController = null;
      });
      oldController?.dispose();
      return;
    }

    final newController = VideoPlayerController.networkUrl(Uri.parse(url));
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
      _isMjpegStream = false;
      _videoController = newController;
      _videoKey = UniqueKey(); // 🔥 BẮT BUỘC
    });

    // Dispose chậm hơn 1 chút để tránh crash texture
    Future.delayed(const Duration(milliseconds: 300), () {
      oldController?.dispose();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  void _showTemporarily() {
    setState(() => _showControls = true);

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted && (_videoController?.value.isPlaying ?? false)) {
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
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
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
                  _videoController!.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
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
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('Add New Camera', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Camera Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
              child: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'Video URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final name = nameController.text.trim();
              final url = urlController.text.trim();

              if (name.isEmpty || url.isEmpty) return;

              final newIndex = cameras.length;

              setState(() {
                cameras.add(CameraItem(name: name, url: url));
              });

              await _switchCamera(newIndex);

              if (context.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _isFullscreen
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                cameras[_currentCameraIndex].name,
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
                    onPressed: _showAddCameraDialog,
                  ),
                ),
              ],
            ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            /// VIDEO – 1 INSTANCE DUY NHẤT
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              height: _isFullscreen ? MediaQuery.of(context).size.height : 500,
              decoration: BoxDecoration(
                boxShadow: _isFullscreen ? [] : [
                  BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15))
                ],
              ),
              child: _buildVideo(),
            ),

            /// CAMERA LIST (ẨN KHI FULLSCREEN)
            if (!_isFullscreen) ...[
              const SizedBox(height: 24),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive ? [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                ] : [
                  BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Center(
                child: Text(
                  cameras[index].name,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
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
      borderRadius: BorderRadius.circular(_isFullscreen ? 0 : 28),
      clipBehavior: Clip.antiAlias,
      child: _isMjpegStream
          ? Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    child: WebcamMjpegView(
                      streamUrl: cameras[_currentCameraIndex].url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      _isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 32,
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
          : (_videoController?.value.isInitialized ?? false)
          ? Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(
                        _videoController!,
                        key: _videoKey, // 🔥 FIX QUYẾT ĐỊNH
                      ),
                    ),
                  ),
                ),
                _playPauseButton(),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      _isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 32,
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
          : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }

  bool _looksLikeMjpeg(String url) {
    final lower = url.toLowerCase();
    return lower.contains('/video') ||
        lower.contains('/mjpeg') ||
        lower.contains('.mjpg');
  }
}
