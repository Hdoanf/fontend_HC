import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import 'social_buttons.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
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
          const AppTextField(hint: "example@gmail.com"),

          const SizedBox(height: 12),

          /// Password
          const Text("Password", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          const AppTextField(hint: "********", isPassword: true),

          const SizedBox(height: 12),

          /// Forgot password
          Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blue.shade600, fontSize: 13),
          ),

          const SizedBox(height: 20),

          /// Sign In button
          AppButton(text: "Sign In"),
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
