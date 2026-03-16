import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import 'package:thuctap/core/utils/desktop_ui_helper.dart';
import 'package:thuctap/features/auth/presentation/providers/auth_providers.dart';
import 'package:thuctap/features/location/data/models/device_model.dart';
import 'package:thuctap/features/location/presentation/providers/location_providers.dart';
import 'desktop_device_card.dart';

class FrequentlyUsedSection extends ConsumerStatefulWidget {
  const FrequentlyUsedSection({super.key});
  @override
  ConsumerState<FrequentlyUsedSection> createState() => _FrequentlyUsedSectionState();
}

class _FrequentlyUsedSectionState extends ConsumerState<FrequentlyUsedSection> {
  List<DeviceModel> _allDevices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAllDevices());
  }

  Future<void> _loadAllDevices() async {
    final roomApi = ref.read(roomApiProvider);
    final selectedHome = ref.read(selectedHomeProvider);
    if (selectedHome == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final token = ref.read(authControllerProvider).value?.token ?? '';
    if (mounted) setState(() => _isLoading = true);
    
    try {
      final rooms = await roomApi.fetchRooms(homeId: selectedHome.homeId, token: token);
      List<DeviceModel> tempDevices = [];
      for (final room in rooms) {
        try {
          final devices = await roomApi.fetchDevicesByRoom(room.roomId, token: token);
          tempDevices.addAll(devices);
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          _allDevices = tempDevices;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(selectedHomeProvider, (_, __) => _loadAllDevices());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.frequentlyUsed, style: const TextStyle(fontSize: AppSizes.fontXLarge, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            _SeeAllButton(onTap: _showAllDevicesDialog, label: l10n.seeAll),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        if (_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
        else if (_allDevices.isEmpty)
          const Text('Chưa có thiết bị nào.', style: TextStyle(color: Colors.grey))
        else
          ..._allDevices.take(3).map((d) => _DeviceCardWrapper(device: d, l10n: l10n)).toList(),
      ],
    );
  }

  void _showAllDevicesDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: const Text('Tất cả thiết bị', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        content: SizedBox(
          width: 500,
          child: _allDevices.isEmpty
            ? const Center(child: Text('Chưa có thiết bị nào.', style: TextStyle(color: Colors.white54)))
            : ListView.separated(
                shrinkWrap: true,
                itemCount: _allDevices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _DeviceCardWrapper(device: _allDevices[index], l10n: l10n, isDark: true),
              ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
      ),
    );
  }
}

class _SeeAllButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const _SeeAllButton({required this.onTap, required this.label});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: AppSizes.fontMedium, color: AppColors.primary, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _DeviceCardWrapper extends StatelessWidget {
  final DeviceModel device;
  final AppLocalizations l10n;
  final bool isDark;
  const _DeviceCardWrapper({required this.device, required this.l10n, this.isDark = true});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DesktopDeviceCard(
        deviceId: device.deviceId,
        deviceName: device.name,
        status: device.isActive ? l10n.connected : l10n.disconnected,
        isConnected: device.isActive,
        initialIsOn: device.status,
        icon: DesktopUIHelper.getDeviceIcon(device.type),
        isDark: isDark,
      ),
    );
  }
}
