import 'package:flutter/material.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import '../widgets/settings_tile.dart';
import 'edit_profile_page.dart';
import 'notification_settings_page.dart';
import 'security_settings_page.dart';
import 'language_settings_page.dart';
import 'about_page.dart';
import 'appearance_page.dart';

class SettingsPageDesktop extends StatelessWidget {
  const SettingsPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.t('Settings'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, mainAxisSpacing: 24, crossAxisSpacing: 24, childAspectRatio: 3.2,
                children: [
                  SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: l10n.t('Edit Profile'),
                    subtitle: l10n.t('Change your personal information'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())),
                  ),
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    title: l10n.t('Appearance'),
                    subtitle: l10n.t('Theme & Display Settings'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppearancePage())),
                  ),
                  SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.t('Notifications'),
                    subtitle: l10n.t('Manage notification preferences'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage())),
                  ),
                  SettingsTile(
                    icon: Icons.security_rounded,
                    title: l10n.t('Security'),
                    subtitle: l10n.t('Password & authentication'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPage())),
                  ),
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: l10n.t('Language'),
                    subtitle: l10n.t('Select application language'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSettingsPage())),
                  ),
                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: l10n.t('About'),
                    subtitle: l10n.t('Application information'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
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
