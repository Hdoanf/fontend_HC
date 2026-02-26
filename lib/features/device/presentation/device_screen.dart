import 'package:flutter/material.dart';

import '../../../core/utils/responsive_layout.dart';
import '../../devices/desktop_devices_page.dart';
import '../../devices/mobile_devices_page.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: MobileDevicesPage(),
      tablet: DesktopDevicesPage(),
      web: DesktopDevicesPage(),
    );
  }
}
