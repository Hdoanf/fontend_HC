import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';

class DesktopUIHelper {
  static Color getRoomColor(String roomName) {
    final key = roomName.toLowerCase();
    if (key.contains('bed') || key.contains('ngủ')) return AppColors.roomCardBed;
    if (key.contains('living') || key.contains('khách')) return AppColors.roomCardLiving;
    if (key.contains('kitchen') || key.contains('bếp')) return AppColors.roomCardKitchen;
    if (key.contains('office') || key.contains('làm việc')) return AppColors.roomCardStudy;
    return AppColors.roomCardGuest;
  }

  static String getRoomImage(String roomName) {
    final key = roomName.toLowerCase();
    if (key.contains('bed') || key.contains('ngủ')) return 'assets/images/double-bed.png';
    if (key.contains('living') || key.contains('khách')) return 'assets/images/sofa.png';
    if (key.contains('kitchen') || key.contains('bếp')) return 'assets/images/chair.png';
    if (key.contains('office') || key.contains('làm việc')) return 'assets/images/office.png';
    return 'assets/images/bed.png';
  }

  static IconData getDeviceIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('ac') || t.contains('air')) return Icons.air_rounded;
    if (t.contains('fan')) return Icons.wind_power_rounded;
    if (t.contains('light') || t.contains('lamp')) return Icons.lightbulb_outline_rounded;
    if (t.contains('tv')) return Icons.tv_rounded;
    if (t.contains('camera')) return Icons.videocam_rounded;
    if (t.contains('door')) return Icons.door_front_door_rounded;
    return Icons.devices_rounded;
  }

  static String getInitials(String? name, String? email) {
    final source = (name?.trim().isNotEmpty == true) ? name!.trim() : email;
    if (source == null || source.trim().isEmpty) return '?';
    final parts = source.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
