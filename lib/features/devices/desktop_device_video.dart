import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:thuctap/core/widgets/webcam_mjpeg_view.dart';
import 'package:thuctap/core/localization/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar:
          _isFullScreen ? null : AppBar(title: Text(l10n.t('Device Video'))),
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
                  child: WebcamMjpegView(
                    streamUrl: _localWebcamUrl,
                    fit: BoxFit.cover,
                  ),
                )
              : (_controller?.value.isInitialized ?? false)
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),

                    /// PLAY BUTTON
                    Center(
                      child: IconButton(
                        iconSize: 64,
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.white70,
                        ),
                        onPressed: _togglePlay,
                      ),
                    ),

                    /// TITLE
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.t('Master Bedroom Camera'),
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
