import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuctap/core/widgets/app_button.dart';
import 'package:thuctap/core/widgets/app_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

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
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          /// Email
          const Text("Email", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          AppTextField(hint: "example@gmail.com"),

          const SizedBox(height: 12),

          /// Password
          const Text("Password", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          AppTextField(hint: "********", isPassword: true),

          const SizedBox(height: 12),

          /// Confirm password
          const Text("Re Password", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          AppTextField(hint: "********", isPassword: true),

          const SizedBox(height: 24),

          /// Sign Up button
          AppButton(text: "Sign Up"),

          const SizedBox(height: 20),

          /// Back to sign in
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                onTap: () {
                  context.go('/sign-in');
                },
                child: const Text(
                  'Sign In',
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
