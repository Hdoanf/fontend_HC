import 'package:flutter/material.dart';
import 'package:thuctap/core/utils/responsive_layout.dart';

import 'mobile/mobile_home.dart';
import 'desktop/desktop_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const MobileHomePage(),
      tablet: const DesktopHome(), // tablet dùng layout desktop gọn
      web: const DesktopHome(),
    );
  }
}
