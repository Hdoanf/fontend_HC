import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/widgets/app_button.dart';
import 'package:thuctap/core/widgets/app_text_field.dart';
import 'package:thuctap/core/widgets/top_notice.dart';
import 'package:thuctap/core/constants/app_colors.dart';
import 'package:thuctap/core/localization/app_localizations.dart';
import '../../login_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password != confirm) {
      showTopNotice(
        context: context,
        message: 'Mật khẩu nhập lại không khớp',
        type: TopNoticeType.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final success = await ref.read(authControllerProvider.notifier).signUp(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        showTopNotice(
          context: context,
          message: 'Đăng ký và đăng nhập thành công!',
          type: TopNoticeType.success,
        );
        context.go('/');
      } else {
        final state = ref.read(authControllerProvider);
        showTopNotice(
          context: context,
          message: state.error?.toString() ?? 'Đăng ký thất bại',
          type: TopNoticeType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopNotice(
        context: context,
        message: e.toString(),
        type: TopNoticeType.error,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(Icons.hub_rounded, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Create Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Join us to start managing your smart home",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildFieldLabel("Full Name"),
          AppTextField(hint: "John Doe", controller: _nameController),
          const SizedBox(height: 20),
          _buildFieldLabel("Email Address"),
          AppTextField(hint: "example@gmail.com", controller: _emailController),
          const SizedBox(height: 20),
          _buildFieldLabel("Password"),
          AppTextField(
            hint: "********",
            isPassword: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 20),
          _buildFieldLabel("Confirm Password"),
          AppTextField(
            hint: "********",
            isPassword: true,
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 32),
          AppButton(
            text: _isSubmitting ? "Creating Account..." : "Sign Up",
            onTap: _isSubmitting ? null : _submit,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/sign-in'),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
