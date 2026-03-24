import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive_layout.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  String _selectedTheme = 'System';
  double _fontSize = 14.0;

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
          'Appearance',
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
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
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
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) ...[
                const Text(
                  'Theme & Display',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -1),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Customize how Smart Hub looks on your device.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
              ],
              _buildSectionCard(
                title: 'Color Theme',
                children: [
                  _themeOption('Light', Icons.light_mode_rounded),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _themeOption('Dark', Icons.dark_mode_rounded),
                  const Divider(height: 32, color: AppColors.borderColor),
                  _themeOption('System', Icons.settings_brightness_rounded),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Text Size',
                children: [
                  Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12.0,
                          max: 20.0,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _fontSize = val),
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Sample Text Preview',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
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
          BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5)),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _themeOption(String label, IconData icon) {
    final isSelected = _selectedTheme == label;
    return InkWell(
      onTap: () => setState(() => _selectedTheme = label),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isSelected ? AppColors.primary : AppColors.surfaceGray, shape: BoxShape.circle),
              child: Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24)
            else
              Icon(Icons.radio_button_off_rounded, color: AppColors.textLight.withValues(alpha: 0.5), size: 24),
          ],
        ),
      ),
    );
  }
}
