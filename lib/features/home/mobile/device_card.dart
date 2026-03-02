import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'device_toggle.dart';

class DeviceCard extends StatefulWidget {
  final String deviceName;
  final String status;
  final bool isConnected;
  final bool initialIsOn;
  final IconData icon;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.isConnected,
    required this.initialIsOn,
    required this.icon,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialIsOn;
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _isOn && widget.isConnected;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: active
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.08),
            ),
            child: Icon(
              widget.icon,
              size: 26,
              color: active ? Colors.white : AppColors.primary,
            ),
          ),

          const SizedBox(width: 16),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.deviceName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          /// CUSTOM SWITCH
          DeviceToggle(
            isOn: _isOn,
            isConnected: widget.isConnected,
            onChanged: (value) {
              setState(() {
                _isOn = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
