import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive_layout.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
          'About',
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
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) ...[
                const Text(
                  'About Application',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -1),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Learn more about Smart Home Manager.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
              ],
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildAppInfoCard()),
                        const SizedBox(width: 24),
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
                    );
                  } else {
                    return Column(
                      children: [
                        _buildAppInfoCard(),
                        const SizedBox(height: 24),
                        _buildAboutSection(),
                        const SizedBox(height: 24),
                        _buildLegalSection(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return _card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.hub_rounded, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          const Text(
            'Smart Hub',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 16),
          _infoRow('Platform', 'Cross-platform'),
          _infoRow('Build', '2026.02.28'),
          _infoRow('Developer', 'Gemini CLI Team'),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return _card(
      title: 'Our Vision',
      child: const Text(
        'Smart Home Manager is a modern platform that allows users to monitor, '
        'control, and automate smart devices across their home. '
        'It provides real-time statistics, scheduling, and secure access '
        'across multiple devices.',
        style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLegalSection() {
    return _card(
      title: 'Legal & Support',
      child: Column(
        children: [
          _actionTile(icon: Icons.privacy_tip_rounded, title: 'Privacy Policy', onTap: () {}),
          const Divider(height: 32, color: AppColors.borderColor),
          _actionTile(icon: Icons.description_rounded, title: 'Terms of Service', onTap: () {}),
          const Divider(height: 32, color: AppColors.borderColor),
          _actionTile(icon: Icons.code_rounded, title: 'Open Source Licenses', onTap: () {}),
          const Divider(height: 32, color: AppColors.borderColor),
          _actionTile(icon: Icons.support_agent_rounded, title: 'Contact Support', onTap: () {}),
        ],
      ),
    );
  }

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _actionTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _card({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
          if (title != null) ...[
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5)),
            const SizedBox(height: 24),
          ],
          child,
        ],
      ),
    );
  }
}
