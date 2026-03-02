import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/features/location/data/models/device_location_model.dart';
import 'package:thuctap/features/location/data/room_service.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import '../widgets/mobile/mobile_location_map.dart';

class MobileLocationPage extends ConsumerStatefulWidget {
  final String? initialRoom;
  const MobileLocationPage({super.key, this.initialRoom});

  @override
  ConsumerState<MobileLocationPage> createState() => _MobileLocationPageState();
}

class _MobileLocationPageState extends ConsumerState<MobileLocationPage> {
  List<DeviceLocationModel> devices = [];
  late String selectedRoom;
  bool isLoading = false;

  // Mock initial structure for room tabs
  final List<String> availableRooms = [
    AppStrings.bedRoom,
    AppStrings.livingRoom,
    'Kitchen',
    AppStrings.studyRoom,
    AppStrings.guestRoom,
  ];

  final Map<String, String> roomImages = {
    AppStrings.bedRoom:
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
    'Kitchen':
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=500',
    AppStrings.livingRoom:
        'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=500',
    AppStrings.studyRoom:
        'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=500',
    AppStrings.guestRoom:
        'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=500',
  };

  @override
  void initState() {
    super.initState();
    selectedRoom = widget.initialRoom ?? AppStrings.bedRoom;
    if (!availableRooms.contains(selectedRoom)) {
      selectedRoom = availableRooms.first;
    }
    _fetchDevices(selectedRoom);
  }

  Future<void> _fetchDevices(String roomName) async {
    setState(() => isLoading = true);
    try {
      final fetchedDevices = await ref.read(roomServiceProvider).getDevicesByRoom(roomName);
      if (mounted) {
        setState(() {
          devices = fetchedDevices;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _changeRoom(String roomName) {
    if (selectedRoom == roomName) return;
    setState(() => selectedRoom = roomName);
    _fetchDevices(roomName);
  }

  void _toggleDeviceState(DeviceLocationModel device) {
    setState(() {
      final index = devices.indexWhere((d) => d.id == device.id);
      if (index != -1) {
        devices[index] = DeviceLocationModel(
          id: device.id,
          name: device.name,
          roomId: device.roomId,
          x: device.x,
          y: device.y,
          status: device.status,
          isOn: !device.isOn,
          icon: device.icon,
        );
      }
    });
  }

  void _addNewDevice(String deviceName) {
    final random = Random();
    setState(() {
      final newDevice = DeviceLocationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: deviceName,
        roomId: selectedRoom,
        x: (random.nextInt(81) + 10).toDouble(),
        y: (random.nextInt(81) + 10).toDouble(),
        status: 'Connected',
        isOn: false,
        icon: 'default',
      );
      devices.add(newDevice);
      devices = List.from(devices);
    });
  }

  void _showAddDeviceDialog() {
    final TextEditingController deviceNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Add New Device', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          content: TextField(
            controller: deviceNameController,
            decoration: InputDecoration(
              hintText: "Enter device name",
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                if (deviceNameController.text.isNotEmpty) {
                  _addNewDevice(deviceNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Home Location',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSizes.paddingMedium, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Selector Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: availableRooms.map((roomName) {
                  final isSelected = selectedRoom == roomName;
                  return GestureDetector(
                    onTap: () => _changeRoom(roomName),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ] : [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.03),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        roomName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Map Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: isLoading 
                ? const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()))
                : MobileLocationMap(
                    devices: devices,
                    roomImage: roomImages[selectedRoom] ??
                        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
                    onDeviceTap: _toggleDeviceState,
                  ),
            ),
            // Devices List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Devices in this room',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      InkWell(
                        onTap: _showAddDeviceDialog,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(devices.length, (index) {
                    final device = devices[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: device.isOn
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : AppColors.surfaceGray,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.devices_rounded,
                              color: device.isOn
                                  ? AppColors.primary
                                  : AppColors.textLight,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  device.status,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: device.status == 'Connected'
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: device.isOn,
                            onChanged: device.status == 'Connected'
                                ? (val) {
                                    setState(() {
                                      devices[index] = DeviceLocationModel(
                                        id: device.id,
                                        name: device.name,
                                        roomId: device.roomId,
                                        x: device.x,
                                        y: device.y,
                                        status: device.status,
                                        isOn: val,
                                        icon: device.icon,
                                      );
                                    });
                                  }
                                : null,
                            activeColor: AppColors.success,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
