import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';

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
  const DesktopLocationPage({super.key});

  @override
  State<DesktopLocationPage> createState() => _DesktopLocationPageState();
}

class _DesktopLocationPageState extends State<DesktopLocationPage> {
  SmartRoom? selectedRoom;

  late final List<SmartRoom> rooms = [
    SmartRoom(
      name: 'Living Room',
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
      name: 'Bedroom',
      color: AppColors.roomCardBed,
      image: 'assets/images/bedroom.png',
      devices: [
        SmartDevice(name: 'Air Conditioner', isOn: true),
        SmartDevice(name: 'Night Lamp'),
      ],
    ),
    SmartRoom(
      name: 'Office',
      color: AppColors.roomCardGuest,
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
      backgroundColor: AppColors.surfaceLight,
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
                  const SizedBox(width: 24),
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
          'Home / Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Spacer(),
        Icon(Icons.settings, color: AppColors.textSecondary),
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
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          colors: [Color(0xFFEAFBFF), Color(0xFFF4F1FF)],
        ),
      ),
      child: Column(
        children: [
          _roomTile(room('Living Room'), height: 160),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _roomTile(room('Bedroom'), height: 140)),
              const SizedBox(width: 20),
              Expanded(child: _roomTile(room('Kitchen'), height: 140)),
            ],
          ),
          const SizedBox(height: 20),
          _roomTile(room('Office'), height: 140),
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
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          image: DecorationImage(
            image: AssetImage(room.image),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.45),
                Colors.black.withOpacity(0.1),
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
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  room.devices.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
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
        title: const Text('Add new device'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Device name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              setState(() {
                widget.room.devices.add(SmartDevice(name: name));
              });

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.room.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.room.devices.length} devices',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              TextButton.icon(
                onPressed: _showAddDeviceDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add device'),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceLight,
      ),
      child: Row(
        children: [
          Text(device.name, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Switch(
            value: device.isOn,
            activeColor: AppColors.primary,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Text(
        'Select a room to control devices',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
