import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

class DeviceToggle extends StatefulWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;
  final bool isConnected;

  const DeviceToggle({super.key, required this.isOn, required this.onChanged, this.isConnected = true});

  @override
  State<DeviceToggle> createState() => _DeviceToggleState();
}

class _DeviceToggleState extends State<DeviceToggle> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }
  
  @override
  void didUpdateWidget(covariant DeviceToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.isOn != widget.isOn) {
      _isOn = widget.isOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isConnected ? () {
        setState(() {
          _isOn = !_isOn;
        });
        widget.onChanged(_isOn);
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          color: !widget.isConnected ? AppColors.disabled : (_isOn ? AppColors.success : AppColors.surfaceGray),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isOn && widget.isConnected ? [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isOn ? 26 : 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
