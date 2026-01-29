import 'package:flutter/material.dart';
import 'package:thuctap/features/home/desktop/desktop_rooms_section.dart';
import 'package:thuctap/features/home/mobile/frequently_used_section.dart';
import 'desktop_header.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          DesktopHeader(),

          SizedBox(height: 24),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: DesktopRoomsSection()),
                SizedBox(width: 24),
                Expanded(flex: 2, child: FrequentlyUsedSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
