import 'package:flutter/material.dart';
import 'package:thuctap/features/location/data/models/device_location_model.dart';

class MobileLocationMap extends StatefulWidget {
  final List<DeviceLocationModel> devices;
  final String roomImage;
  final Function(DeviceLocationModel) onDeviceTap;

  const MobileLocationMap({
    Key? key,
    required this.devices,
    required this.roomImage,
    required this.onDeviceTap,
  }) : super(key: key);

  @override
  State<MobileLocationMap> createState() => _MobileLocationMapState();
}

class _MobileLocationMapState extends State<MobileLocationMap> {
  late TransformationController _controller;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Room Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 0.5,
              maxScale: 3.0,
              onInteractionUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  _scale = details.scale;
                });
              },
              child: Container(
                color: Colors.grey[200],
                child: Image.network(
                  widget.roomImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Device Markers Overlay
          GestureDetector(
            onTapDown: (details) {
              for (final device in widget.devices) {
                final devicePos = Offset(
                  (device.x / 100) * context.size!.width,
                  (device.y / 100) * context.size!.height,
                );
                if ((details.localPosition - devicePos).distance < 20) {
                  widget.onDeviceTap(device);
                }
              }
            },
            child: CustomPaint(
              painter: DeviceMapPainter(
                devices: widget.devices,
                scale: _scale,
              ),
            ),
          ),
          // Legend
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'On',
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Off',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceMapPainter extends CustomPainter {
  final List<DeviceLocationModel> devices;
  final double scale;

  DeviceMapPainter({
    required this.devices,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final device in devices) {
      // Position based on device x, y coordinates (0-100)
      final x = (device.x / 100) * size.width;
      final y = (device.y / 100) * size.height;

      // Draw device marker
      final paint = Paint()
        ..color = device.isOn
            ? const Color(0xFF2563EB)
            : Colors.grey[400]!
        ..style = PaintingStyle.fill;

      // Draw circle
      canvas.drawCircle(Offset(x, y), 16, paint);

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(x, y), 16, borderPaint);

      // Draw icon
      final icon = device.isOn ? Icons.lightbulb : Icons.lightbulb_outline;
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: icon.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );

      // Draw device name
      final nameTextPainter = TextPainter(
        text: TextSpan(
          text: device.name,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            backgroundColor: Colors.white.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      nameTextPainter.layout();
      nameTextPainter.paint(
        canvas,
        Offset(x - nameTextPainter.width / 2, y + 20),
      );
    }
  }

  @override
  bool shouldRepaint(DeviceMapPainter oldDelegate) {
    return oldDelegate.devices != devices || oldDelegate.scale != scale;
  }
}
