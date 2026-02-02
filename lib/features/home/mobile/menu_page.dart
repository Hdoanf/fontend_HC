import 'package:flutter/material.dart';
import 'package:thuctap/features/settings/presentation/pages/mobile_settings_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: MobileSettingsPage()));
  }
}
