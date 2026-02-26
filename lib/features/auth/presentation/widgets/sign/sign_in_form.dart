import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../data/models/auth_session.dart';
import '../../login_controller.dart';
import 'social_buttons.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'demo@example.com');
    _passwordController = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue<AuthSession?>>(authControllerProvider, (
      previous,
      next,
    ) {
      final currentError = next.error;
      if (currentError != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(currentError.toString())));
      }

      final wasSignedOut = previous?.valueOrNull == null;
      final isSignedIn = next.valueOrNull != null;
      if (wasSignedOut && isSignedIn) {
        context.go('/');
      }
    });

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          const Text(
            "Sign In",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          /// Email
          const Text("Email", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          AppTextField(hint: "example@gmail.com", controller: _emailController),

          const SizedBox(height: 12),

          /// Password
          const Text("Password", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          AppTextField(
            hint: "********",
            isPassword: true,
            controller: _passwordController,
          ),

          const SizedBox(height: 12),

          /// Forgot password
          Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blue.shade600, fontSize: 13),
          ),

          const SizedBox(height: 20),

          /// Sign In button
          AppButton(
            text: isLoading ? "Signing in..." : "Sign In",
            onTap: isLoading
                ? null
                : () {
                    ref
                        .read(authControllerProvider.notifier)
                        .signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                  },
          ),
          const SizedBox(height: 8),

          /// Go to Home button
          AppButton(
            text: "Go to Home",
            onTap: () {
              context.go('/');
            },
          ),

          const SizedBox(height: 20),

          /// OR divider
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Or"),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),

          const SizedBox(height: 20),

          /// Social buttons
          const SocialButtons(),

          const SizedBox(height: 20),

          /// Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(" "),
              GestureDetector(
                onTap: () {
                  context.go('/sign-up');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
