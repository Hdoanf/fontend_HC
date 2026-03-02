import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fire_alert_controller.dart';
import '../domain/fire_alert_state.dart';
import 'widgets/fire_alert_list.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class FireAlertScreen extends ConsumerWidget {
  const FireAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fireAlertControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Fire Alerts',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () => ref.read(fireAlertControllerProvider.notifier).markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatusCard(state: state),
            const SizedBox(height: 24),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : FireAlertList(
                      events: state.events,
                      onAcknowledge: (id) {
                        return ref
                            .read(fireAlertControllerProvider.notifier)
                            .acknowledgeAlert(id);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});
  final FireAlertState state;

  @override
  Widget build(BuildContext context) {
    final active = state.activeEvent;
    final isFire = state.isFireActive;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isFire ? const Color(0xFFFFECEC) : const Color(0xFFE8F8F5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isFire ? Colors.red : Colors.teal).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isFire ? Colors.red : Colors.teal).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFire ? Icons.local_fire_department_rounded : Icons.shield_rounded, 
              color: isFire ? const Color(0xFFB91C1C) : const Color(0xFF166534),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFire ? 'DANG CO CHAY!' : 'He thong an toan',
                  style: TextStyle(
                    color: isFire ? const Color(0xFFB91C1C) : const Color(0xFF166534),
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isFire 
                    ? 'Khu vuc: ${active?.zoneName ?? 'Unknown'}'
                    : 'Khong phat hien dau hieu chay',
                  style: TextStyle(
                    color: (isFire ? const Color(0xFFB91C1C) : const Color(0xFF166534)).withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (state.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.red.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                state.unreadCount > 99 ? '99+' : state.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
