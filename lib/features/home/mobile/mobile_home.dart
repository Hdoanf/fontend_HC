import 'package:flutter/material.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/constants/app_sizes.dart';
import 'package:thuctap/features/home/mobile/frequently_used_section.dart';
import 'package:thuctap/features/home/mobile/header_widget.dart';
import 'package:thuctap/features/home/mobile/menu_page.dart';
import 'package:thuctap/features/home/mobile/rooms_section.dart';
import '';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(Icons.menu, color: AppColors.textPrimary),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(
                Icons.notifications_none,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderWidget(),
            const SizedBox(height: AppSizes.paddingLarge),
            const RoomsSection(),
            const SizedBox(height: AppSizes.paddingLarge),
            const FrequentlyUsedSection(),
            const SizedBox(height: AppSizes.paddingXLarge),
          ],
        ),
      ),
    );
  }
}
