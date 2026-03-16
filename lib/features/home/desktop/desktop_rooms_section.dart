import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/core/utils/desktop_ui_helper.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/location/data/models/home_model.dart';
import 'package:thuctap/features/location/data/models/room_model.dart';
import 'package:thuctap/features/location/presentation/providers/location_providers.dart';
import 'desktop_room_card.dart';

class DesktopRoomsSection extends ConsumerStatefulWidget {
  const DesktopRoomsSection({super.key});
  @override
  ConsumerState<DesktopRoomsSection> createState() =>
      _DesktopRoomsSectionState();
}

class _DesktopRoomsSectionState extends ConsumerState<DesktopRoomsSection> {
  List<HomeModel> _homes = [];
  List<RoomModel> _roomsFromApi = [];
  Map<int, int> _deviceCounts = {};
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
            HomeModel? match;
            if (currentSelected != null) {
              try {
                match = homes.firstWhere(
                  (h) => h.homeId == currentSelected.homeId,
                );
              } catch (_) {}
            }
            final nextHome = match ?? homes.first;
            ref.read(selectedHomeProvider.notifier).state = nextHome;
            _loadRoomsForHome(nextHome.homeId);
          } else {
            ref.read(selectedHomeProvider.notifier).state = null;
            _roomsFromApi = [];
            _isLoading = false;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRoomsForHome(int homeId) async {
    final roomApi = ref.read(roomApiProvider);
    final token = ref.read(authControllerProvider).value?.token ?? '';
    setState(() => _isLoading = true);
    try {
      final rooms = await roomApi.fetchRooms(homeId: homeId, token: token);
      final Map<int, int> counts = {};
      for (final room in rooms) {
        try {
          final devices = await roomApi.fetchDevicesByRoom(
            room.roomId,
            token: token,
          );
          counts[room.roomId] = devices.length;
        } catch (_) {
          counts[room.roomId] = 0;
        }
      }
      if (mounted) {
        setState(() {
          _roomsFromApi = rooms;
          _deviceCounts = counts;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted)
        setState(() {
          _roomsFromApi = [];
          _isLoading = false;
        });
    }
  }

  void _showAddHomeDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          'Thêm nhà mới',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Tên nhà',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                await _createHome(controller.text.trim());
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  Future<void> _createHome(String name) async {
    final homeApi = ref.read(homeApiProvider);
    final token = ref.read(authControllerProvider).value?.token ?? '';
    try {
      await homeApi.createHome(name: name, token: token);
      await _loadHomes();
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedHome = ref.watch(selectedHomeProvider);

    HomeModel? safeSelectedHome;
    if (selectedHome != null &&
        _homes.any((h) => h.homeId == selectedHome.homeId)) {
      safeSelectedHome = _homes.firstWhere(
        (h) => h.homeId == selectedHome.homeId,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(safeSelectedHome),
        const SizedBox(height: 24),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (_homes.isEmpty)
          _buildNoHomeState()
        else if (_roomsFromApi.isEmpty)
          _buildNoRoomState(safeSelectedHome?.name ?? '')
        else
          _buildRoomsGrid(l10n),
      ],
    );
  }

  Widget _buildSectionHeader(HomeModel? safeSelectedHome) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'My Home',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            if (_homes.isNotEmpty) _buildHomeDropdown(safeSelectedHome),
          ],
        ),
        IconButton(
          onPressed: _showAddHomeDialog,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: const Icon(Icons.add, color: AppColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeDropdown(HomeModel? safeSelectedHome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButton<HomeModel>(
        value: safeSelectedHome,
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
            _loadRoomsForHome(val.homeId);
          }
        },
      ),
    );
  }

  Widget _buildNoHomeState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.home_work_outlined, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'Bạn chưa có ngôi nhà nào.',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showAddHomeDialog,
            child: const Text('Tạo ngôi nhà đầu tiên'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRoomState(String homeName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.meeting_room_outlined,
              size: 64,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              'Nhà "$homeName" chưa có phòng nào.',
              style: const TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/rooms'),
              child: const Text('Tạo phòng ngay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsGrid(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth >= 1100
            ? (constraints.maxWidth >= 1400 ? 4 : 3)
            : 2;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: _roomsFromApi.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final room = _roomsFromApi[index];
            final count = _deviceCounts[room.roomId] ?? 0;
            return DesktopRoomCard(
              roomName: room.roomName,
              roomDetails: l10n.devicesCount(count),
              backgroundColor: DesktopUIHelper.getRoomColor(room.roomName),
              image: DesktopUIHelper.getRoomImage(room.roomName),
              onTap: () => context.go('/rooms?room=${room.roomName}'),
            );
          },
        );
      },
    );
  }

  void _showError(String msg) {
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
