import 'package:flutter/material.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_text_field.dart';

class ProfileEditDesktop extends StatelessWidget {
  const ProfileEditDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 560,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          const SizedBox(height: 32),
          _avatar(),
          const SizedBox(height: 32),
          _form(context),
          const SizedBox(height: 40),
          _actions(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Text(
          l10n.t('Profile Edit'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        const Spacer(),
        const Icon(Icons.more_vert, color: Colors.white54),
      ],
    );
  }

  Widget _avatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: ClipOval(
            child: Image.network(
              'https://i.pravatar.cc/300?img=12',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.white.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 48, color: Colors.white24),
                );
              },
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(l10n.t('Name')),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('Linh')),

        const SizedBox(height: 20),
        _fieldLabel(l10n.t('Email')),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('Linh@gmail.com')),

        const SizedBox(height: 20),
        _fieldLabel(l10n.t('Address')),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('abc')),

        const SizedBox(height: 20),
        _fieldLabel(l10n.t('Home Name')),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('ngoi nha hanh puc')),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70, fontSize: 13),
    );
  }

  Widget _actions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
              foregroundColor: Colors.white70,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.t('Cancel')),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(
            text: l10n.t('Save Changes'), 
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
