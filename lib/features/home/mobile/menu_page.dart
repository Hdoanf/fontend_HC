import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../settings/presentation/pages/mobile_settings_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
          'Menu',
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
              icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 22),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 32),
            _buildMenuSection(
              'Home Management',
              [
                _MenuItem(icon: Icons.home_rounded, title: 'My Home', color: Colors.blue, onTap: () => context.go('/')),
                _MenuItem(icon: Icons.grid_view_rounded, title: 'All Devices', color: Colors.orange, onTap: () => context.go('/devices')),
                _MenuItem(icon: Icons.location_on_rounded, title: 'Room Map', color: Colors.green, onTap: () => context.go('/rooms')),
              ],
            ),
            const SizedBox(height: 24),
            _buildMenuSection(
              'Insights & Control',
              [
                _MenuItem(icon: Icons.bar_chart_rounded, title: 'Energy Stats', color: Colors.purple, onTap: () => context.go('/stats')),
                _MenuItem(icon: Icons.access_time_filled_rounded, title: 'Schedule', color: Colors.teal, onTap: () => context.go('/scheduler')),
                _MenuItem(icon: Icons.history_rounded, title: 'Activity Log', color: Colors.brown, onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),
            _buildMenuSection(
              'Account & System',
              [
                _MenuItem(
                  icon: Icons.settings_rounded, 
                  title: 'Settings', 
                  color: Colors.blueGrey, 
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MobileSettingsPage()));
                  },
                ),
                _MenuItem(icon: Icons.help_outline_rounded, title: 'Support', color: Colors.indigo, onTap: () {}),
                _MenuItem(icon: Icons.logout_rounded, title: 'Logout', color: Colors.red, onTap: () => context.go('/sign-in')),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2)),
            child: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.OmJICjo6Xt-Ay8oWfxkGNQHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('User Name', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary, letterSpacing: -0.5)),
                const SizedBox(height: 2),
                Text('Standard Account', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textLight),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderColor, indent: 64),
            itemBuilder: (_, index) => items[index],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}
