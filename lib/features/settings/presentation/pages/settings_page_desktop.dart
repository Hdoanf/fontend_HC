import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/settings_tile.dart';

import 'edit_profile_page.dart';
import 'notification_settings_page.dart';
import 'security_settings_page.dart';
import 'language_settings_page.dart';
import 'about_page.dart';

class SettingsPageDesktop extends StatelessWidget {
  const SettingsPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                /// GRID SETTINGS
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 3.5,
                    children: [
                      SettingsTile(
                        icon: Icons.person,
                        title: 'Edit Profile',
                        subtitle: 'Change your personal information',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Manage notification preferences',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const NotificationPage(),
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        icon: Icons.security,
                        title: 'Security',
                        subtitle: 'Password & authentication',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SecurityPage(),
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: 'Select application language',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageSettingsPage(),
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Application information',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
