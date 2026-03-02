import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_strings.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

/// ===================== MODELS =====================

class SmartDevice {
  final String name;
  bool isOn;

  SmartDevice({required this.name, this.isOn = false});
}

class SmartRoom {
  final String name;
  final Color color;
  final String image;
  final List<SmartDevice> devices;

  SmartRoom({
    required this.name,
    required this.color,
    required this.image,
    required this.devices,
  });
}

/// ===================== PAGE =====================

class DesktopLocationPage extends StatefulWidget {
  final String? initialRoomName;
  const DesktopLocationPage({super.key, this.initialRoomName});

  @override
  State<DesktopLocationPage> createState() => _DesktopLocationPageState();
}

class _DesktopLocationPageState extends State<DesktopLocationPage> {
  SmartRoom? selectedRoom;

  @override
  void initState() {
    super.initState();
    if (widget.initialRoomName != null) {
      try {
        selectedRoom = rooms.firstWhere((r) => r.name == widget.initialRoomName);
      } catch (e) {
        selectedRoom = rooms.first;
      }
    } else {
      selectedRoom = rooms.first;
    }
  }

  late final List<SmartRoom> rooms = [
    SmartRoom(
      name: AppStrings.livingRoom,
      color: AppColors.roomCardLiving,
      image: 'assets/images/living_room.png',
      devices: [
        SmartDevice(name: 'Lamp', isOn: true),
        SmartDevice(name: 'TV'),
        SmartDevice(name: 'Speaker'),
      ],
    ),
    SmartRoom(
      name: 'Kitchen',
      color: AppColors.roomCardKitchen,
      image: 'assets/images/kitchen.png',
      devices: [
        SmartDevice(name: 'Oven'),
        SmartDevice(name: 'Light', isOn: true),
      ],
    ),
    SmartRoom(
      name: AppStrings.bedRoom,
      color: AppColors.roomCardBed,
      image: 'assets/images/bedroom.png',
      devices: [
        SmartDevice(name: 'Air Conditioner', isOn: true),
        SmartDevice(name: 'Night Lamp'),
      ],
    ),
    SmartRoom(
      name: AppStrings.studyRoom,
      color: AppColors.roomCardStudy,
      image: 'assets/images/office.png',
      devices: [
        SmartDevice(name: 'PC'),
        SmartDevice(name: 'Desk Lamp'),
      ],
    ),
  ];

  void selectRoom(String roomName) {
    setState(() {
      selectedRoom = rooms.firstWhere((r) => r.name == roomName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const _Header(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DesktopHouseOverview(
                      rooms: rooms,
                      selectedRoom: selectedRoom,
                      onRoomTap: selectRoom,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: selectedRoom == null
                          ? const _EmptyPanel()
                          : RoomControlPanel(
                              key: ValueKey(selectedRoom!.name),
                              room: selectedRoom!,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================== HEADER =====================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          'Home / Rooms',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Spacer(),
        Icon(Icons.settings_rounded, color: AppColors.textSecondary),
      ],
    );
  }
}

/// ===================== HOUSE MAP =====================

class DesktopHouseOverview extends StatelessWidget {
  final List<SmartRoom> rooms;
  final SmartRoom? selectedRoom;
  final void Function(String roomName) onRoomTap;

  const DesktopHouseOverview({
    super.key,
    required this.rooms,
    required this.onRoomTap,
    this.selectedRoom,
  });

  SmartRoom room(String name) => rooms.firstWhere((r) => r.name == name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _roomTile(room(AppStrings.livingRoom), height: 180),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _roomTile(room(AppStrings.bedRoom), height: 160)),
              const SizedBox(width: 24),
              Expanded(child: _roomTile(room('Kitchen'), height: 160)),
            ],
          ),
          const SizedBox(height: 24),
          _roomTile(room(AppStrings.studyRoom), height: 160),
        ],
      ),
    );
  }

  Widget _roomTile(SmartRoom room, {required double height}) {
    final isSelected = selectedRoom?.name == room.name;

    return GestureDetector(
      onTap: () => onRoomTap(room.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3)
              : Border.all(color: Colors.transparent, width: 3),
          image: DecorationImage(
            image: AssetImage(room.image),
            fit: BoxFit.cover,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ] : [
             BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  room.devices.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===================== CONTROL PANEL =====================

class RoomControlPanel extends StatefulWidget {
  final SmartRoom room;

  const RoomControlPanel({super.key, required this.room});

  @override
  State<RoomControlPanel> createState() => _RoomControlPanelState();
}

class _RoomControlPanelState extends State<RoomControlPanel> {
  void _showAddDeviceDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Add New Device', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16)
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Device name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              setState(() {
                widget.room.devices.add(SmartDevice(name: name));
              });

              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.room.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.room.devices.length} connected devices',
                style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500, fontSize: 15),
              ),
              InkWell(
                onTap: _showAddDeviceDialog,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                      SizedBox(width: 6),
                      Text('Add Device', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: widget.room.devices.map((device) {
                return _DeviceTile(
                  device: device,
                  onChanged: (v) {
                    setState(() => device.isOn = v);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================== DEVICE TILE =====================

class _DeviceTile extends StatelessWidget {
  final SmartDevice device;
  final ValueChanged<bool> onChanged;

  const _DeviceTile({required this.device, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.background,
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: device.isOn ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceGray,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.devices_rounded, 
              color: device.isOn ? AppColors.primary : AppColors.textLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              device.name, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
          Switch(
            value: device.isOn,
            activeColor: AppColors.success,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// ===================== EMPTY PANEL =====================

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.meeting_room_rounded, size: 64, color: AppColors.textLight.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'Select a room to control devices',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
