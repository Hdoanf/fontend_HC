import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.all(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= LEFT =================
              Expanded(
                flex: 2,
                child: _buildAppInfoCard(),
              ),
              const SizedBox(width: 32),

              /// ================= RIGHT =================
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildAboutSection(),
                    const SizedBox(height: 24),
                    _buildLegalSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= APP INFO =================

  Widget _buildAppInfoCard() {
    return _card(
      child: Column(
        children: [
          const Icon(
            Icons.electric_bolt,
            size: 72,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Smart Home Manager',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _infoRow('Platform', 'Desktop / Web'),
          _infoRow('Build', '2025.02'),
          _infoRow('Developer', 'HC Team'),
        ],
      ),
    );
  }

  /// ================= ABOUT =================

  Widget _buildAboutSection() {
    return _card(
      title: 'About Application',
      child: const Text(
        'Smart Home Manager is a modern platform that allows users to monitor, '
            'control, and automate smart devices across their home. '
            'It provides real-time statistics, scheduling, and secure access '
            'across multiple devices.',
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  /// ================= LEGAL =================

  Widget _buildLegalSection() {
    return _card(
      title: 'Legal & Support',
      child: Column(
        children: [
          _actionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Navigate to Privacy Policy
            },
          ),
          const Divider(height: 24),
          _actionTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              // TODO: Navigate to Terms
            },
          ),
          const Divider(height: 24),
          _actionTile(
            icon: Icons.code_outlined,
            title: 'Open Source Licenses',
            onTap: () {
              // TODO: showLicensePage(context: context);
            },
          ),
          const Divider(height: 24),
          _actionTile(
            icon: Icons.support_agent_outlined,
            title: 'Contact Support',
            onTap: () {
              // TODO: Open email or support page
            },
          ),
        ],
      ),
    );
  }

  /// ================= REUSABLE =================

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _card({
    String? title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 18),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }
}
