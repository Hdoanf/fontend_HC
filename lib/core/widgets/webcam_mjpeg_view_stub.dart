import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class WebcamMjpegView extends StatelessWidget {
  const WebcamMjpegView({
    super.key,
    required this.streamUrl,
    this.fit = BoxFit.cover,
  });

  final String streamUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Mjpeg(
      isLive: true,
      stream: streamUrl,
      fit: fit,
      error: (context, error, stackTrace) {
        return const Center(
          child: Text(
            'Khong tai duoc stream webcam',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
