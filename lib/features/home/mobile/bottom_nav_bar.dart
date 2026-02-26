import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final int fireAlertBadgeCount;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.fireAlertBadgeCount = 0,
  });

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktop(context);

    return Container(
      width: isDesktop ? 240 : null,
      height: isDesktop ? null : 64,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: isDesktop
              ? BorderSide.none
              : BorderSide(color: AppColors.borderColor, width: 1),
          right: isDesktop
              ? BorderSide(color: AppColors.borderColor, width: 1)
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      child: isDesktop ? _buildSidebar() : _buildBottomBar(),
    );
  }

  /// -------- MOBILE --------
  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _items(),
    );
  }

  /// -------- DESKTOP --------
  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._items(isSidebar: true),
        const Spacer(),
      ],
    );
  }

  List<Widget> _items({bool isSidebar = false}) {
    return [
      _NavBarItem(
        icon: Icons.home,
        isSelected: selectedIndex == 0,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(0),
      ),
      _NavBarItem(
        icon: Icons.devices,
        isSelected: selectedIndex == 1,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(1),
      ),
      _NavBarItem(
        icon: Icons.location_on,
        isSelected: selectedIndex == 2,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(2),
      ),
      _NavBarItem(
        icon: Icons.bar_chart,
        isSelected: selectedIndex == 3,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(3),
      ),
      _NavBarItem(
        icon: Icons.schedule,
        isSelected: selectedIndex == 4,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(4),
      ),
      _NavBarItem(
        icon: Icons.local_fire_department,
        isSelected: selectedIndex == 5,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(5),
        badgeCount: fireAlertBadgeCount,
      ),
      _NavBarItem(
        icon: Icons.settings,
        isSelected: selectedIndex == 6,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(6),
      ),
    ];
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final bool isSidebar;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isSidebar = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: isSidebar ? 6 : 0),
        padding: EdgeInsets.symmetric(
          horizontal: isSidebar
              ? AppSizes.paddingMedium
              : AppSizes.paddingSmall,
          vertical: AppSizes.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: AppSizes.iconLarge,
            ),
            if (badgeCount > 0)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
