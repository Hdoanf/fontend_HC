import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: Row(
        children: [
          /// ================= SIDEBAR =================
          Container(
            width: 320,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 12),
              ],
            ),
            child: _sidebar(),
          ),

          /// ================= CONTENT =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _notificationSettings(),
                          const SizedBox(height: 32),
                          _deliverySettings(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SIDEBAR =================

  Widget _sidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.notifications_active,
          size: 56,
          color: AppColors.primary,
        ),
        const SizedBox(height: 20),
        const Text(
          'Notification Center',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Control how and when you receive alerts.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        _statusRow('System', enableAll),
        _statusRow('Security', securityAlert),
        _statusRow('Devices', deviceAlert),
        _statusRow('Energy', energyAlert),
      ],
    );
  }

  /// ================= NOTIFICATION =================

  Widget _notificationSettings() {
    return _card(
      title: 'Notification Settings',
      child: Column(
        children: [
          _switchTile(
            'Enable Notifications',
            'Turn on/off all notifications',
            enableAll,
                (v) => setState(() => enableAll = v),
          ),
          _divider(),
          _switchTile(
            'Device Alerts',
            'Device status & errors',
            deviceAlert,
            enableAll ? (v) => setState(() => deviceAlert = v) : null,
          ),
          _divider(),
          _switchTile(
            'Security Alerts',
            'Intrusion & safety alerts',
            securityAlert,
            enableAll ? (v) => setState(() => securityAlert = v) : null,
          ),
          _divider(),
          _switchTile(
            'Energy Usage Alerts',
            'High power consumption warnings',
            energyAlert,
            enableAll ? (v) => setState(() => energyAlert = v) : null,
          ),
        ],
      ),
    );
  }

  /// ================= DELIVERY =================

  Widget _deliverySettings() {
    return _card(
      title: 'Delivery Methods',
      child: Column(
        children: [
          _switchTile(
            'Push Notifications',
            'Receive alerts on device',
            pushNotify,
                (v) => setState(() => pushNotify = v),
          ),
          _divider(),
          _switchTile(
            'Email Notifications',
            'Receive alerts via email',
            emailNotify,
                (v) => setState(() => emailNotify = v),
          ),
          _divider(),
          _switchTile(
            'Do Not Disturb',
            'Mute notifications temporarily',
            doNotDisturb,
                (v) => setState(() => doNotDisturb = v),
          ),
        ],
      ),
    );
  }

  /// ================= COMPONENTS =================

  Widget _statusRow(String title, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Icon(
            active ? Icons.check_circle : Icons.cancel,
            color: active ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
      String title,
      String subtitle,
      bool value,
      ValueChanged<bool>? onChanged,
      ) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _divider() => const Divider(height: 28);

  Widget _card({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 16),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
