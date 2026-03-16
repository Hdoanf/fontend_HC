import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/location/presentation/providers/location_providers.dart';

class DesktopDeviceCard extends ConsumerStatefulWidget {
  final int? deviceId;
  final String deviceName;
  final String status;
  final bool isConnected;
  final bool initialIsOn;
  final IconData icon;
  final bool isDark;
  final VoidCallback? onDelete; // Add this

  const DesktopDeviceCard({
    super.key,
    this.deviceId,
    required this.deviceName,
    required this.status,
    required this.isConnected,
    required this.initialIsOn,
    required this.icon,
    this.isDark = true,
    this.onDelete, // Add this
  });

  @override
  ConsumerState<DesktopDeviceCard> createState() => _DesktopDeviceCardState();
}

class _DesktopDeviceCardState extends ConsumerState<DesktopDeviceCard> {
  late bool _isOn;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialIsOn;
  }

  @override
  void didUpdateWidget(DesktopDeviceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsOn != widget.initialIsOn) {
      _isOn = widget.initialIsOn;
    }
  }

  Future<void> _toggleDevice(bool value) async {
    if (widget.deviceId == null) {
      setState(() => _isOn = value);
      return;
    }

    setState(() {
      _isToggling = true;
      _isOn = value;
    });

    final roomApi = ref.read(roomApiProvider);
    final token = ref.read(authControllerProvider).value?.token ?? '';
    try {
      await roomApi.updateDeviceStatus(widget.deviceId!, value, token: token);
    } catch (e) {
      setState(() => _isOn = !value);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _isOn;
    final bool isDark = widget.isDark;

    // Define colors based on isDark and active state
    final Color backgroundColor = active 
        ? AppColors.primary 
        : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05));
    
    final Color borderColor = active 
        ? AppColors.primary 
        : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1));
    
    final Color titleColor = active 
        ? Colors.white 
        : (isDark ? Colors.white : Colors.black87);
    
    final Color statusColor = active 
        ? Colors.white.withOpacity(0.8) 
        : (isDark ? Colors.white38 : Colors.black54);
    
    final Color iconColor = active 
        ? Colors.white 
        : (isDark ? Colors.white : Colors.black54);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: active ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ] : [],
      ),
      child: Row(
        children: [
          /// ICON CONTAINER
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: active ? Colors.white.withOpacity(0.2) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
              shape: BoxShape.circle,
            ),
            child: _isToggling 
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2, color: active ? Colors.white : AppColors.primary),
                )
              : Icon(
                  widget.icon,
                  size: 22,
                  color: iconColor,
                ),
          ),
          
          const SizedBox(width: 16),
          
          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.deviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// DELETE BUTTON (IF PROVIDED)
          if (widget.onDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: isDark ? Colors.white30 : Colors.black26,
                size: 20,
              ),
              onPressed: widget.onDelete,
            ),

          /// TOGGLE
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _isOn,
              onChanged: _isToggling ? null : _toggleDevice,
              activeColor: Colors.white,
              activeTrackColor: Colors.white.withOpacity(0.3),
              inactiveThumbColor: isDark ? Colors.white30 : Colors.black26,
              inactiveTrackColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }
}
