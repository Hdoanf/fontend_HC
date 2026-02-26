import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../widgets/sign/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        /// 📱 MOBILE
        mobile: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(child: SignInForm()),
              ),
            );
          },
        ),

        /// 📱 TABLET
        tablet: Center(child: SizedBox(width: 420, child: SignInForm())),

        /// 🌐 WEB
        web: Row(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1522202176988-66273c2fd55f',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 420, child: Center(child: SignInForm())),
          ],
        ),
      ),
    );
  }
}
