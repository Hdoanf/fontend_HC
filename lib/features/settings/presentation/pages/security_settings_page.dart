import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool twoFactorEnabled = true;
  bool biometricEnabled = false;

  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Security'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= LEFT =================
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildChangePasswordCard(),
                  const SizedBox(height: 24),
                  _buildSecurityOptionsCard(),
                ],
              ),
            ),

            const SizedBox(width: 32),

            /// ================= RIGHT =================
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildLoginActivityCard(),
                  const SizedBox(height: 24),
                  _buildDangerZoneCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= CHANGE PASSWORD =================

  Widget _buildChangePasswordCard() {
    return _card(
      title: 'Change Password',
      child: Column(
        children: [
          _passwordField('Current Password', _oldPasswordCtrl),
          const SizedBox(height: 16),
          _passwordField('New Password', _newPasswordCtrl),
          const SizedBox(height: 16),
          _passwordField('Confirm New Password', _confirmPasswordCtrl),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Handle change password
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              child: const Text('Update Password'),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECURITY OPTIONS =================

  Widget _buildSecurityOptionsCard() {
    return _card(
      title: 'Security Options',
      child: Column(
        children: [
          _switchTile(
            title: 'Two-Factor Authentication',
            subtitle: 'Add extra security to your account',
            value: twoFactorEnabled,
            onChanged: (v) => setState(() => twoFactorEnabled = v),
          ),
          const Divider(height: 32),
          _switchTile(
            title: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            value: biometricEnabled,
            onChanged: (v) => setState(() => biometricEnabled = v),
          ),
        ],
      ),
    );
  }

  /// ================= LOGIN ACTIVITY =================

  Widget _buildLoginActivityCard() {
    return _card(
      title: 'Login Activity',
      child: Column(
        children: const [
          _LoginItem(
            device: 'Chrome · Windows',
            location: 'Hanoi, Vietnam',
            time: 'Active now',
          ),
          Divider(height: 24),
          _LoginItem(
            device: 'iPhone 14',
            location: 'Ho Chi Minh City',
            time: '2 hours ago',
          ),
          Divider(height: 24),
          _LoginItem(
            device: 'iPad Pro',
            location: 'Da Nang',
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }

  /// ================= DANGER ZONE =================

  Widget _buildDangerZoneCard() {
    return _card(
      title: 'Danger Zone',
      borderColor: Colors.redAccent,
      child: Column(
        children: [
          const Text(
            'Log out from all devices',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            'This will log you out of all active sessions.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Logout all devices
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text('Logout All Devices'),
          ),
        ],
      ),
    );
  }

  /// ================= REUSABLE =================

  Widget _card({
    required String title,
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.5)
            : null,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 18),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _passwordField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// ================= LOGIN ITEM =================

class _LoginItem extends StatelessWidget {
  final String device;
  final String location;
  final String time;

  const _LoginItem({
    required this.device,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.devices, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(location,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(time,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
