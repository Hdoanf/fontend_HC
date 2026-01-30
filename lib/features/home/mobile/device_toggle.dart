import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

class DeviceToggle extends StatefulWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const DeviceToggle({super.key, required this.isOn, required this.onChanged});

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
        widget.onChanged(_isOn);
      },
      child: Container(
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          color: _isOn
              ? const Color.fromARGB(255, 4, 65, 186)
              : AppColors.disabled,
          borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: _isOn ? 28 : 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
