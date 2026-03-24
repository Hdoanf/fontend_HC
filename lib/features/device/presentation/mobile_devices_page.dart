import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:thuctap/core/widgets/webcam_mjpeg_view.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

class MobileDevicesPage extends StatefulWidget {
  const MobileDevicesPage({super.key});

  @override
  State<MobileDevicesPage> createState() => _MobileDevicesPageState();
}

class _MobileDevicesPageState extends State<MobileDevicesPage> {
  static const String _localWebcamUrl = 'http://192.168.1.55:8080/video';

  final List<Map<String, String>> cameras = [
    {'name': 'Living Room Cam', 'videoUrl': _localWebcamUrl},
    {
      'name': 'Bedroom Cam',
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    },
    {
      'name': 'Kitchen Cam',
      'videoUrl':
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    },
    {
      'name': 'Front Door Cam',
      'videoUrl':
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
  ];

  void _showVideoDialog(String videoUrl, String cameraName) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) =>
          VideoDialog(videoUrl: videoUrl, cameraName: cameraName),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1.drive(Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic))),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Cameras',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSizes.paddingMedium, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingMedium, top: 8, bottom: 8),
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.paddingLarge),
            _buildCamerasHeader(),
            const SizedBox(height: AppSizes.paddingMedium),
            _buildCamerasGrid(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ================= CAMERAS HEADER =================
  Widget _buildCamerasHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Text(
        'Live Feeds',
        style: TextStyle(
          fontSize: AppSizes.fontXXLarge, 
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  // ================= GRID CAMERAS =================
  Widget _buildCamerasGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cameras.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showVideoDialog(camera['videoUrl']!, camera['name']!),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam_rounded, 
                    size: 32, 
                    color: AppColors.primary
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  camera['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Connected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
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
      backgroundColor: Colors.transparent,
      insetPadding: _isFullScreen
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: _isFullScreen ? Colors.black : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(_isFullScreen ? 0 : 28),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isFullScreen)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cameraName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            Flexible(child: _buildRoomVideo()),
          ],
        ),
      ),
    );
  }

  // ================= VIDEO =================
  Widget _buildRoomVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: Colors.black,
        child: _isMjpegStream
            ? InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 1.0,
                maxScale: 4.0,
                child: WebcamMjpegView(
                  streamUrl: widget.videoUrl,
                  fit: BoxFit.cover,
                ),
              )
            : (_videoController?.value.isInitialized ?? false)
            ? Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    clipBehavior: Clip.none,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  ),

                  /// CONTROLS OVERLAY
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _videoController!.value.isPlaying
                              ? _videoController!.pause()
                              : _videoController!.play();
                        });
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),

                  /// CENTER CONTROLS
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.replay_10_rounded, color: Colors.white70),
                          onPressed: () {
                            final newPos = _videoController!.value.position - const Duration(seconds: 10);
                            _videoController!.seekTo(newPos < Duration.zero ? Duration.zero : newPos);
                          },
                        ),
                        IconButton(
                          iconSize: 56,
                          icon: Icon(
                            _videoController!.value.isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
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
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.forward_10_rounded, color: Colors.white70),
                          onPressed: () {
                            final newPos = _videoController!.value.position + const Duration(seconds: 10);
                            _videoController!.seekTo(newPos);
                          },
                        ),
                      ],
                    ),
                  ),

                  /// PROGRESS BAR
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppColors.primary,
                        bufferedColor: Colors.white24,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                  Positioned(
                    top: _isFullScreen ? 40 : 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        _isFullScreen
                            ? Icons.fullscreen_exit_rounded
                            : Icons.fullscreen_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _toggleFullScreen,
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
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
