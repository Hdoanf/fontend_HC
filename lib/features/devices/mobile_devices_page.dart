import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:thuctap/core/widgets/webcam_mjpeg_view.dart';

class MobileDevicesPage extends StatefulWidget {
  const MobileDevicesPage({super.key});

  @override
  State<MobileDevicesPage> createState() => _MobileDevicesPageState();
}

class _MobileDevicesPageState extends State<MobileDevicesPage> {
  static const String _localWebcamUrl = 'http://192.168.1.33:8080/video';

  final List<Map<String, String>> cameras = [
    {'name': 'Cam 1', 'videoUrl': _localWebcamUrl},
    {
      'name': 'Cam 2',
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    },
    {
      'name': 'Cam 3',
      'videoUrl':
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    },
    {
      'name': 'Cam 4',
      'videoUrl':
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
  ];

  void _showVideoDialog(String videoUrl, String cameraName) {
    showDialog(
      context: context,
      builder: (context) =>
          VideoDialog(videoUrl: videoUrl, cameraName: cameraName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Cameras',
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
            const SizedBox(height: 24),
            _buildCamerasHeader(),
            const SizedBox(height: 16),
            _buildCamerasGrid(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ================= CAMERAS HEADER =================
  Widget _buildCamerasHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Live Feeds',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ================= GRID CAMERAS =================
  Widget _buildCamerasGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cameras.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          return _buildCameraCard(index);
        },
      ),
    );
  }

  // ================= CAMERA CARD =================
  Widget _buildCameraCard(int index) {
    final camera = cameras[index];

    return GestureDetector(
      onTap: () => _showVideoDialog(camera['videoUrl']!, camera['name']!),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam, size: 48, color: Color(0xFF2563EB)),
            const SizedBox(height: 12),
            Text(
              camera['name']!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoDialog extends StatefulWidget {
  final String videoUrl;
  final String cameraName;

  const VideoDialog({
    super.key,
    required this.videoUrl,
    required this.cameraName,
  });

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  VideoPlayerController? _videoController;
  bool _isFullScreen = false;
  late final bool _isMjpegStream;

  @override
  void initState() {
    super.initState();
    _isMjpegStream = _looksLikeMjpeg(widget.videoUrl);

    if (_isMjpegStream) return;

    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() {});
            _videoController?.play();
          })
          ..setLooping(true);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: _isFullScreen
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isFullScreen ? MediaQuery.of(context).size.width : null,
        height: _isFullScreen ? MediaQuery.of(context).size.height : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isFullScreen)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cameraName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            Expanded(child: _buildRoomVideo()),
          ],
        ),
      ),
    );
  }

  // ================= VIDEO =================
  Widget _buildRoomVideo() {
    return ClipRRect(
      borderRadius: _isFullScreen
          ? BorderRadius.zero
          : const BorderRadius.all(Radius.circular(16)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: Colors.black,
        child: _isMjpegStream
            ? InteractiveViewer(
                child: WebcamMjpegView(
                  streamUrl: widget.videoUrl,
                  fit: BoxFit.cover,
                ),
              )
            : (_videoController?.value.isInitialized ?? false)
            ? Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      iconSize: 56,
                      icon: Icon(
                        _videoController!.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _videoController!.value.isPlaying
                              ? _videoController!.pause()
                              : _videoController!.play();
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: _isFullScreen ? 40 : 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        _isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      onPressed: _toggleFullScreen,
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

  bool _looksLikeMjpeg(String url) {
    final lower = url.toLowerCase();
    return lower.contains('/video') ||
        lower.contains('/mjpeg') ||
        lower.contains('.mjpg');
  }
}
