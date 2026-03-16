import 'package:flutter/material.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_text_field.dart';

class ChangePass extends StatelessWidget {
  const ChangePass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(context),
              const SizedBox(height: 24),
              _form(context),
              const SizedBox(height: 32),
              _actions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Text(
          l10n.t('Change Password'),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Icon(Icons.more_vert),
      ],
    );
  }

  Widget _form(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('Old Password'),
            style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('*******')),

        const SizedBox(height: 16),
        Text(l10n.t('New Password'),
            style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('******')),

        const SizedBox(height: 16),
        Text(l10n.t('Confirm Password'),
            style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        AppTextField(hint: l10n.t('*******')),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: Text(l10n.t('Cancel')),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(text: l10n.t('Save'), onTap: () {}),
        ),
      ],
    );
  }
}
