import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:thuctap/core/widgets/webcam_mjpeg_view.dart';

class DesktopDeviceVideo extends StatefulWidget {
  const DesktopDeviceVideo({super.key});

  @override
  State<DesktopDeviceVideo> createState() => _DesktopDeviceVideoState();
}

class _DesktopDeviceVideoState extends State<DesktopDeviceVideo> {
  static const String _localWebcamUrl = 'http://192.168.1.55:8080/video';

  VideoPlayerController? _controller;
  bool _isFullScreen = false;
  late final bool _isMjpegStream;

  @override
  void initState() {
    super.initState();
    _isMjpegStream = _looksLikeMjpeg(_localWebcamUrl);
    if (_isMjpegStream) return;

    _controller = VideoPlayerController.networkUrl(Uri.parse(_localWebcamUrl))
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(title: const Text('Device Video')),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(_isFullScreen ? 0 : 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isFullScreen ? MediaQuery.of(context).size.height : 220,
          width: _isFullScreen
              ? MediaQuery.of(context).size.width
              : double.infinity,
          color: Colors.black,
          child: _isMjpegStream
              ? InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: WebcamMjpegView(
                    streamUrl: _localWebcamUrl,
                    fit: BoxFit.cover,
                  ),
                )
              : (_controller?.value.isInitialized ?? false)
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    InteractiveViewer(
                      clipBehavior: Clip.none,
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),

                    /// CONTROLS OVERLAY
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),

                    /// PLAY/PAUSE & REWIND/FORWARD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.replay_10_rounded, color: Colors.white70),
                          onPressed: () {
                            final newPosition = _controller!.value.position - const Duration(seconds: 10);
                            _controller!.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
                          },
                        ),
                        IconButton(
                          iconSize: 64,
                          icon: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.white70,
                          ),
                          onPressed: _togglePlay,
                        ),
                        IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.forward_10_rounded, color: Colors.white70),
                          onPressed: () {
                            final newPosition = _controller!.value.position + const Duration(seconds: 10);
                            _controller!.seekTo(newPosition);
                          },
                        ),
                      ],
                    ),

                    /// PROGRESS SLIDER
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              bufferedColor: Colors.white24,
                              backgroundColor: Colors.white10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// TITLE
                    Positioned(
                      left: 16,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Master Bedroom Camera',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
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
