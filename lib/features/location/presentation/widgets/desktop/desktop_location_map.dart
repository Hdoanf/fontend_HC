import 'package:flutter/material.dart';
import 'package:thuctap/features/location/data/models/device_location_model.dart';

class DesktopLocationMap extends StatefulWidget {
  final List<DeviceLocationModel> devices;
  final String roomImage;

  const DesktopLocationMap({
    Key? key,
    required this.devices,
    required this.roomImage,
  }) : super(key: key);

  @override
  State<DesktopLocationMap> createState() => _DesktopLocationMapState();
}

class _DesktopLocationMapState extends State<DesktopLocationMap> {
  late TransformationController _controller;

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
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Room Background
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 0.5,
              maxScale: 4.0,
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
                          size: 80,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Device Markers
          Positioned.fill(
            child: CustomPaint(
              painter: DesktopDeviceMapPainter(
                devices: widget.devices,
              ),
            ),
          ),
          // Controls Panel
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Legend',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLegendItem('On', const Color(0xFF2563EB)),
                  const SizedBox(height: 6),
                  _buildLegendItem('Off', Colors.grey[400]!),
                ],
              ),
            ),
          ),
          // Zoom Instructions
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Use mouse wheel to zoom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}

class DesktopDeviceMapPainter extends CustomPainter {
  final List<DeviceLocationModel> devices;

  DesktopDeviceMapPainter({
    required this.devices,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final device in devices) {
      final x = (device.x / 100) * size.width;
      final y = (device.y / 100) * size.height;

      // Draw marker circle
      final paint = Paint()
        ..color = device.isOn
            ? const Color(0xFF2563EB)
            : Colors.grey[400]!
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 18, paint);

      // Draw white border
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(x, y), 18, borderPaint);

      // Draw status indicator
      final statusPaint = Paint()
        ..color = device.isOn ? Colors.green : Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x + 12, y - 12), 5, statusPaint);

      // Draw device label
      final labelTextPainter = TextPainter(
        text: TextSpan(
          text: device.name,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            background: Paint()..color = Colors.white70,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelTextPainter.layout();
      labelTextPainter.paint(
        canvas,
        Offset(x - labelTextPainter.width / 2, y + 24),
      );
    }
  }

  @override
  bool shouldRepaint(DesktopDeviceMapPainter oldDelegate) {
    return oldDelegate.devices != devices;
  }
}
