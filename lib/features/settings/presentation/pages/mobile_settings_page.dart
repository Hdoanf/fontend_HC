import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class MobileSettingsPage extends StatelessWidget {
  const MobileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSectionTitle('Account Settings'),
          _buildSettingsItem(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              context.push('/profile-edit-mobile');
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              context.push('/change-pass');
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.email_outlined,
            title: 'Email Preferences',
            onTap: () {
              // Navigate to email preferences page
            },
          ),
          const Divider(height: 30, thickness: 1, color: AppColors.borderColor),
          _buildSettingsSectionTitle('Notification Settings'),
          _buildSettingsToggleItem(
            context,
            icon: Icons.notifications_none,
            title: 'Push Notifications',
            value: true, // Example value
            onChanged: (bool value) {
              // Handle push notification toggle
            },
          ),
          _buildSettingsToggleItem(
            context,
            icon: Icons.volume_up_outlined,
            title: 'Sound Alerts',
            value: false, // Example value
            onChanged: (bool value) {
              // Handle sound alerts toggle
            },
          ),
          const Divider(height: 30, thickness: 1, color: AppColors.borderColor),
          _buildSettingsSectionTitle('Appearance'),
          _buildSettingsItem(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Theme',
            subtitle: 'System Default',
            onTap: () {
              // Navigate to theme selection page
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.font_download_outlined,
            title: 'Font Size',
            subtitle: 'Medium',
            onTap: () {
              // Navigate to font size selection page
            },
          ),
          const Divider(height: 30, thickness: 1, color: AppColors.borderColor),
          _buildSettingsSectionTitle('About'),
          _buildSettingsItem(
            context,
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {
              // Show app version details
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // Open privacy policy
            },
          ),
          _buildSettingsItem(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              // Open terms of service
            },
          ),
        ],
      ),
    );
  }

  // Helper widget to build a section title
  Widget _buildSettingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // Helper widget to build a settings list item
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      color: AppColors.surfaceLight,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textLight,
        ),
        onTap: onTap,
      ),
    );
  }

  // Helper widget to build a settings toggle item
  Widget _buildSettingsToggleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: AppColors.surfaceLight,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        activeColor: AppColors.primary,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        secondary: Icon(icon, color: AppColors.primary),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
