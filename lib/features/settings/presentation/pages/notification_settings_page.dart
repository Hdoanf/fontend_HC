import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive_layout.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool enableAll = true;
  bool deviceAlert = true;
  bool securityAlert = true;
  bool energyAlert = false;
  bool emailNotify = true;
  bool pushNotify = true;
  bool doNotDisturb = false;

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
          'Notifications',
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
      ),
      body: ResponsiveLayout(
        mobile: _buildContent(isMobile: true),
        tablet: _buildContent(isMobile: false),
        web: _buildContent(isMobile: false),
      ),
    );
  }

  Widget _buildContent({required bool isMobile}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: 24,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) ...[
                const Text(
                  'Notification Center',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Control how and when you receive alerts.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
              ],
              _buildSectionCard(
                title: 'Alert Settings',
                children: [
                  _switchTile(
                    'Enable Notifications',
                    'Turn on/off all notifications',
                    enableAll,
                    (v) => setState(() => enableAll = v),
                    icon: Icons.notifications_active_rounded,
                  ),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _switchTile(
                    'Device Alerts',
                    'Device status & errors',
                    deviceAlert,
                    enableAll ? (v) => setState(() => deviceAlert = v) : null,
                    icon: Icons.devices_rounded,
                  ),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _switchTile(
                    'Security Alerts',
                    'Intrusion & safety alerts',
                    securityAlert,
                    enableAll ? (v) => setState(() => securityAlert = v) : null,
                    icon: Icons.shield_rounded,
                  ),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _switchTile(
                    'Energy Alerts',
                    'High consumption warnings',
                    energyAlert,
                    enableAll ? (v) => setState(() => energyAlert = v) : null,
                    icon: Icons.bolt_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Delivery Methods',
                children: [
                  _switchTile(
                    'Push Notifications',
                    'Receive alerts on device',
                    pushNotify,
                    (v) => setState(() => pushNotify = v),
                    icon: Icons.phonelink_ring_rounded,
                  ),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _switchTile(
                    'Email Notifications',
                    'Receive alerts via email',
                    emailNotify,
                    (v) => setState(() => emailNotify = v),
                    icon: Icons.alternate_email_rounded,
                  ),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _switchTile(
                    'Do Not Disturb',
                    'Mute notifications temporarily',
                    doNotDisturb,
                    (v) => setState(() => doNotDisturb = v),
                    icon: Icons.do_not_disturb_on_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool>? onChanged, {
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.success,
        ),
      ],
    );
  }
}
