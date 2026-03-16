import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:thuctap/core/widgets/webcam_mjpeg_view.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
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
  static const String _localWebcamUrl = 'http://192.168.1.55:8080/video';
  VideoPlayerController? _videoController;
  bool _isMjpegStream = false;
  bool _isFullscreen = false;
  int _currentCameraIndex = 0;
  final List<CameraItem> cameras = [CameraItem(name: 'Main Entrance', url: _localWebcamUrl)];

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
    controller..setLooping(true)..play();
    _videoController = controller;
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera(int index) async {
    if (!mounted || index < 0 || index >= cameras.length) return;
    final oldController = _videoController;
    final url = cameras[index].url;
    final isMjpeg = _looksLikeMjpeg(url);
    if (isMjpeg) {
      setState(() { _currentCameraIndex = index; _isMjpegStream = true; _videoController = null; });
      oldController?.dispose();
      return;
    }
    final newController = VideoPlayerController.networkUrl(Uri.parse(url));
    await newController.initialize();
    newController..setLooping(true)..play();
    setState(() { _currentCameraIndex = index; _isMjpegStream = false; _videoController = newController; _videoKey = UniqueKey(); });
    Future.delayed(const Duration(milliseconds: 300), () => oldController?.dispose());
  }

  @override
  void dispose() { _videoController?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 3, child: _buildVideoDisplay()),
                  const SizedBox(width: 32),
                  Expanded(flex: 1, child: _buildCameraSidebar()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Text(l10n.t('Surveillance Cameras'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _showAddCameraDialog,
          icon: const Icon(Icons.add_a_photo_rounded),
          label: Text(l10n.t('Add Camera')),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoDisplay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: _buildVideoCore()),
          Positioned(
            bottom: 24, left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.circle, color: Colors.red, size: 10),
                  const SizedBox(width: 8),
                  Text(cameras[_currentCameraIndex].name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 24, right: 24,
            child: IconButton(
              icon: const Icon(Icons.fullscreen_rounded, color: Colors.white70, size: 32),
              onPressed: () { /* Fullscreen logic */ },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCore() {
    if (_isMjpegStream) return WebcamMjpegView(streamUrl: cameras[_currentCameraIndex].url, fit: BoxFit.cover);
    if (_videoController?.value.isInitialized ?? false) {
      return FittedBox(fit: BoxFit.cover, child: SizedBox(width: _videoController!.value.size.width, height: _videoController!.value.size.height, child: VideoPlayer(_videoController!, key: _videoKey)));
    }
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildCameraSidebar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CAMERA LIST', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: cameras.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final active = index == _currentCameraIndex;
                return GestureDetector(
                  onTap: () => _switchCamera(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary.withOpacity(0.2) : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppColors.primary : Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.videocam_rounded, color: active ? AppColors.primary : Colors.white30),
                        const SizedBox(width: 16),
                        Expanded(child: Text(cameras[index].name, style: TextStyle(color: active ? Colors.white : Colors.white60, fontWeight: active ? FontWeight.bold : FontWeight.normal))),
                        if (active) const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCameraDialog() {
    final l10n = AppLocalizations.of(context);
    final nameC = TextEditingController();
    final urlC = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: Text(l10n.t('Add New Camera'), style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: l10n.t('Camera Name'), labelStyle: const TextStyle(color: Colors.white38))),
            const SizedBox(height: 12),
            TextField(controller: urlC, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: l10n.t('Video URL'), labelStyle: const TextStyle(color: Colors.white38))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.t('Cancel'))),
          ElevatedButton(onPressed: () { if (nameC.text.isNotEmpty && urlC.text.isNotEmpty) { cameras.add(CameraItem(name: nameC.text.trim(), url: urlC.text.trim())); _switchCamera(cameras.length - 1); Navigator.pop(c); } }, child: Text(l10n.t('Add'))),
        ],
      ),
    );
  }

  bool _looksLikeMjpeg(String url) {
    final lower = url.toLowerCase();
    return lower.contains('/video') || lower.contains('/mjpeg') || lower.contains('.mjpg');
  }
}
