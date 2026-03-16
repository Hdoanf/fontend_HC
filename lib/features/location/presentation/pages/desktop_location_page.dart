import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/core/utils/desktop_ui_helper.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/location/data/models/home_model.dart';
import 'package:thuctap/features/home/desktop/desktop_device_card.dart';
import 'package:thuctap/features/location/presentation/providers/location_providers.dart';

class SmartDevice {
  final int deviceId;
  final String name;
  final String type;
  bool isOn;
  SmartDevice({
    required this.deviceId,
    required this.name,
    required this.type,
    this.isOn = false,
  });
}

class SmartRoom {
  final int roomId;
  final String name;
  final List<SmartDevice> devices;
  SmartRoom({required this.roomId, required this.name, required this.devices});
  SmartRoom copyWith({List<SmartDevice>? devices}) =>
      SmartRoom(roomId: roomId, name: name, devices: devices ?? this.devices);
}

class DesktopLocationPage extends ConsumerStatefulWidget {
  const DesktopLocationPage({super.key});
  @override
  ConsumerState<DesktopLocationPage> createState() =>
      _DesktopLocationPageState();
}

class _DesktopLocationPageState extends ConsumerState<DesktopLocationPage> {
  List<HomeModel> _homes = [];
  List<SmartRoom> _rooms = [];
  SmartRoom? _selectedRoom;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHomes());
  }

  Future<void> _loadHomes() async {
    final homeApi = ref.read(homeApiProvider);
    final token = ref.read(authControllerProvider).value?.token ?? '';
    setState(() => _isLoading = true);
    try {
      final homes = await homeApi.fetchHomes(token: token);
      if (mounted) {
        setState(() {
          _homes = homes;
          final currentSelected = ref.read(selectedHomeProvider);
          if (homes.isNotEmpty) {
            final nextHome =
                _homes.any((h) => h.homeId == currentSelected?.homeId)
                ? currentSelected!
                : homes.first;
            ref.read(selectedHomeProvider.notifier).state = nextHome;
            _loadRooms();
          } else {
            _isLoading = false;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRooms() async {
    final roomApi = ref.read(roomApiProvider);
    final selectedHome = ref.read(selectedHomeProvider);
    if (selectedHome == null) return;
    final token = ref.read(authControllerProvider).value?.token ?? '';
    setState(() => _isLoading = true);
    try {
      final list = await roomApi.fetchRooms(
        homeId: selectedHome.homeId,
        token: token,
      );
      final mapped = list
          .map(
            (r) => SmartRoom(roomId: r.roomId, name: r.roomName, devices: []),
          )
          .toList();
      if (mounted) {
        setState(() {
          _rooms = mapped;
          _isLoading = false;
          if (_rooms.isNotEmpty) {
            _selectedRoom = _rooms.first;
            _loadDevicesForRoom(_selectedRoom!);
          } else {
            _selectedRoom = null;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDevicesForRoom(SmartRoom room) async {
    final roomApi = ref.read(roomApiProvider);
    final token = ref.read(authControllerProvider).value?.token ?? '';
    try {
      final devices = await roomApi.fetchDevicesByRoom(
        room.roomId,
        token: token,
      );
      final mapped = devices
          .map(
            (d) => SmartDevice(
              deviceId: d.deviceId,
              name: d.name,
              type: d.type,
              isOn: d.status,
            ),
          )
          .toList();
      if (mounted) {
        setState(() {
          final idx = _rooms.indexWhere((r) => r.roomId == room.roomId);
          if (idx != -1) {
            _rooms[idx] = _rooms[idx].copyWith(devices: mapped);
            if (_selectedRoom?.roomId == room.roomId)
              _selectedRoom = _rooms[idx];
          }
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _homes.isEmpty
                  ? const Center(
                      child: Text(
                        'Vui lòng tạo nhà ở trang chủ trước.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(flex: 3, child: _buildRoomsGrid()),
                        const SizedBox(width: 32),
                        Expanded(flex: 2, child: _buildControlPanel()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final selectedHome = ref.watch(selectedHomeProvider);
    return Row(
      children: [
        const Text(
          'Home / Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 24),
        if (_homes.isNotEmpty) _buildHomeDropdown(selectedHome),
        const Spacer(),
        _ActionButton(
          icon: Icons.add,
          label: 'Thêm phòng',
          onTap: _showAddRoomDialog,
        ),
      ],
    );
  }

  Widget _buildHomeDropdown(HomeModel? selectedHome) {
    final safeValue = _homes.any((h) => h.homeId == selectedHome?.homeId)
        ? _homes.firstWhere((h) => h.homeId == selectedHome?.homeId)
        : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButton<HomeModel>(
        value: safeValue,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF262626),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        items: _homes
            .map((h) => DropdownMenuItem(value: h, child: Text(h.name)))
            .toList(),
        onChanged: (val) {
          if (val != null) {
            ref.read(selectedHomeProvider.notifier).state = val;
            _loadRooms();
          }
        },
      ),
    );
  }

  Widget _buildRoomsGrid() {
    if (_rooms.isEmpty)
      return const Center(
        child: Text(
          'Chưa có phòng nào.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: _rooms.length,
      itemBuilder: (context, index) {
        final room = _rooms[index];
        final isSelected = _selectedRoom?.roomId == room.roomId;
        return _RoomGridItem(
          room: room,
          isSelected: isSelected,
          onTap: () {
            setState(() => _selectedRoom = room);
            _loadDevicesForRoom(room);
          },
        );
      },
    );
  }

  Widget _buildControlPanel() {
    if (_selectedRoom == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedRoom!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                onPressed: () => _confirmDeleteRoom(_selectedRoom!),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ActionButton(
            icon: Icons.add,
            label: 'Thêm thiết bị',
            onTap: () => _showAddDeviceDialog(_selectedRoom!),
            isSecondary: true,
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),
          Expanded(
            child: _selectedRoom!.devices.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có thiết bị nào',
                      style: TextStyle(color: Colors.white30),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedRoom!.devices.length,
                    itemBuilder: (context, index) {
                      final d = _selectedRoom!.devices[index];
                      final l10n = AppLocalizations.of(context);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DesktopDeviceCard(
                          deviceId: d.deviceId,
                          deviceName: d.name,
                          status: d.isOn ? l10n.on : l10n.off,
                          isConnected: true,
                          initialIsOn: d.isOn,
                          icon: DesktopUIHelper.getDeviceIcon(d.type),
                          onDelete: () => _confirmDeleteDevice(d),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- Dialogs & Actions ---
  void _showAddRoomDialog() {
    final controller = TextEditingController();
    _showAppDialog(
      title: 'Thêm phòng mới',
      hint: 'Tên phòng',
      controller: controller,
      onConfirm: () => _createRoom(controller.text.trim()),
    );
  }

  Future<void> _createRoom(String name) async {
    final roomApi = ref.read(roomApiProvider);
    final home = ref.read(selectedHomeProvider);
    if (home == null || name.isEmpty) return;
    try {
      await roomApi.createRoom(
        homeId: home.homeId,
        roomName: name,
        token: ref.read(authControllerProvider).value?.token ?? '',
      );
      await _loadRooms();
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showAddDeviceDialog(SmartRoom room) {
    final nameC = TextEditingController();
    final typeC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          'Thêm thiết bị',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameC,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Tên thiết bị',
                hintStyle: TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: typeC,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Loại (ví dụ: Light)',
                hintStyle: TextStyle(color: Colors.white38),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameC.text.isNotEmpty) {
                Navigator.pop(context);
                await _addDevice(room, nameC.text.trim(), typeC.text.trim());
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  Future<void> _addDevice(SmartRoom room, String name, String type) async {
    final roomApi = ref.read(roomApiProvider);
    try {
      await roomApi.createDevice(
        roomId: room.roomId,
        name: name,
        type: type.isEmpty ? 'Other' : type,
        token: ref.read(authControllerProvider).value?.token ?? '',
      );
      await _loadDevicesForRoom(room);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _confirmDeleteRoom(SmartRoom room) async {
    final roomApi = ref.read(roomApiProvider);
    final ok = await _showConfirmDialog(
      'Xác nhận xóa phòng',
      'Xóa phòng "${room.name}"? Toàn bộ thiết bị bên trong sẽ bị mất.',
    );
    if (ok) {
      try {
        await roomApi.deleteRoom(
          room.roomId,
          token: ref.read(authControllerProvider).value?.token ?? '',
        );
        await _loadRooms();
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  Future<void> _confirmDeleteDevice(SmartDevice d) async {
    final roomApi = ref.read(roomApiProvider);
    if (await _showConfirmDialog('Xóa thiết bị', 'Xóa "${d.name}"?')) {
      try {
        await roomApi.deleteDevice(
          d.deviceId,
          token: ref.read(authControllerProvider).value?.token ?? '',
        );
        if (_selectedRoom != null) _loadDevicesForRoom(_selectedRoom!);
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  void _showError(String m) {
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), backgroundColor: AppColors.error),
      );
  }

  void _showAppDialog({
    required String title,
    required String hint,
    required TextEditingController controller,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF262626),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            content: Text(
              content,
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _RoomGridItem extends StatelessWidget {
  final SmartRoom room;
  final bool isSelected;
  final VoidCallback onTap;
  const _RoomGridItem({
    required this.room,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              DesktopUIHelper.getRoomImage(room.name),
              width: 48,
              height: 48,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.room, color: Colors.white54, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              room.name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Text(
              '${room.devices.length} thiết bị',
              style: const TextStyle(fontSize: 12, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSecondary = false,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary
            ? Colors.white.withOpacity(0.1)
            : AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
