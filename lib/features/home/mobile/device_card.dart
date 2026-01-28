import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

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
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.15),
            ),
            child: Icon(
              widget.icon,
              size: AppSizes.iconMedium,
              color: active ? Colors.white : Colors.grey,
            ),
          ),

          const SizedBox(width: AppSizes.paddingMedium),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.deviceName,
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.status,
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    color: active ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          /// SWITCH (🔥 BẬT/TẮT ĐƯỢC)
          Switch(
            value: _isOn,
            onChanged: widget.isConnected
                ? (value) {
                    setState(() {
                      _isOn = value;
                    });
                  }
                : null, // mất kết nối → disable
            activeThumbColor: Colors.white,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
