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

    if (isDesktop) {
      return Container(
        width: 240,
        decoration: const BoxDecoration(
          color: AppColors.desktopSidebar,
          border: Border(
            right: BorderSide(color: AppColors.desktopBorderColor, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        child: _buildSidebar(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: 12,
          ),
          child: _buildBottomBar(),
        ),
      ),
    );
  }

  /// -------- MOBILE --------
  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        icon: Icons.home_rounded,
        isSelected: selectedIndex == 0,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(0),
      ),
      _NavBarItem(
        icon: Icons.grid_view_rounded,
        isSelected: selectedIndex == 1,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(1),
      ),
      _NavBarItem(
        icon: Icons.location_on_rounded,
        isSelected: selectedIndex == 2,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(2),
      ),
      _NavBarItem(
        icon: Icons.bar_chart_rounded,
        isSelected: selectedIndex == 3,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(3),
      ),
      _NavBarItem(
        icon: Icons.access_time_filled_rounded,
        isSelected: selectedIndex == 4,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(4),
      ),
      _NavBarItem(
        icon: Icons.local_fire_department_rounded,
        isSelected: selectedIndex == 5,
        isSidebar: isSidebar,
        onTap: () => onItemSelected(5),
        badgeCount: fireAlertBadgeCount,
      ),
      _NavBarItem(
        icon: Icons.settings_rounded,
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
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: isSidebar ? 6 : 0),
        padding: EdgeInsets.symmetric(
          horizontal: isSidebar ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.7),
              size: 26,
            ),
            if (badgeCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surfaceLight, width: 1.5),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
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
